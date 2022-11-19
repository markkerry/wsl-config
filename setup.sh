#!/bin/bash

# Description:  This script will configure Ubuntu in WSL
# Written by:   Mark kerry
# Date:         18/11/2022
# Version:      1.0
# Comment:      This version is designed to be able to handle being run multiple times
#               if there was a problem with the initial setup.


# Functions
# Add dockerd to sudoers for the user.
addUserToSudoers() {
    echo 'Configuring Docker'
sudo cat << EOF >> /etc/sudoers

$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/dockerd
EOF
}

# Populate the .bashrc file via cat EOF method
configureBashrc() {
cat << EOF >> .bashrc

# Set working directory to ~ incase using Windows Terminal
cd ~

# Auto patch on start
sudo apt update && sudo apt upgrade -y

EOF
}

# Set dockerd to start in .bashrc via echo method
setDockerStartAuto() {
    echo '# Start Docker daemon automatically when logging in if not running.' >> ~/.bashrc
    echo 'RUNNING=`ps aux | grep dockerd | grep -v grep`' >> ~/.bashrc
    echo 'if [ -z "$RUNNING" ]; then' >> ~/.bashrc
    echo '    sudo dockerd > /dev/null 2>&1 &' >> ~/.bashrc
    echo '    disown' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
}

echo 'Creating a .hushlogin in ~'
if [ -f ~/.hushlogin ]
then
    echo '.hushlogin already exists in ~'
else
    touch ~/.hushlogin
fi

# populate the .bashrc
if grep -q 'sudo apt update && sudo apt upgrade -y' ~/.bashrc
then
    echo 'Auto update already set in .bashrc file'
else
    echo 'Editing .bashrc file'
    cp ~/.bashrc ~/.bashrc.bak
    configureBashrc
fi

echo 'Installing updates for Ubuntu'
sudo apt update && sudo apt upgrade -y

echo 'Installing Docker'
sudo apt remove docker docker-engine docker.io
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt update
sudo apt install \
    docker-ce \
    docker-ce-cli \
    containerd.io -y

sudo usermod -a -G docker $USER

if grep -q 'Start Docker daemon automatically' ~/.bashrc
then
    echo 'Docker daemon already set to start in .bashrc'
else
    echo 'Setting Docker daemon to start in .bashrc'
    setDockerStartAuto
fi

# Install AZCLI
echo 'Installing AZ CLI'
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli -y

echo 'Restart Ubuntu to use Docker'