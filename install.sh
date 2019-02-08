#!/usr/bin/env bash

# Script to install base packages and updates to vanilla Pi deployment
# Assumption is git is already installed :-)

# Update the OS and Install WittyPi2 and other base packages if not already installed.
cd ~
mkdir status

if [ -e ./status/os_updated ]
then
  echo "Initial OS update completed, skipping..."
else
  sudo apt-get -y update; sudo apt-get -y upgrade
  touch ./status/os_updated
fi

if [ -e ./status/witty_installed ]
then
  echo "WittyPi installed, skipping..."
else
  wget http://www.uugear.com/repo/WittyPi2/installWittyPi.sh
  sudo sh ./installWittyPi.sh
  sudo apt-get -y upgrade
  touch ./status/witty_installed
fi

if [ -e ./status/post_install_reboot ]
then
  echo "Post install reboot occurred, skipping another one..."
else
  touch ./status/post_install_reboot
  wait
  shutdown -r 0
fi

# Install latest nginx, squid and calamaris configurations
echo "Updating nginx, calamaris and squid configuration..."
./piproxy/proxy_config/update_proxy_services.sh

# Re-apply blacklists
echo "Updating blacklist of websites..."
./piproxy/proxy_config/update_proxy_blacklist.sh

# Have we built Squid yet?
if [ -e ./status/proxy_installed ]
then
  echo "SquidGuard, nginx and Calamaris installed, skipping..."
else
  sudo apt-get install -y squidguard calamaris nginx openssl libssl-dev
  ./squid_build/build_squid.sh
  touch ./status/proxy_installed
  shutdown -r 0
fi



