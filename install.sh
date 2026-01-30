#!/bin/bash
# Snap-Autoclean Systemd Installer

set -euo pipefail

REPO="${REPO:-dominatos/snap-autoclean-systemd}"
REF="${REF:-master}"

echo "🧹 Installing Snap-Autoclean Systemd..."

# Create temp dir
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Download files
curl -fsSL "https://raw.githubusercontent.com/$REPO/$REF/clean-snap.sh" > "$TMP/clean-snap.sh"
curl -fsSL "https://raw.githubusercontent.com/$REPO/$REF/snap-clean.service" > "$TMP/snap-clean.service"
curl -fsSL "https://raw.githubusercontent.com/$REPO/$REF/snap-clean.timer" > "$TMP/snap-clean.timer"

chmod +x "$TMP/clean-snap.sh"

# Install to system
sudo cp "$TMP"/snap-clean.* /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now snap-clean.timer

sudo cp "$TMP/clean-snap.sh" /usr/local/bin/snap-autoclean
sudo chmod +x /usr/local/bin/snap-autoclean

echo "✅ Installed! Daily cleanup enabled."
echo "📊 Check: systemctl list-timers snap-clean.timer"
echo "📜 Logs: journalctl -u snap-clean.service -f"
