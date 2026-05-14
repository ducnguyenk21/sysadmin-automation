import ssl
import socket
from datetime import datetime

def check_cert(domain):
    context = ssl.create_default_context()
    try:
        with socket.create_connection((domain, 443), timeout=5) as sock:
            with context.wrap_socket(sock,server_hostname=domain) as ssock:
                cert = ssock.getpeercert()
                expiry_str = cert['notAfter']
                expiry_date = datetime.strptime(expiry_str, '%b %d %H:%M:%S %Y %Z')
                today = datetime.now()
                delta = expiry_date - today
                return delta.days, None
    except Exception as e:
        return None, str(e)

def run_ssl_checker(file_path):
    print(f"--- Bat dau kiem tra SSL Cert ---")
    try:
        with open(file_path, "r") as f:
            for line in f:
                domain = line.strip()
                if not domain: continue
                days_left, error = check_cert(domain)

                if error:
                    print(f"[FAIL] {domain}: connection error ({error})")
                elif days_left < 30:
                    print(f"[WRAN] {domain}: {days_left} days left")
                else:
                    print(f"[OK] {domain}: {days_left} days left")
    except FileNotFoundError:
        print(f"Loi: khong tim thay file {file_path}")
if __name__ == "__main__":
    path = "/home/nguyenndk21/sysadmin-automation/scripts/domains.txt"
    run_ssl_checker(path)
