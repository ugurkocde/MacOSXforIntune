#!/usr/bin/env bash
echo ""
echo "$(tput sgr 0 3)MacOSX for Intune - Onboarding Script$(tput sgr 0)"
echo "Author: Ugur Koc, Version: 1.0"
echo "Website: www.ugurkoc.de, Twitter: @ugurkocde"

echo ""
echo "This script will do the following:"
echo "  1. Enable Performance Mode"
echo "  2. Disable spotlight"
echo "  3. Check if FileVault is enabled"
echo "  4. Check if SIP (System Integrity Protection) is enabled"
echo "  5. Check if the latest version of macOS is installed"
echo "  6. Check if the Company Portal app is installed"
echo "  7. If the Company Portal app is not installed, download and install it"
echo "  8. Check System Infos"
echo "  9. Check Network Requirements"
echo "  10. Opens the Company Portal"
echo ""
sleep 3

# Check internet connectivity
echo "$(tput setaf 3)Checking internet connectivity ... [◯]$(tput sgr0)"
ping_result=$(ping -c 1 www.google.com)
if [ $? -eq 0 ]; then
    echo "$(tput setaf 2)Connected to the internet $(tput sgr0)"
else
    echo "$(tput setaf 1)Not connected to the internet $(tput sgr0)"
fi

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
if fdesetup status | grep "FileVault is On" >/dev/null; then
    # FileVault is already enabled, add message to messages array
    echo "FileVault is already enabled."
    messages+=("$(tput setaf 2)FileVault is enabled. [✓]$(tput sgr0)")
else
    echo "FileVault is not enabled."
    messages+=("$(tput setaf 1)FileVault is NOT enabled. [X]$(tput sgr0)")
fi

# Check if SIP (System Integrity Protection) is enabled
echo "$(tput setaf 3)Checking if SIP (System Integrity Protection) is enabled ... [◯]$(tput sgr0)"
if csrutil status | grep "enabled" >/dev/null; then
    # SIP is enabled, add message to messages array
    echo "SIP (System Integrity Protection) is enabled."
    messages+=("$(tput setaf 2)SIP (System Integrity Protection) is enabled. [✓]$(tput sgr0)")
else
    # SIP is not enabled, add message to messages array
    echo "SIP (System Integrity Protection) is not enabled."
    messages+=("$(tput setaf 1)SIP (System Integrity Protection) is NOT enabled. [X]$(tput sgr0)")
fi

# Get system info
current_version=$(sw_vers -productVersion)
messages_systeminfo+=("$(tput setaf 2)Currently installed macOS Version: $current_version$(tput sgr0)")
model_id=$(system_profiler SPHardwareDataType | grep 'Model Identifier' | awk -F ': ' '{print $2}')
messages_systeminfo+=("$(tput setaf 2)Model ID: $model_id$(tput sgr0)")
serial_number=$(system_profiler SPHardwareDataType | grep 'Serial Number (system)' | awk -F ': ' '{print $2}')
messages_systeminfo+=("$(tput setaf 2)Serial Number: $serial_number$(tput sgr0)")
ram=$(system_profiler SPHardwareDataType | grep 'Memory' | awk -F ': ' '{print $2}')
messages_systeminfo+=("$(tput setaf 2)RAM: $ram$(tput sgr0)")
free_storage=$(df -h | grep '/$' | awk '{print $4}')
messages_systeminfo+=("$(tput setaf 2)Free Storage: $free_storage$(tput sgr0)")

# Check Network Requirements - START

echo "$(tput setaf 3)Pinging manage.microsoft.com ... [◯]$(tput sgr0)"
ping_result=$(nc -z manage.microsoft.com 443)
if [ $? -eq 0 ]; then
    messages_network+=("$(tput setaf 2)Successfully pinged manage.microsoft.com [✓]$(tput sgr0)")
else
    messages_network+=("$(tput setaf 1)Failed to ping manage.microsoft.com [X]$(tput sgr0)")
fi

echo "$(tput setaf 3)Pinging apple.com ... [◯]$(tput sgr0)"
ping_result=$(nc -z apple.com 443)
if [ $? -eq 0 ]; then
    messages_network+=("$(tput setaf 2)Successfully pinged apple.com [✓]$(tput sgr0)")
else
    messages_network+=("$(tput setaf 1)Failed to ping apple.com [X]$(tput sgr0)")
fi

echo "$(tput setaf 3)Pinging itunes.apple.com ... [◯]$(tput sgr0)"
ping_result=$(nc -z itunes.apple.com 443)
if [ $? -eq 0 ]; then
    messages_network+=("$(tput setaf 2)Successfully pinged itunes.apple.com [✓]$(tput sgr0)")
else
    messages_network+=("$(tput setaf 1)Failed to ping itunes.apple.com [X]$(tput sgr0)")
fi

echo "$(tput setaf 3)Pinging ocsp.apple.com ... [◯]$(tput sgr0)"
ping_result=$(nc -z ocsp.apple.com 443)
if [ $? -eq 0 ]; then
    messages_network+=("$(tput setaf 2)Successfully pinged ocsp.apple.com [✓]$(tput sgr0)")
else

    messages_network+=("$(tput setaf 1)Failed to ping ocsp.apple.com [X]$(tput sgr0)")
fi

echo "$(tput setaf 3)Pinging phobos.apple.com ... [◯]$(tput sgr0)"
ping_result=$(nc -z phobos.apple.com 443)
if [ $? -eq 0 ]; then
    messages_network+=("$(tput setaf 2)Successfully pinged phobos.apple.com [✓]$(tput sgr0)")
else
    messages_network+=("$(tput setaf 1)Failed to ping phobos.apple.com [X]$(tput sgr0)")
fi

echo "$(tput setaf 3)Pinging phobos.itunes-apple.com.akadns.net ... [◯]$(tput sgr0)"
ping_result=$(nc -z phobos.itunes-apple.com.akadns.net 443)
if [ $? -eq 0 ]; then
    messages_network+=("$(tput setaf 2)Successfully pinged phobos.itunes-apple.com.akadns.net [✓]$(tput sgr0)")
else
    messages_network+=("$(tput setaf 1)Failed to ping phobos.itunes-apple.com.akadns.net [X]$(tput sgr0)")
fi

echo "$(tput setaf 3)Pinging 5-courier.push.apple.com ... [◯]$(tput sgr0)"
ping_result=$(nc -z 5-courier.push.apple.com 443)
if [ $? -eq 0 ]; then
    messages_network+=("$(tput setaf 2)Successfully pinged 5-courier.push.apple.com [✓]$(tput sgr0)")
else
    messages_network+=("$(tput setaf 1)Failed to ping 5-courier.push.apple.com [X]$(tput sgr0)")
fi

echo "$(tput setaf 3)Pinging ax.itunes.apple.com ... [◯]$(tput sgr0)"
ping_result=$(nc -z ax.itunes.apple.com 443)
if [ $? -eq 0 ]; then
    messages_network+=("$(tput setaf 2)Successfully pinged ax.itunes.apple.com [✓]$(tput sgr0)")
else
    messages_network+=("$(tput setaf 1)Failed to ping ax.itunes.apple.com [X]$(tput sgr0)")
fi

echo "$(tput setaf 3)Pinging ax.itunes.apple.com.edgesuite.net ... [◯]$(tput sgr0)"
ping_result=$(nc -z ax.itunes.apple.com.edgesuite.net 443)
if [ $? -eq 0 ]; then
    messages_network+=("$(tput setaf 2)Successfully pinged ax.itunes.apple.com.edgesuite.net [✓]$(tput sgr0)")
else
    messages_network+=("$(tput setaf 1)Failed to ping ax.itunes.apple.com.edgesuite.net [X]$(tput sgr0)")
fi

# Check Network Requirements - END

# Check if Company Portal is installed
echo "$(tput setaf 3)Checking if Company Portal is already installed ... [◯]$(tput sgr0)"

if [ -d "/Applications/Company Portal.app" ]; then
    echo "Company Portal is installed."
    messages+=("$(tput setaf 2)Company Portal is installed [✓]$(tput sgr0)")

    echo ""
    echo " -- Check Results --"
    for message in "${messages[@]}"; do
        echo "$message"
    done

    echo ""
    echo " -- System Infos --"
    for message in "${messages_systeminfo[@]}"; do
        echo "$message"
    done

    echo ""
    echo " -- Network Requirements --"
    for message in "${messages_network[@]}"; do
        echo "$message"
    done

    # Show a notification
    osascript -e 'display notification "Script ran succefully." with title "MacOSX for Intune - Onboarding Script"'

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

echo ""
echo " -- Check Results --"
for message in "${messages[@]}"; do
    echo "$message"
done

echo ""
echo " -- System Infos --"
for message in "${messages_systeminfo[@]}"; do
    echo "$message"
done

echo ""
echo " -- Network Requirements --"
for message in "${messages_network[@]}"; do
    echo "$message"
done

# Start Company Portal after finishing this script
echo "Opening Company Portal"
open -a "/Applications/Company Portal.app"

# Show a notification
osascript -e 'display notification "Script ran succefully." with title "MacOSX for Intune - Onboarding Script"'

# User runs this: curl -s https://raw.githubusercontent.com/myusername/myrepo/main/install_pkg.sh | bash
