#!/bin/bash
VM2_IP="192.168.56.102"
VM2_USER="nguyenndk21"
SSH_KEY="/home/nguyenndk21/.ssh/deploy_key"
SSH_CMD="ssh -i $SSH_KEY $VM2_USER@$VM2_IP"

$SSH_CMD "dpkg -l nginx 2>/dev/null | grep -q '^ii'"

if [ $? -eq 0 ]; then
	echo "Nginx da cai dat"
else
	echo "Nginx chua cai dat, tien hanh cai dat"
	$SSH_CMD "sudo apt-get update && sudo apt-get install -y nginx"

	if [ $? -ne 0 ]; then
		echo "[FAIL] Cai dat nginx that bai"
		exit 1
	fi
fi


echo "[INFO] dang cau hinh khoi dong va kich hoat nginx"
$SSH_CMD "sudo systemctl enable --now nginx"

echo "[INFO] Daang kiem tra trang thai dich vu"
$SSH_CMD "systemctl is-active nginx > /dev/null 2>&1"

if [ $? -eq 0 ]; then
	echo "[OK] nginx deployed thanh cong tren VM2"
else
	echo "[FAIL] dich vu Nginx khong hoat dong "
fi
