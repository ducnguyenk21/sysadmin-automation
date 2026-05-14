#!/bin/bash

LOG_FILE="/home/nguyenndk21/system_monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
HOSTNAME=$(hostname)

DISK_LIMIT=80
CPU_LIMIT=80
RAM_LIMIT=85

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{printf "%d", 100 - $8}')

ram_usage=$(free -m | awk 'NR==2 {printf "%d", $3*100/$2}')

disk_usage_root=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "$TIMESTAMP | CPU:${cpu_usage}% RAM:${ram_usage}% DISK:/=${disk_usage_root}%" >>"$LOG_FILE"
	
if [ "$cpu_usage" -gt "$CPU_LIMIT" ]; then
    echo "$TIMESTAMP | WARN | CPU at ${cpu_usage}%" >> "$LOG_FILE"
    python3 ~/sysadmin-automation/scripts/telegram_bot.py "⚠️ WARN | CPU at ${cpu_usage}%"
fi

if [ "$ram_usage" -gt "$RAM_LIMIT" ]; then
    echo "$TIMESTAMP | WARN | RAM at ${ram_usage}%" >> "$LOG_FILE"
    python3 ~/sysadmin-automation/scripts/telegram_bot.py "⚠️ WARN | RAM at ${ram_usage}%"
fi

while read usage mount; do
	num=${usage%\%}
	if [ "$num" -gt "$DISK_LIMIT" ]; then
    	echo "$TIMESTAMP | WARN | DISK $mount at $usage" >> "$LOG_FILE"
    	python3 ~/sysadmin-automation/scripts/telegram_bot.py "⚠️ WARN | DISK $mount at $usage"
	fi
done < <(df -h | grep '^/dev/' | awk '{print $5, $6}')

