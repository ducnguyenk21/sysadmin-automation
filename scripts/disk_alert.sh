#!/bin/bash

LOGFILE="/var/log/disk_alert.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
ALERT_TRIGGERED=false
THRESHOLD=80
COUNT=0
while read USAGE MOUNT; do
echo  "Partition: $MOUNT dung ${USAGE%\%}";
	NUM=${USAGE%\%}
	if [ $NUM -gt $THRESHOLD ]; then
		echo "$TIMESTAMP | WARN | $MOUNT at $USAGE" >> "$LOGFILE"
		((COUNT++))
	fi
done < <(df -h | awk 'NR>1 {print $5, $6}')

if [ $COUNT -eq 0 ]; then
	echo "$TIMESTAMP | OK | all disks normal" >> "$LOGFILE"
else
	echo "$TIMESTAMP | INFO | Total $COUNT partitions are over $THRESHOLD%" >> "$LOGFILE"
fi


