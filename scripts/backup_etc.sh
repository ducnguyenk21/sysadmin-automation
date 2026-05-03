#!/bin/bash

BACKUP_DIR="/var/backups/etc"
DATE=$(date +%Y-%m-%d)
LOGFILE="/var/log/backup_etc.log"
RETENTION_DAYS=7

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/etc-$DATE.tar.gz" /etc 2>/dev/null
		
if [ $? -eq 0 ]; then
	echo "$(date '+%Y-%m-%d %H:%M') | OK | etc-$DATE.tar.gz" >> "$LOGFILE"
else
	echo "$(date '+%Y-%m-%d %H:%M') | FAIL | backup failed" >> "$LOGFILE"
	exit 1
fi

find "$BACKUP_DIR" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "$(date '+%Y-%m-%d %H:%M') | CLEANUP | removed backups older than ${RETENTION_DAYS}d" >> "$LOGFILE"
