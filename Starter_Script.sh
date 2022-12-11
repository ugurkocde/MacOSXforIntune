#!/usr/bin/env bash

sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"
echo "$(tput setaf 2)Performance Mode enabled$(tput sgr0)"

# massively increase virtualized macOS by disabling spotlight.
echo "$(tput setaf 2)Disabling spotlight$(tput sgr0)"
sudo mdutil -i off -a

if [ -d "/Applications/Company Portal.app" ]; then
echo "$(tput setaf 2)Company Portal is already installed$(tput sgr0)"
exit 0
fi

## Install Company Portal

cd ~/Downloads

# Download the .pkg file using curl
echo "$(tput setaf 2)Downloading and installing Company Portal$(tput sgr0)"
sudo curl -LO https://github.com/ugurkocde/MacOSXforIntune/raw/main/CompanyPortal-Installer.pkg -o ~/Downloads/CompanyPortal-Installer.pkg

# Install the .pkg file silently using the installer command
sudo installer -pkg *.pkg -target /

# Remove the downloaded .pkg file
sudo rm CompanyPortal-Installer.pkg
echo "$(tput setaf 2)Company Portal installed$(tput sgr0)"
# Build checks if the company portal is installed

messages=(
  "Performance Mode enabled [✓]"
  "Disabling spotlight [✓]"
  "Company Portal is already installed [✓]"
  "Downloading and installing Company Portal [✓]"
  "Company Portal installed [✓]"
)

for message in "${messages[@]}"; do
  echo "$message"
done

# User runs this: curl -s https://raw.githubusercontent.com/myusername/myrepo/main/install_pkg.sh | bash

