#!/bin/sh

# this script can be used to install docker to a linux host if it does not already exist
# this script can be used to install Docker on top of a cloud hosted compute instance or a bare metal server
# https://docs.docker.com/engine/install/ubuntu/

# remove any pre-existing docker installations
echo "Checking for and removing previous Docker installations..."
sudo apt-get remove docker docker-engine docker.io containerd runc > docker_install.log

echo "Checking for and installing Docker dependancies..."
sudo apt-get update > /dev/null
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release >> docker_install.log

echo "Installing the latest Docker release..."
# add GPG key for HTTPS access to Docker repositories
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install Docker and related tools
sudo apt-get update > /dev/null
sudo apt-get install -y docker-ce docker-ce-cli containerd.io >> docker_install.log

echo "Docker installation complete"