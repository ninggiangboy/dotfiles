#!/bin/bash

set -e

red=$(tput setaf 3)
reset=$(tput sgr0)

if [ "$EUID" -ne 0 ]; then
  echo "${yellow}Run script with root permissions.${reset}"
  exit 1
fi

echo "${yellow}Time config...${reset}"
timedatectl set-local-rtc 1

echo "${yellow}Dnf config...${reset}"
echo "fastestmirror=true" >> /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
echo "deltarpm=true" >> /etc/dnf/dnf.conf

echo "${yellow}Update and upgrade system...${reset}"
dnf -y update && dnf -y upgrade

echo "${yellow}Install Docker...${reset}"
dnf -y remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-selinux \
    docker-engine-selinux \
    docker-engine
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
systemctl enable docker
systemctl restart docker
sudo chmod 666 /var/run/docker.sock

echo "${yellow}Install .Net...${reset}"
sudo dnf install dotnet-sdk-7.0

mkdir ~/.config/

echo "${yellow}Install kitty...${reset}"
dnf -y install kitty
mkdir -p ~/.config/kitty
cp -r ./kitty/kitty.conf ~/.config/kitty/kitty.conf

echo "${yellow}Install zsh...${reset}"
dnf -y install zsh
chsh -s $(which zsh)
echo "${yellow}Install oh-my-zsh...${reset}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "${yellow}Install zsh plugins...${reset}"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
cp .zshrc ~/

echo "${yellow}Git config...${reset}"
cp .gitconfig ~/

echo "${yellow}Install Flatpak...${reset}"
dnf -y install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "${yellow}Install ibus...${reset}"
dnf config-manager --add-repo https://download.opensuse.org/repositories/home:lamlng/Fedora_39/home:lamlng.repo
dnf -y install ibus-bamboo

echo "${yellow}Install Input Remapper ...${reset}"
dnf -y install input-remapper
systemctl enable --now input-remapper

echo "${yellow}Install some app...${reset}"
dnf -y install neofetch btop cava cmatrix cbonsai jetbrains-mono-fonts-all ranger
flatpak -y install flathub org.videolan.VLC
flatpak -y install flathub com.spotify.Client
flatpak -y install flathub tv.plex.PlexDesktop
flatpak -y install flathub com.getpostman.Postman
flatpak -y install flathub com.jetbrains.IntelliJ-IDEA-Ultimate
flatpak -y install flathub com.jetbrains.Rider
flatpak -y install flathub org.qbittorrent.qBittorrent
flatpak -y install flathub com.anydesk.Anydesk
flatpak -y install flathub com.visualstudio.code

echo "${yellow}Install Pop Shell...${reset}"
dnf -y install gnome-shell-extension-pop-shell xprop
