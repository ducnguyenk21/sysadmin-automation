import paramiko

def get_uptime(ip, user, pwd):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        print(f"dang ket noi toi {ip}...")
        client.connect(hostname=ip, username=user, password=pwd, timeout=5)

        stdin, stdout, stderr = client.exec_command("uptime -p")

        result = stdout.read().decode().strip()
        print(f"Ket qua tu {ip}: {result}")

    except Exception as e:
        print(f"Loi khi ket noi {ip}: {e}")

    finally:
        client.close()

if __name__ == "__main__":
    file_danh_sach = "/home/nguyenndk21/sysadmin-automation/scripts/servers.txt"

    try:
        with open(file_danh_sach, "r") as f:
            for line in f:
                clean_line = line.strip()
                if not clean_line: continue
                data = clean_line.split(",")
                get_uptime(data[0], data[1], data[2])

    except FileNotFoundError:
        print(f"Loi: khong tim thay file {file_danh_sach}")
