#!/bin/bash

# Configurações do banco de dados
DB_USER="root"
DB_PASSWORD="passwd"
DB_NAME="meuDB"
QTD_BACKUP=3

# Diretório de backup
BACKUP_DIR="/backupdb/"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Caminho para o último backup
LAST_BACKUP=$(ls -t "$BACKUP_DIR" | head -n 1)

# Se não houver backups anteriores, faça um backup completo
if [ -z "$LAST_BACKUP" ]; then
    BACKUP_FILE="$BACKUP_DIR/$TIMESTAMP-full.sql.gz"
    mysqldump -u"$DB_USER" -p"$DB_PASSWORD" --single-transaction "$DB_NAME" | pv | gzip > "$BACKUP_FILE"
    echo "Backup completo realizado em $TIMESTAMP: $BACKUP_FILE"
    exit 0
fi

# Backup incremental
BACKUP_FILE="$BACKUP_DIR/$TIMESTAMP-incremental.sql.gz"
mysqldump -u"$DB_USER" -p"$DB_PASSWORD" --single-transaction --databases "$DB_NAME" --no-create-info --skip-triggers --skip-comments --compact | pv | gzip > "$BACKUP_FILE"

# Comparar com o último backup e salvar as alterações
CHANGES_FILE="$BACKUP_DIR/$TIMESTAMP-changes.sql"
diff --changed-group-format='%>' --unchanged-group-format='' "$BACKUP_DIR/$LAST_BACKUP" "$BACKUP_FILE" > "$CHANGES_FILE"

# Verificar se há mudanças
if [ -s "$CHANGES_FILE" ]; then
    echo "Backup incremental realizado em $TIMESTAMP: $BACKUP_FILE"
    echo "Alterações desde o último backup:"
    cat "$CHANGES_FILE"
else
    echo "Nenhuma alteração desde o último backup."
    rm "$BACKUP_FILE"  # Não há alterações, remova o arquivo incremental
fi

# Excluir backups antigos, mantendo apenas os últimos 2
#ls -t | grep "$BACKUP_FILE" | tail -n +$(($QTD_BACKUP + 1)) | xargs -d '\n' rm -f
