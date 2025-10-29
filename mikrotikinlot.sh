#!/bin/bash
# Lista de IPs dos Mikrotiks
ROUTERS=("172.16.0.xx")
mapfile -t HOSTS < hosts.txt
# Usuário e senha
USER="seuusuarioaqui"
PASS="suasenhaqui"

# Comando a ser executado em todos os Mikrotiks
#CMD="/ip dns set servers=8.8.8.8,1.1.1.1"
CMD="/ip service enable api; /ip firewall address-list add address=10.10.0.0/16 list=admin; ip firewall filter add action=drop chain=input dst-port=8728,8729 protocol=tcp src-address-list=!admin "
#CMD="/user add name=ediomario.oliveira group=full password="suasenhaaqui" disabled=no"

for IP in "${HOSTS[@]}"; do
  echo "Configurando Mikrotik em $IP..."
  sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "$CMD"
done
