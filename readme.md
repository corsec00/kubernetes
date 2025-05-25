Baixar o script para a instalação diretamente do Github:
bash <(wget -qO- https://raw.githubusercontent.com/usuario/repositorio/main/script.sh)

Instalar diretamente do Github
bash <(curl -s https://raw.githubusercontent.com/usuario/repositorio/main/script.sh)

Instalação do Kubernetes (kubectl)
Linux: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
Windows: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

Na máquina local, use o minikube
Linux: 
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64/ sudo install minikube-linux-amd64 /usr/local/bin/minikube
Windows:
new-item -path 'c:\' -name 'minikube' -itemtype Directory -force
invoke-webrequest -outfile 'c:\minikube\minikube.exe' -uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -usebasicparsing
$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
if ($oldPath.Split(';') -inotcontains 'C:\minikube')
{ 
    ` [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath),
[EnvironmentVariableTarget]::Machine) `
}




Sintaxe:
kubectl [comando] [tipo] [nome] [flags]
    comando -> especifica a operação que vc deseja executar em um ou mais recursos
    tipo -> especifica qual tipo de recurso
    nome -> especifica o nome do recurso
    flags -> espeficifa parâmetros adicionais

Dica: Cria um alias para o kubectl    

Ambiente: 
3 máquinas Linux Ubuntu 24.04.2 (VMWare)
Arquivos de configuração: 
support.sh -> instala os requisitos para o Linux
configk8.sh -> configuração dos hosts DNS para a rede k8s.lab (atenção: Apenas 1 comando 'hostnamectl hostname' deve ser executado por host)
installk8.sh -> inicia a instalação do Docker & Kubernetes


Comando Úteis
❏ kubeadm init para inicializar um nó do plano de controle do Kubernetes
❏ kubeadm join para inicializar um nó de trabalho do Kubernetes e uni-lo ao cluster
❏ kubeadm upgrade para atualizar um cluster Kubernetes para uma versão mais recente
❏ kubeadm config se você inicializou seu cluster usando kubeadm v1.7.x ou inferior, para configurar seu cluster para atualização kubeadm
❏ kubeadm token para gerenciar tokens para junção kubeadm
❏ kubeadm reset para reverter quaisquer alterações feitas neste host por kubeadm init ou kubeadm join
❏ kubeadm certs para gerenciar certificados Kubernetes
❏ kubeadm kubeconfig para gerenciar arquivos kubeconfig
❏ kubeadm version para imprimir a versão kubeadm
❏ kubeadm alpha para visualizar um conjunto de recursos disponibilizados para coletar feedback da comunidade