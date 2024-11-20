#!/bin/bash

set -ex

# Setup Full HD resolution

if sudo grep -q '^GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub; then
    sudo sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet video=hyperv_fb:1920x1080"|' /etc/default/grub
else
    sudo echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet video=hyperv_fb:1920x1080"' >> /etc/default/grub
fi

sudo update-grub

# Update

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

# Base packages

sudo apt -y install wget curl git

# Speedtest CLI

curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get -y install speedtest-cli

# Share Clipboard

wget https://github.com/viordash/ShareClipbrd/releases/download/v1.0.3/ShareClipbrd-linux64.tar
mkdir ShareClipbrdApp
tar -xvf ShareClipbrd-linux64.tar -C ShareClipbrdApp
sudo ln -s $(pwd)/ShareClipbrdApp/ShareClipbrdApp /usr/bin/share-clipbrd

# VS Code

wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb
sudo apt -y install ./vscode.deb

# Git

git config --global user.name "IlorDash"
git config --global user.email "ilordash02@gmail.com"
git config --global credential.credentialStore cache
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.0/gcm-linux_amd64.2.6.0.tar.gz -O gcm-linux_amd64.2.6.0.tar.gz
sudo tar -xvf gcm-linux_amd64.2.6.0.tar.gz -C /usr/local/bin
git-credential-manager configure

sudo apt autoremove
sudo reboot now
