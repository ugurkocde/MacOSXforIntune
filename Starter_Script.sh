#!/usr/bin/env bash

sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"
echo "Performance Mode enabled"

# massively increase virtualized macOS by disabling spotlight.
echo "Disabling spotlight"
sudo mdutil -i off -a > /dev/null


## Install Company Portal

cd ~/Downloads

# Download the .pkg file using curl
echo "Downloading and installing Company Portal"
curl -O "https://github.com/ugurkocde/MacOSXforIntune/blob/main/CompanyPortal-Installer.pkg?raw=true"



# Install the .pkg file silently using the installer command
installer -pkg *.pkg -target /

# Remove the downloaded .pkg file
# rm /*.pkg
echo "Company Portal installed"
# Build checks if the company portal is installed

# User runs this: curl -s https://raw.githubusercontent.com/myusername/myrepo/main/install_pkg.sh | bash

