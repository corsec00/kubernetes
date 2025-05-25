# Os comandos agora são as configurações e operação no ControlPlane.k8s.lab
# #!/bin/bash

# Verificando os Nodes e Pods instalados
kubectl get nodes
kubectl get pods -A

# Descrevendo um Pod    
# kubectl describe pod (nome) -n (namespace)
kubectl describe pod calico-node -n calico-system

# No modo não privilegiado, o usuário não pode executar o comando kubectl. Para isso, é necessário adicionar o usuário ao grupo docker e reiniciar a sessão.
kubectl api-versions
kubectl proxy --port=80 # permanente
kubectl api-resources
# Alterar o Kubernet API para habilitar o swagger
kubectl create ns testepodnginx # criando um namespace
kubectl get ns
# Deleta o namespace 'teste'
# kubectl delete ns testepodnginx

# Inicia um Pod Nging baseado no YAML podnginx.yaml
kubectl create -f podnginx.yaml
kubectl run nginx --image=nginx --port=80 --restart=Never -n testepodnginx # modo interativo
# Acessar o Pod
kubectl exec -it nginx -- /bin/bash
# verificando o endereço IP do Pod
kubectl get pod -o wide
kubectl get pod -o wide -n testepodnginx
curl http://192.168.203.2:80
# Na máquina externa do hipervisor, para acessar o Pod, é necessário criar uma regra de NAT no iptables do hipervisor.
# Exemplo de regra de NAT no iptables do hipervisor
# iptables -t nat -A PREROUTING -p tcp -d   


# Para apagar o Pod
kubectl delete podnginx.yaml --force -grace-period 0
