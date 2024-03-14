#!/bin/bash

# Definir as variáveis de configuração
usuario_db="root"
senha_db="passdb"
ip_origem="192.168.0.200"
ip_destino="192.168.1.100"
caminho_destino="/mnt/DATA/Backups/Backup_mysql"
quantidade_backups=3

# Nome do arquivo de backup
arquivo_backup="backup_$(date +%Y-%m-%d_%H-%M-%S).sql.gz"

# Criar o backup e comprimir, exibindo a porcentagem
mysqldump --user="$usuario_db" --password="$senha_db" --all-databases | pv | gzip > "$arquivo_backup"

# Transferir o arquivo de backup para o destino usando rsync, exibindo a porcentagem
sshpass -p 'rootpwd' rsync -arzP --progress "$arquivo_backup" "$ip_destino:$caminho_destino"

# Excluir backups antigos, mantendo apenas os últimos 2
ls -t | grep "^backup_" | tail -n +$(($quantidade_backups + 1)) | xargs -d '\n' rm -f

# Excluir o arquivo de backup no servidor de origem
rm -f "$arquivo_backup"
