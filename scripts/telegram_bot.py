import requests
import sys
import os

TOKEN = os.environ.get("TELEGRAM_TOKEN")
CHAT_ID = os.environ.get("TELEGRAM_CHAT_ID")

def send_alert(message):

    url = f"https://api.telegram.org/bot{TOKEN}/sendMessage"
    payload = {
        "chat_id": CHAT_ID,
        "text": message,
        "parse_mode": "HTML"
    }

    try:

        response = requests.post(url, json=payload)
        if response.status_code == 200:
            print("Successfully sent Telegram alert")
        else:
            print(f"Failed to send alert: {response.text}")
    except Exception as e:
        print(f"Error: {e}")
       
if __name__ == "__main__":
    if len(sys.argv) > 1:
        msg = sys.argv[1]
        send_alert(msg)

