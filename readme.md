### Comando útil
Baixar o script para a instalação diretamente do Github:<br />
`bash <(wget -qO- https://raw.githubusercontent.com/usuario/repositorio/main/script.sh)`

Instalar diretamente do Github<br />
`bash <(curl -s https://raw.githubusercontent.com/usuario/repositorio/main/script.sh)`

## Instalação do Kubernetes (kubectl)<br />
Linux: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/<br />
Windows: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

Na máquina local, use o minikube<br />
Linux: <br />
`curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64/ sudo install minikube-linux-amd64 /usr/local/bin/minikube`<p />
Windows:<br />

`new-item -path 'c:\' -name 'minikube' -itemtype Directory -force`

`invoke-webrequest -outfile 'c:\minikube\minikube.exe' -uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -usebasicparsing`

`$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)`
`if ($oldPath.Split(';') -inotcontains 'C:\minikube')
{ 
    ' [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath),[EnvironmentVariableTarget]::Machine) '
}
`

## Sintaxe:<br />
<b>kubectl</b> <i>[comando] [tipo] [nome] [flags]</i><br />
    comando -> especifica a operação que vc deseja executar em um ou mais recursos<br />
    tipo -> especifica qual tipo de recurso<br />
    nome -> especifica o nome do recurso<br />
    flags -> espeficifa parâmetros adicionais<br />

Dica: Cria um alias para o kubectl    <br />

## Ambiente: <br />
3 máquinas Linux Ubuntu 24.04.2 (VMWare)<br />
Arquivos de configuração: <br />
support.sh -> instala os requisitos para o Linux<br />
configk8.sh -> configuração dos hosts DNS para a rede k8s.lab (atenção: Apenas 1 comando 'hostnamectl hostname' deve ser executado por host)<br />
installk8.sh -> inicia a instalação do Docker & Kubernetes<br />


## Comandos Úteis<br />
❏ `kubeadm init` para inicializar um nó do plano de controle do Kubernetes<br />
❏ `kubeadm join` para inicializar um nó de trabalho do Kubernetes e uni-lo ao cluster<br />
❏ `kubeadm upgrade` para atualizar um cluster Kubernetes para uma versão mais recente<br />
❏ `kubeadm config` se você inicializou seu cluster usando kubeadm v1.7.x ou inferior, para configurar seu cluster para atualização kubeadm<br />
❏ `kubeadm token` para gerenciar tokens para junção kubeadm<br />
❏ `kubeadm reset` para reverter quaisquer alterações feitas neste host por kubeadm init ou kubeadm join<br />
❏ `kubeadm certs` para gerenciar certificados Kubernetes<br />
❏ `kubeadm kubeconfig` para gerenciar arquivos kubeconfig<br />
❏ `kubeadm version` para imprimir a versão kubeadm<br />
❏ `kubeadm alpha` para visualizar um conjunto de recursos disponibilizados para coletar feedback da comunidade<br />
