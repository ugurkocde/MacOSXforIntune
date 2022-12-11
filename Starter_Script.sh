#!/usr/bin/env bash

sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"
echo "Performance Mode enabled"

# massively increase virtualized macOS by disabling spotlight.
echo "Disabling spotlight"
sudo mdutil -i off -a


## Install Company Portal

# Download the .pkg file using curl
echo "Downloading and installing Company Portal"
sudo curl -LO https://github.com/ugurkocde/MacOSXforIntune/raw/main/CompanyPortal-Installer.pkg

# Install the .pkg file silently using the installer command
sudo installer -pkg *.pkg -target /

# Remove the downloaded .pkg file
sudo rm CompanyPortal-Installer.pkg
echo "Company Portal installed"
# Build checks if the company portal is installed

# User runs this: curl -s https://raw.githubusercontent.com/myusername/myrepo/main/install_pkg.sh | bash

