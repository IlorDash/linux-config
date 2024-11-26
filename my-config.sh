#!/bin/bash

set -ex

# Packages versions

SHARE_CLIPBRD_VER="1.0.3"
GCM_VER="2.6.0"
BTOP_VER="1.4.0"

# User

GIT_USERNAME="IlorDash"
GIT_EMAIL="ilordash02@gmail.com"

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

# Install packages

sudo apt -y install wget curl git minicom

# Speedtest CLI

curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get -y install speedtest-cli
# Remove ookla repository, because it's fails due to unsecure
sudo rm /etc/apt/sources.list.d/ookla_speedtest-cli.list

# Share Clipboard

# wget https://github.com/viordash/ShareClipbrd/releases/download/v${SHARE_CLIPBRD_VER}/ShareClipbrd-linux64.tar
# mkdir ShareClipbrdApp
# tar -xvf ShareClipbrd-linux64.tar -C ShareClipbrdApp
# sudo ln -s $(pwd)/ShareClipbrdApp/ShareClipbrdApp /usr/bin/share-clipbrd
# Run Share Clipboard at startup
mkdir -p /home/${USER}/.config/autostart
touch /home/${USER}/.config/autostart/share-clipbrd.desktop
cat > /home/${USER}/.config/autostart/share-clipbrd.desktop << EOL
[Desktop Entry]
Type=Application
Exec=share-clipbrd
Hidden=false
Name[en_US]=share-clipbrd
Name=share-clipbrd
Comment[en_US]=
Comment=
X-MATE-Autostart-Delay=0
EOL

# VS Code

wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable -O vscode.deb
sudo apt -y install ./vscode.deb

# Git

git config --global user.name "${GIT_USERNAME}"
git config --global user.email "${GIT_EMAIL}"
git config --global credential.credentialStore cache
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v${GCM_VER}/gcm-linux_amd64.${GCM_VER}.tar.gz -O gcm-linux_amd64.${GCM_VER}.tar.gz
sudo tar -xvf gcm-linux_amd64.${GCM_VER}.tar.gz -C /usr/local/bin
git-credential-manager configure

# btop

wget https://github.com/aristocratos/btop/releases/download/v${BTOP_VER}/btop-x86_64-linux-musl.tbz
tar -xvjf btop-x86_64-linux-musl.tbz
cd btop
sudo make install
sudo make setcap

sudo apt autoremove
sudo reboot now
