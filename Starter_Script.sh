#!/usr/bin/env bash

echo ""
echo "This script will do the following:"
echo "  1. Enable Performance Mode"
echo "  2. Disable spotlight"
echo "  3. Check if FileVault is enabled"
echo "  4. Check if SIP (System Integrity Protection) is enabled"
echo "  5. Check if the latest version of macOS is installed"
echo "  6. Check if the Company Portal app is installed"
echo "  7. If the Company Portal app is not installed, download and install it"
echo ""
sleep 3

# Turn on performance mode to dedicate additional system resources
sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"
echo "$(tput setaf 3)Enabling Performance Mode ... [◯]$(tput sgr0)"
messages+=("$(tput setaf 2)Performance Mode enabled [✓]$(tput sgr0)")

# Massively increase virtualized macOS by disabling spotlight.
echo "$(tput setaf 3)Disabling spotlight ... [◯]$(tput sgr0)"
sudo mdutil -i off -a
messages+=("$(tput setaf 2)Spotlight is disabled [✓]$(tput sgr0)")

# Check if FileVault is already enabled
echo "$(tput setaf 3)Checking if FileVault is enabled ... [◯]$(tput sgr0)"
if fdesetup status | grep "FileVault is On" > /dev/null; then
  # FileVault is already enabled, add message to messages array
    echo "FileVault is already enabled."
    messages+=( "$(tput setaf 2)FileVault is enabled. [✓]$(tput sgr0)" )
else
    echo "FileVault is not enabled."
    messages+=( "$(tput setaf 1)FileVault is NOT enabled. [X]$(tput sgr0)" )
fi

# Check if SIP (System Integrity Protection) is enabled
echo "$(tput setaf 3)Checking if SIP is enabled ... [◯]$(tput sgr0)"
if csrutil status | grep "enabled" > /dev/null; then
  # SIP is enabled, add message to messages array
  echo "SIP is enabled."
  messages+=( "$(tput setaf 2)SIP is enabled. [✓]$(tput sgr0)" )
else
  # SIP is not enabled, add message to messages array
  echo "SIP is not enabled."
  messages+=( "$(tput setaf 1)SIP is NOT enabled. [X]$(tput sgr0)" )
fi

# Check if the latest version of macOS is installed
echo "$(tput setaf 3)Checking if the latest version of macOS is installed ... [◯]$(tput sgr0)"
latest_version=$(curl -s https://www.apple.com/support/macos/release-notes/ | grep -o '<h3>.*</h3>' | awk -F '[><]' '{print $3}')
current_version=$(sw_vers -productVersion)
if [ "$latest_version" == "$current_version" ]; then
  # The latest version of macOS is installed, add message to messages array
  messages+=( "$(tput setaf 2)The latest version of macOS is installed. [✓]$(tput sgr0)" )
else
  # The latest version of macOS is not installed, add message to messages array
  messages+=( "$(tput setaf 1)The latest version of macOS is NOT installed. [X]$(tput sgr0)" )
fi

# Check if Company Portal is installed
echo "$(tput setaf 3)Checking if Company Portal is already installed ... [◯]$(tput sgr0)"

if [ -d "/Applications/Company Portal.app" ]; then
    messages+=("$(tput setaf 2)Company Portal is installed [✓]$(tput sgr0)")

for message in "${messages[@]}"; do
  echo "$message"
done

exit 0
fi

## Install Company Portal
echo "$(tput setaf 3)Installing Company Portal ... [◯]$(tput sgr0)"
cd ~/Downloads

# Download the .pkg file using curl
echo "$(tput setaf 3)Downloading and installing Company Portal ... [◯]$(tput sgr0)"
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

messages+=("$(tput setaf 2)Company Portal is installed [✓]$(tput sgr0)")

for message in "${messages[@]}"; do
  echo "$message"
done

# Start Company Portal after finishing this script
open -a "/Applications/Company Portal.app"

# User runs this: curl -s https://raw.githubusercontent.com/myusername/myrepo/main/install_pkg.sh | bash
