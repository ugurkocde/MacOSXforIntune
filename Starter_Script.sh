#!/usr/bin/env bash

sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"
echo "Performance Mode enabled"

# massively increase virtualized macOS by disabling spotlight.
sudo mdutil -i off -a > /dev/null
echo "Disabled spotlight"

## Install Company Portal

# Download the .pkg file using curl
curl -O https://github.com/ugurkocde/MacOSXforIntune/raw/main/CompanyPortal-Installer.pkg
echo "Downloading and installing Company Portal"

# Install the .pkg file silently using the installer command
installer -pkg *.pkg -target /

# Remove the downloaded .pkg file
# rm /*.pkg
echo "Company Portal installed"
# Build checks if the company portal is installed

# User runs this: curl -s https://raw.githubusercontent.com/myusername/myrepo/main/install_pkg.sh | bash
