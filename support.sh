# Instala as ferramentas de suporte e atualiza o sistema no Ubuntu 24.04
#!/bin/bash
# Verifica se o usuário é root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script deve ser executado como root. Use 'sudo' ou faça login como root."
    exit 1
fi
# Atualiza o sistema
apt-get update -y && apt-get upgrade -y
# Instala as ferramentas de suporte
apt-get install -y build-essential curl wget git htop net-tools ufw fail2ban software-properties-common open-vm-tools open-vm-tools-desktop
systemctl restart open-vm-tools


# Configura o Fail2Ban
systemctl enable fail2ban
systemctl start fail2ban

# Instala e configura o OpenSSH Server
apt-get install -y openssh-server
systemctl enable ssh
systemctl start ssh

# Configura o firewall
ufw allow OpenSSH
ufw allow 22/tcp
ufw enable

# Limpa o cache do apt
apt-get clean

#Altera o hostname
read -p "Digite o novo hostname: " new_hostname
hostnamectl set-hostname $new_hostname
echo "Hostname alterado para $new_hostname"
# Reinicia o sistema
reboot


sudo chmod +x "support.sh" && sudo bash "support.sh"



