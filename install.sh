#!/bin/bash
# Snap-Autoclean Systemd Installer

set -euo pipefail

REPO="YOUR_USERNAME/snap-autoclean-systemd"
DIR="$HOME/.local/share/snap-autoclean"

echo "🧹 Installing Snap-Autoclean Systemd..."

# Create temp dir
TMP=$(mktemp -d)
cd "$TMP"

# Download files
curl -sSL "https://raw.githubusercontent.com/$REPO/main/clean-snap.sh" > clean-snap.sh
curl -sSL "https://raw.githubusercontent.com/$REPO/main/snap-clean.service" > snap-clean.service
curl -sSL "https://raw.githubusercontent.com/$REPO/main/snap-clean.timer" > snap-clean.timer

chmod +x clean-snap.sh

# Install to system
sudo cp snap-clean.* /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now snap-clean.timer

sudo cp clean-snap.sh /usr/local/bin/snap-autoclean


# Cleanup
rm -rf "$TMP"

echo "✅ Installed! Daily cleanup enabled."
echo "📊 Check: systemctl list-timers snap-clean.timer"
echo "📜 Logs: journalctl -u snap-clean.service -f"
