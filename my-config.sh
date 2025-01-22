#!/bin/bash

set -ex

cd ~

# Packages versions

SHARE_CLIPBRD_VER="1.0.3"
GCM_VER="2.6.0"
BTOP_VER="1.4.0"

# User

GIT_USERNAME="IlorDash"
GIT_EMAIL="ilordash02@gmail.com"

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

wget https://github.com/viordash/ShareClipbrd/releases/download/v${SHARE_CLIPBRD_VER}/ShareClipbrd-linux64.tar
mkdir ShareClipbrdApp
tar -xvf ShareClipbrd-linux64.tar -C ShareClipbrdApp
sudo ln -s "$(pwd)"/ShareClipbrdApp/ShareClipbrdApp /usr/bin/share-clipbrd
# Run Share Clipboard at startup
mkdir -p /home/"${USER}"/.config/autostart
touch /home/"${USER}"/.config/autostart/share-clipbrd.desktop
cat > /home/"${USER}"/.config/autostart/share-clipbrd.desktop << EOL
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

# i3wm

/usr/lib/apt/apt-helper download-file \
    https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb \
    keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
sudo apt install ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) \
    universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
sudo apt install i3

sudo apt -y install xorg lightdm lightdm-gtk-greeter i3status i3blocks dmenu \
    terminator tmux feh materia-gtk-theme papirus-icon-theme lxappearance fonts-font-awesome \
    picom fonts-droid-fallback
sudo systemctl enable lightdm.service
# i3lock-color
sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev \
    libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev \
    libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev \
    libxkbcommon-x11-dev libjpeg-dev
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./build.sh
./install-i3lock-color.sh

# zsh

sudo apt install zsh git fonts-font-awesome
echo y | RUNZSH=no sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k

sudo adduser "${USER}" dialout

cp -r home/.* /home/"${USER}"/

sudo apt autoremove
sudo reboot now
