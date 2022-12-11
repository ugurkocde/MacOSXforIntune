#!/usr/bin/env bash

sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"
echo "Enabling Performance Mode ..."

# massively increase virtualized macOS by disabling spotlight.
echo "Disabling spotlight ..."
sudo mdutil -i off -a

# Check if FileVault is already enabled
echo "Checking if FileVault is enabled ..."
if fdesetup status | grep "FileVault is On" > /dev/null; then
  # FileVault is already enabled, add message to messages array
  echo "FileVault is already enabled."
else
  # Enable FileVault
  sudo fdesetup enable
  if [ $? -eq 0 ]; then
    # FileVault enabled, add message to messages array
    echo "Enabling FileVault."
    messages+=( "$(tput setaf 2)FileVault is enabled [✓]$(tput sgr0)" )
  else
    # Failed to enable FileVault, add message to messages array
    echo "Failed to enable FileVault."
    messages+=( "$(tput setaf 1)Failed to enable FileVault$(tput sgr0)" )
  fi
fi

echo "Checking if Company Portal is already installed ..."

if [ -d "/Applications/Company Portal.app" ]; then
echo "$(tput setaf 2)Company Portal is already installed [✓]$(tput sgr0)"
echo "$(tput setaf 2)Performance Mode enabled [✓]$(tput sgr0)"
echo "$(tput setaf 2)Disabling spotlight [✓]$(tput sgr0)"
exit 0
fi

## Install Company Portal
echo "Installing Company Portal"
cd ~/Downloads

# Download the .pkg file using curl
echo "$(tput setaf 2)Downloading and installing Company Portal ...$(tput sgr0)"
sudo curl -LO https://github.com/ugurkocde/MacOSXforIntune/raw/main/CompanyPortal-Installer.pkg -o ~/Downloads/CompanyPortal-Installer.pkg

# Install the .pkg file silently using the installer command
sudo installer -pkg *.pkg -target /

# Remove the downloaded .pkg file
sudo rm CompanyPortal-Installer.pkg
echo "$(tput setaf 2)Company Portal installed$(tput sgr0)"
# Build checks if the company portal is installed

messages=(
  "$(tput setaf 2)Performance Mode enabled [✓]$(tput sgr0)"
  "$(tput setaf 2)Disabling spotlight [✓]$(tput sgr0)"
  "$(tput setaf 2)Company Portal is already installed [✓]$(tput sgr0)"
  "$(tput setaf 2)Downloading and installing Company Portal [✓]$(tput sgr0)"
  "$(tput setaf 2)Company Portal installed [✓]$(tput sgr0)"
)

for message in "${messages[@]}"; do
  echo "$message"
done

# User runs this: curl -s https://raw.githubusercontent.com/myusername/myrepo/main/install_pkg.sh | bash
