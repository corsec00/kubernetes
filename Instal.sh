# No CP, após configurar os nós
kubectl get nodes
kubectl get pods -A


# Instalação do Tigera Calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml
# ou kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Altere o CIDR  (ver linha 70)
curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/custom-resources.yaml -O

nano custom-resources.yaml

kubectl create -f custom-resources.yaml
# on error, kubectl delete -f custom-resources.yaml e refaça
# kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml
# TS
kubectl describe pod calico-node -n calico-system
kubectl describe pode (nome) -n (namespace)
#Instalar os plugins do KubeCTL 
sudo apt-get install bash-completion
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc
source /etc/profile.d/bash_completion.sh

# Modo não privilegiado
kubectl api-versions
kubectl proxy --port=8080 # não sai
kubectl api-resources

#Alterar o Kubernet API para habilitar o swagger
kubectl create ns teste # criando um namespace
kubectl get ns
# kubectl delete ns teste
# Podnginx.yaml
# ----------------------------
kubectl create -f podnginx.yaml
kubectl run nginx --image=nginx # modo interativo

kubectl delete podnginx.yaml --force -grace-period 0

### Testar os comandos:
# Listando Pods
kubectl get pods
kubectl get pods -o wide
kubectl get pods nginx -o yaml
kubectl get pods --namespace default
# Verificando detalhes do POD
kubectl describe pods/nginx
# Acessando um Pod
kubectl port-forward nginx 8080:80
# Olhando os Logs do Pod
kubectl logs nginx
# Executando comandos
kubectl exec nginx -- ls /etc/nginx
kubectl exec -ti nginx -- bash
# Transferindo arquivos do container para o host
kubectl cp nginx:/usr/share/nginx/html/index.html nginx_index_pod.html
# Transferindo arquivos para container 
kubectl cp nginx_index_pod.html nginx:/usr/share/nginx/html/index.htm


kubectl get service
kubectl logs <podname>

# Instalando o Healm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm repo add grafana https://grafana.github.io/helm-charts


 cat .kube/config
 # Ver o  server: https://controlplane.k8s.lab:6443

kubectl get ns  #listar os namespace
kubectl get all -n calico # lista os recursos em um Namespace chamado calico

kubectl get all --all-namespaces ou kubectl get all,po,svc -A
kubectl config -set-context --current --namespace =<novo_namespace> # a partir de então, esse será o NS retornado se nada for explicitamente informado
kubectl api-resources #lista os shortnames
kubectl describe ns <nome do NS> # ver os detalhes
cria um YAML

apiVersion: v1
kind: namespace
metadata:
 name: backend
kubectl delete ns backend --force --grace-period=0



kubectl get all --all-namespaces ou kubectl get all,po,svc -A
kubectl config -set-context --current --namespace =<novo_namespace> # a partir de então, esse será o NS retornado se nada for explicitamente informado
kubectl api-resources #lista os shortnames
kubectl describe ns <nome do NS> # ver os detalhes
cria um YAML

apiVersion: v1
kind: namespace
metadata:
 name: backend
kubectl delete ns backend --force --grace-period=0

kubectl create namespace frontend
nano replicaset.yaml
kubectl create -f replicaset.yaml
cp replicaset.yaml deploy.yaml
nano deploy.yaml
kubectl create -f deploy.yaml
get all -n front
k get all -n default


# Volumes Efêmeros
nano volume.yaml
k create -f volume.yaml
k apply -f volume.yaml
k get pods
kubectl exec -ti alpine-vol-empty-deploy-88967bd4c-h7rlh -c pod-emptydir-container-1 -- cat /cache1/log.txt
k describe deployments.apps  alpine-vol-empty-deploy

# Volumes Persistentes ??
Nano volume-persist.yaml
k apply -f volume-persist.yaml
k describe deployments.apps
k describe deployments.apps alpine-vol-hostpath-deploy
k events -n default 
k get deployments.apps
k describe replicasets.apps alpine-vol-hostpath-deploy [tab]
k get pod
k exec -ti alpine-vol-hostpath-deploy [tab] -- sh

k api-resources
# persistentvolumes: pv

#Persistent Volumes NFS
# CP
sudo -i
apt update
apt install -y nfs-kernel-server nfs-common
mkdir -p /opt/dados/manual
chmod 1777 /opt/dados/manual
echo "/opt/dados/manual *(rw,sync,no_root_squash,subtree_check)" >> /etc/exports
exportfs -a
systemctl restart nfs-kernel-server
touch /opt/dados/manual/teste_nfs.txt

# Workers
sudo -i
apt install nfs-common

nano pv-01.yaml
nano pvc-01.yaml
nano nginx-local.yaml 

k apply -f pv-01.yaml
k apply -f pvc-01.yaml
k apply -f nginx-local.yaml 

sudo -i 
mkdir /opt/dados-storageclass
chmod 1777 /opt/dados-storageclass/
echo "/opt/dados-storageclass  *(rw,sync,no_root_squash,subtree_check)" >> /etc/exports
exportfs -a
systmctl restart nfs-kernel-server

nano confmap.yaml
nano nginx-my.yaml
k apply -f confmap.yaml
k apply -f nginx-my.yaml
k exec -ti nginx-cm -- bash -c set
k exec -ti  nginx-cm -- sh -c 'echo $VAR_COMP'

cp nginx-my.yaml nginx-my-val.yaml
k apply -f nginx-my-val.yaml
k exec -ti nginx-cm-vol -- bash -c set


k apply -f frutas-deploy.yaml
k create configmap tipo-fruta --from-literal=frutas=uva
k port-forward s 8080:80
k port-forward services/ 8080:80
k port-forward services/frutas-service 5678:5678
k edit configmap tipo-fruta # edição à quente
k rollout restart deployment frutas-cm-deployment
k port-forward services/frutas-service 5678:5678

# outra interface
curl localhost:5678
k delete po frutas-cm-deploy-[tab]

nano index.html
kubectl create configmap dados-site --from-file=.index.html

echo "<html><h1>Sejam Bem vindos</h1></br><h1> Aqui é o conteúdo originado do ConfigMap </h1> </html>" > index.html
nano web.yaml
k apply -f web.yaml
k port-forward services/nginx-service 8080:80

    curl hostname:8080


# 153 - 155
openssl rand -base64 256 >> secret.txt
k create secret generic db-credenciais --from-file=./username.txt --from-file=./password.txt


#################################################################
#################################################################
############################# MyLab #############################
#################################################################
#################################################################
# controlplane    10.1.5.100   ping controlplane.k8s.lab
# worker01    10.1.5.101  ping worker01.k8s.lab
# worker02    10.1.5.102 ping worker02.k8s.lab

### Instalação de pre requisitos
echo '10.0.1.4    cplss01.k8s.lab'  >> /etc/hosts
echo '10.0.1.4    cplss01'  >> /etc/hosts

echo '10.0.1.5    wlss01.k8s.lab' >> /etc/hosts
echo '10.0.1.5    wlss01' >> /etc/hosts

echo '10.0.1.6    wlss02.k8s.lab' >> /etc/hosts
echo '10.0.1.6    wlss02' >> /etc/hosts

# Se não usar o comando abaixo, sepre usar o sudo antes dos comandos "sudo -i"
# Criando SSH
ssh-keygen
cat ~/.ssh/id_rsa.pub
# Desativar o SSH com senha
sudo nano /etc/ssh/sshd_config # PasswordAuthentication no
# Restart no SSH
systemctl restart ssh

# Liberação das ports no Firewall
# ControlPlane
ufw allow 6443/tcp
ufw allow 2379:2380/tcp
ufw allow 10250/tcp
ufw allow 10259/tcp
ufw allow 10257/tcp
ufw allow 8080/tcp
# Workers
ufw allow 10250/tcp
ufw allow 30000:32767/tcp
ufw allow 8080/tcp
# ou sudo ufw disable


# Atualizando
apt update && apt upgrade -y
apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release net-tools


# Instalação do Docker
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Instalação de Container
apt update && apt install -y containerd.io
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd
# systemctl status containerd

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
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Snapshot feito para as 3 VMs

## Zerando outra instalação
# apt remove kubelet kubectl kubeadm containerd.io apt-transport-https ca-certificates gnupg2 lsb-release
# apt install kubelet kubectl kubeadm containerd.io apt-transport-https ca-certificates gnupg2 lsb-release
# rm /etc/apt/sources.list.d/kubernetes.list 

### Instalação do Kubernetes
rm /etc/apt/sources.list.d/kubernetes.list 
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt update && apt install -y  kubelet kubectl kubeadm ############################################

apt-mark hold kubelet kubeadm kubectl
systemctl enable kubelet

# !!!!! Apenas na CONTROLPLANE (cp)
# kubeadm reset para zerar as configurações, caso exista
kubeadm config images pull

kubeadm init --upload-certs --control-plane-endpoint=$(hostname) --apiserver-advertise-address $(hostname -I | cut -d' ' -f1) --cri-socket unix:///var/run/containerd/containerd.sock --pod-network-cidr 192.168.0.0/16
# Possível erro de IP Forward: Editar o arquivo /etc/sysctl.conf, habilitar a linha "net.ipv4.ip_forward = 1" e execute sudo sysctl -p
# Se erro de HTTP Call equal to ...
rm -f /etc/cni/net.d/10-flannel.conflist
iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
rm -f $HOME/.kube/config

# fora do modo privilegiado (logout)
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# (NÃO PRECISA EXECUTAR) - You can now join any number of the control-plane node running the following command on each as root

kubeadm join cplss01:6443 --token a7rclh.2mm4uewnzsrc6azj \
        --discovery-token-ca-cert-hash sha256:343be8003484dbccb57040d8e570eacf4fccfa271aacb5a01bd5d4e6875f21c3 \
        --control-plane --certificate-key add4234b7b8852deef1b836a1c116c5ef95a85fa22f8c8a4a0eadcf877a39fdb

##### Resultado deverá ser executado no w1 e w2

kubeadm join cplss01:6443 --token a7rclh.2mm4uewnzsrc6azj --discovery-token-ca-cert-hash sha256:343be8003484dbccb57040d8e570eacf4fccfa271aacb5a01bd5d4e6875f21c3

#### Stop!

# para gerar o token novamente:
kubeadm token create --print-join-command


# No CP, após configurar os nós
kubectl get nodes
kubectl get pods -A

# Instalação do CNI
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# Instalação do Tigera Calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml
# ou kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Altere o CIDR  (ver linha 70)
curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/custom-resources.yaml -O

nano custom-resources.yaml

kubectl create -f custom-resources.yaml
# on error, kubectl delete -f custom-resources.yaml e refaça
# kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml
# TS
kubectl describe pod calico-node -n calico-system
kubectl describe pode (nome) -n (namespace)
#Instalar os plugins do KubeCTL 
sudo apt-get install bash-completion
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc
source /etc/profile.d/bash_completion.sh


