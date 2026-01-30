# Snap-Autoclean-Systemd 🧹

**Tired of cleaning unused snap garbage that occupies your HDD?** Simple **plug-and-play** systemd tool!

Automated **daily cleanup** of old snap revisions + cache. **Non-interactive**, **space reporting**, runs as root via `/usr/local/bin/`.

[![stars](https://img.shields.io/github/stars/dominatos/snap-autoclean-systemd)](https://github.com/dominatos/snap-autoclean-systemd)

## 🚀 Quick Install (1 command)
```bash
curl -sSL https://raw.githubusercontent.com/dominatos/snap-autoclean-systemd/main/install.sh | bash
```

## 📁 Files Structure
```
snap-autoclean-systemd/
├── install.sh          # One-command installer
├── clean-snap.sh       # → /usr/local/bin/snap-autoclean
├── snap-clean.service  # Systemd service
├── snap-clean.timer    # Daily timer (00:00 + 30min post-boot)
└── README.md
```

## 📊 Example Output
```
Starting snap cleanup...
Removing core22 revision 1234...
Cache cleared.
Snap cleanup completed.
Freed space: 1.2 GB
```

## 🔍 Status Commands
```bash
systemctl list-timers snap-clean.timer        # Timer schedule
journalctl -u snap-clean.service -e          # Last run + space freed
systemctl status snap-clean.service          # Service status
```

## ⚙️ Customization
```ini
# Timer: change time
OnCalendar=*-*-* 02:00:00  # 2AM instead of midnight

# Script: retain more revisions
snap set system refresh.retain=5  # Keep 5 instead of 2
```

## 🛠️ Updated Service File
**ExecStart** теперь `/usr/local/bin/snap-autoclean` (FHS стандарт):
```ini
[Service]
Type=oneshot
User=root
ExecStart=/usr/local/bin/snap-autoclean
```

## 📦 Manual Install
```bash
# 1. Download & install binary
sudo curl -sSL https://raw.githubusercontent.com/dominatos/snap-autoclean-systemd/main/clean-snap.sh -o /usr/local/bin/snap-autoclean
sudo chmod +x /usr/local/bin/snap-autoclean

# 2. Install systemd files
sudo curl -sSL https://raw.githubusercontent.com/dominatos/snap-autoclean-systemd/main/snap-clean.* -o /etc/systemd/system/

# 3. Activate
sudo systemctl daemon-reload
sudo systemctl enable --now snap-clean.timer
```

## Troubleshooting
- **Error 203/EXEC**: `sudo chmod +x /usr/local/bin/snap-autoclean`
- **No snaps cleaned**: `snap list --all | grep disabled`
- **Logs**: `journalctl -u snap-clean.service -f`

## ⭐ Why Use This?
- ✅ **FHS compliant** (`/usr/local/bin`)
- ✅ **Non-interactive** (no `read` prompts)
- ✅ **Space reporting** (GB freed)
- ✅ **Error-proof** (`set -euo pipefail`)
- ✅ **Daily auto-clean** (systemd timer)

## License
MIT - Free to use/modify/distribute 🚀