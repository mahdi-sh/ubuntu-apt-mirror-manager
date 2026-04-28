#!/usr/bin/env bash
set -e

# Detect Ubuntu codename
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    CODENAME="$VERSION_CODENAME"
else
    echo "Cannot detect OS version."
    exit 1
fi

# Map supported Ubuntu versions explicitly
case "$CODENAME" in
    jammy)   ;;  # Ubuntu 22.04
    noble)   ;;  # Ubuntu 24.04
    oracular) ;; # Ubuntu 26.04
    *)
        echo "Unsupported Ubuntu version: $CODENAME"
        exit 1
        ;;
esac

echo "Using codename: $CODENAME"
echo "Updating APT sources to ArvanCloud mirror..."

# Backup old sources
BACKUP="/etc/apt/sources.list.bak.$(date +%F_%H%M%S)"
sudo cp /etc/apt/sources.list "$BACKUP"
echo "Backup created: $BACKUP"

# Write new ArvanCloud mirror sources
sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb http://mirror.arvancloud.ir/ubuntu $CODENAME main restricted universe multiverse
deb http://mirror.arvancloud.ir/ubuntu $CODENAME-updates main restricted universe multiverse
deb http://mirror.arvancloud.ir/ubuntu $CODENAME-backports main restricted universe multiverse
deb http://mirror.arvancloud.ir/ubuntu $CODENAME-security main restricted universe multiverse
EOF

echo "New sources.list written."

echo "Running apt update..."
sudo apt update -y

echo "Done. Mirror successfully applied!"
