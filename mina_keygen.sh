#!/bin/sh

#add the mina repository to the sources list and install mina keypair utility
echo "Adding Mina repositories:"
echo "deb [trusted=yes] http://packages.o1test.net release main" | sudo tee /etc/apt/sources.list.d/mina.list
sudo apt-get update > /dev/null

echo "Installing the Mina keygen utility..."
sudo apt-get install -y libjemalloc-dev > mina_kegen.log #this item is a required dependancy 
sudo apt-get install mina-generate-keypair=1.1.8-b10c0e3 >> mina_kegen.log

#create the required directories and permissions
mkdir ~/keys
chmod 700 ~/keys
mina-generate-keypair -privkey-path ~/keys/my-wallet

chmod 600 ~/keys/my-wallet
mkdir ~/.mina-config

#print final confirmation
echo "Private/Public key pair generated sucessfully"