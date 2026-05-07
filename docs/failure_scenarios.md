## Scenario 1 — Service Down

**Setup:** `sudo systemctl stop nginx`

**Debug flow:**
1. `systemctl status nginx` → thấy inactive
2. `journalctl -u nginx --since "10 minutes ago"` → tìm nguyên nhân
3. `nginx -t` → verify config không lỗi
4. `systemctl start nginx` → start lại
5. `ss -tlnp | grep :80` + `curl -I localhost` → verify

**Key lesson:** Luôn đọc journalctl trước khi fix — biết nguyên nhân mới fix đúng.

## Scenario 2 — Full Disk

**Setup:** `dd if=/dev/zero of=/tmp/bigfile bs=1M count=5000`

**Debug flow:**
1. `df -h` → thấy / at 100%
2. `apt-get clean` → giải phóng cache để có space làm việc
3. `find / -type f -size +100M 2>/dev/null` → tìm file lớn
4. `rm /tmp/bigfile` → xóa file rác
5. `df -h` → verify space trở lại bình thường

**Key lesson:**
- Khi disk 100%, `du | sort` fail vì không có temp space → dùng `sort -T /dev/shm`
- `/proc/kcore` trông to nhưng không thật — bỏ qua
- `apt-get clean` là bước đầu tiên khi cần space khẩn cấp

## Scenario 3 — Wrong Permission

**Setup:** `sudo chmod 000 /etc/nginx/nginx.conf`

**Debug flow:**
1. `systemctl restart nginx` → fail hoặc success tùy user chạy
2. `systemctl status nginx` → xem exit code
3. `journalctl -u nginx` → xem error message
4. `ls -la /etc/nginx/nginx.conf` → thấy ----------
5. `sudo -u www-data cat /etc/nginx/nginx.conf` → Permission denied
6. `chmod 644 /etc/nginx/nginx.conf` → fix
7. Verify: `sudo -u www-data cat` đọc được

**Key lesson:**
- Root không bị chặn bởi permission 000 — nginx restart vẫn OK
- Nhưng worker process chạy bằng www-data sẽ fail
- File config chuẩn: 644 (owner đọc/ghi, others chỉ đọc)
