# Configuração dos Hosts após a instalação do Kubernetes
# controlplane.k8s.lab
hostnamectl hostname controlplane.k8s.lab
sudo -i 
echo '10.1.1.130 controlplane.k8s.lab' >> /etc/hosts
echo '10.1.1.133 worker01.k8s.lab' >> /etc/hosts
echo '10.1.1.134 worker02.k8s.lab' >> /etc/hosts
# worker01.k8s.lab
hostnamectl hostname worker01.k8s.lab
sudo -i 
echo '10.1.1.130 controlplane.k8s.lab' >> /etc/hosts
echo '10.1.1.133 worker01.k8s.lab' >> /etc/hosts
echo '10.1.1.134  worker02.k8s.lab' >> /etc/hosts
# worker02.k8s.lab
hostnamectl hostname worker02.k8s.lab
sudo -i 
echo '10.1.1.130 controlplane.k8s.lab' >> /etc/hosts
echo '10.1.1.133 worker01.k8s.lab' >> /etc/hosts
echo '10.1.1.134  worker02.k8s.lab' >> /etc/hosts
# Teste de Ping
ping controlplane.k8s.lab
ping worker01.k8s.lab
ping worker02.k8s.lab
