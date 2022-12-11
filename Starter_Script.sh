#!/usr/bin/env bash

sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"

# massively increase virtualized macOS by disabling spotlight.
sudo mdutil -i off -a

## Install Company Portal

# Download the .pkg file using curl
curl -O https://go.microsoft.com/fwlink/?linkid=853070

# Install the .pkg file silently using the installer command
installer -pkg ./*.pkg -target /

# Remove the downloaded .pkg file
rm ./*.pkg


# User runs this: curl -s https://raw.githubusercontent.com/myusername/myrepo/main/install_pkg.sh | bash