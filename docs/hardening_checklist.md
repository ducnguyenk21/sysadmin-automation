# Linux Hardening Checklist
> VM: linux-lab-01 | Date: 2026-05-16 | Lynis: 57 → 70

## Done
- [x] SSH hardening (MaxAuthTries 3, X11Forwarding no, LogLevel VERBOSE...)
- [x] apt upgrade (10 security CVE patched)
- [x] ufw firewall (allow 22, 514 only)
- [x] sudoers.d chmod 750
- [x] fail2ban SSH jail (maxretry 3, bantime 3600)
- [x] SHA_CRYPT_MIN_ROUNDS 640000
- [x] umask 027
- [x] cron permissions 600/700
- [x] libpam-pwquality
