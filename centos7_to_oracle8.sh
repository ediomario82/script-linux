#!/bin/bash

#atualização do sistema atual

yum upgrade --refresh -y

#instalar o pacote “elevate-release”

yum -y install http://repo.almalinux.org/elevate/elevate-release-latest-el$(rpm --eval %rhel).noarch.rpm

#instalar o pacote “leapp”

yum -y install leapp-upgrade leapp-data-oraclelinux

#verificar a compatibilidade do servidor sem fazer nenhuma alteração real e cria um arquivo #“ /var/log/leapp/leapp-report.txt ” que contém possíveis problemas e soluções recomendadas.

sudo leapp preupgrade

#comandos abaixo resolvem o problemas de atualizaçao

sudo rmmod pata_acpi
echo PermitRootLogin yes | sudo tee -a /etc/ssh/sshd_config
sudo leapp answer --section remove_pam_pkcs11_module_check.confirm=True

#executar novamente a verificação de pré-atualização
sudo leapp preupgrade

#Execute o seguinte comando para migrar seu sistema CentOS 7 para Oracle Linux 8.
sudo leapp upgrade

#Esteja ciente de que a atualização pode ocasionalmente levar a erros se você estiver usando pacotes de #repositórios externos, como o EPEL. Um exemplo comum é encontrar um problema com o pacote “ openssl11-libs ” #do repositório EPEL.

#Para corrigir esse problema, desinstale o pacote executando "yum remove <package_name>". Depois, execute #novamente o "sudo leap upgradecomando", que deve prosseguir sem problemas.


#Assim que a migração for concluída, você será solicitado a reinicializar o sistema. Ok, o momento da verdade!

sudo reboot


