#!/usr/bin/env bash

echo ""
echo "This script will do the following:"
echo "  1. Enable Performance Mode"
echo "  2. Disable spotlight"
echo "  3. Check if FileVault is already enabled"
echo "  4. Check if the Company Portal app is already installed"
echo "  5. If the Company Portal app is not installed, download and install it"
echo "  6. Print a list of messages indicating the status of each step"
echo ""
sleep 3

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
    messages+=( "$(tput setaf 2)FileVault is enabled. [✓]$(tput sgr0)" )
else
    echo "FileVault is not enabled."
    messages+=( "$(tput setaf 1)FileVault is NOT enabled. [X]$(tput sgr0)" )
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
echo "Downloading and installing Company Portal ..."
sudo curl -LO https://github.com/ugurkocde/MacOSXforIntune/raw/main/CompanyPortal-Installer.pkg -o ~/Downloads/CompanyPortal-Installer.pkg

# Install the .pkg file silently using the installer command
sudo installer -pkg *.pkg -target /

# Remove the downloaded .pkg file
sudo rm CompanyPortal-Installer.pkg

if [ -d "/Applications/Company Portal.app" ]; then
    echo "Successfully installed the Company Portal."
else
    echo "Failed to install the Company Portal."
    break
fi


echo "Continuing"
messages+=("$(tput setaf 2)Performance Mode enabled [✓]$(tput sgr0)")
messages+=("$(tput setaf 2)Disabling spotlight [✓]$(tput sgr0)")
messages+=("$(tput setaf 2)Company Portal is installed [✓]$(tput sgr0)")

for message in "${messages[@]}"; do
  echo "$message"
done

# Start Company Portal after finishing this script
open -a "/Applications/Company Portal.app"

# User runs this: curl -s https://raw.githubusercontent.com/myusername/myrepo/main/install_pkg.sh | bash
