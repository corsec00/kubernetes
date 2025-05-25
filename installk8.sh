# Instala a última versão do Kubernetes e suas dependências
#!/bin/bash
set -e
# Verifica se o usuário é root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script deve ser executado como root. Use 'sudo' ou faça login como root."
    exit 1
fi
# Configura o firewall (Kubernetes)
ufw allow 6443/tcp
ufw allow 2379:2380/tcp
ufw allow 10250/tcp
ufw allow 10251/tcp
ufw allow 10252/tcp
ufw allow 30000:32767/tcp
ufw enable

# Atualiza o sistema
apt-get update -y && apt-get upgrade -y

# Instala as ferramentas necessárias
apt-get install -y ca-certificates curl conntrack iptables ebtables socat jq apt-transport-https gnupg2 software-properties-common lsb-release

# Adiciona a chave GPG do repositório do Docker e do Kubernetes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Adiciona o repositório do Docker e do Kubernetes (1.33)
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Atualiza os repositórios do Docker & Kubernetes
apt-get update -y

# Modulos de Kernel habilitados
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Desativar o SWAP nas VMs
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
# Instala o Docker, kubelet, kubeadm e kubectl
apt-get install -y docker-ce docker-ce-cli containerd.io kubelet kubeadm kubectl
containerd config default > /etc/containerd/config.toml

# Marca para não atualizar automaticamente
apt-mark hold kubelet kubeadm kubectl


# Habilitando Cgroup Systemd no containerd
sed -i 's|SystemdCgroup = false|SystemdCgroup = true|' /etc/containerd/config.toml
systemctl restart containerd
systemctl status containerd
# Adiciona o usuário atual ao grupo docker
usermod -aG docker $USER
# Reinicia o serviço do Docker
systemctl restart docker
# Inicia o serviço do Kubelet
systemctl enable kubelet
systemctl start kubelet

# Inicializa o Cluster (apenas no ControlPlane) - ao final, copiar o comando de join para adicionar Workers e Controlplanes: 
# kubeadm join controlplane.k8s.lab:6443 --token icx5ve.8ck7zw0aubuotvjb --discovery-token-ca-cert-hash sha256:bc81a4f1107e97155ab8e55ac38005155846deff2183642d0249ce882240bb64
# kubeadm join controlplane.k8s.lab:6443 --token icx5ve.8ck7zw0aubuotvjb --discovery-token-ca-cert-hash sha256:bc81a4f1107e97155ab8e55ac38005155846deff2183642d0249ce882240bb64 --control-plane --certificate-key 2cc5222810f9dfd5a729af1c635ce5395f1458d7e123e12f823d633ed4312ab6

kubeadm init --upload-certs --control-plane-endpoint=$(hostname) --apiserver-advertise-address $(hostname -I | cut -d' ' -f1) --cri-socket unix:///var/run/containerd/containerd.sock --pod-network-cidr 192.168.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Instala o Calico como CNI
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/refs/heads/master/manifests/tigera-operator.yaml
# baixe e altere o arquivo custom-resources.yaml para que o CIDR seja o mesmo especificado no --pod-network-cidr 192.168.0.0/16
curl https://raw.githubusercontent.com/projectcalico/calico/master/manifests/custom-resources.yaml -O
kubectl create -f custom-resources.yaml

# No Worker01 e Worker02 - ver linha 69 e 70
kubeadm join controlplane.k8s.lab:6443 --token icx5ve.8ck7zw0aubuotvjb --discovery-token-ca-cert-hash sha256:bc81a4f1107e97155ab8e55ac38005155846deff2183642d0249ce882240bb64
# Como descobrir o valor <token> e <hash>?
# kubeadm token list
# kubeadm token create --print-join-command

kubectl get nodes

# Configurações e Plugins adicionais do kubectl
# ref.: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# Kubectl Bash-Completion
apt-get install -y bash-completion
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc