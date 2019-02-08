#!/usr/bin/env bash

# Drop squid3 build folder
if [ -e build/squid3 ]
then
  rm -R build/squid3
fi

# We will be working in a subfolder make it
mkdir -p build/squid3

# Descend into working directory
pushd build/squid3

# Add sources, download and build
sudo sed -i -e 's/#deb-src/deb-src/' /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y build-dep squid3
sudo apt-get -y source squid3

cd squid3-3*
./configure --enable-esi \
 		--enable-icmp \
 		--enable-zph-qos \
		--enable-ecap \
		--enable-ssl \
		--enable-ssl-crtd \
 		--disable-translation \
 		--with-swapdir=/var/spool/squid \
 		--with-logdir=/var/log/squid
make & make install

# Return to home
popd

