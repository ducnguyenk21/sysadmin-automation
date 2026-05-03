#!/bin/bash

CLEAN_DIR="/var/log/"
LOGFILE="/var/log/clean_logs.log"
DATE=$(date +%Y-%m-%d)
RETENTION_DAYS=7

COUNT=$(find "$CLEAN_DIR" -type f \( -name "*.log" -o -name "*.gz" \) -mtime +$RETENTION_DAYS | wc -l)
find "$CLEAN_DIR" -type f \( -name "*.log" -o -name "*.gz" \) -mtime +$RETENTION_DAYS -delete
echo "$DATE | CLEANUP | $COUNT files removed" >> "$LOGFILE"
