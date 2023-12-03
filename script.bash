#!/bin/bash

red=$(tput setaf 3)
reset=$(tput sgr0)

if [ "$EUID" -ne 0 ]; then
  echo "${red}Run script with root permissions.${reset}"
  exit 1
fi

echo "${red}Dnf config...${reset}"
echo "fastestmirror=true" >> /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
echo "deltarpm=true" >> /etc/dnf/dnf.conf

echo "${red}Update and upgrade system...${reset}"
dnf -y update && dnf -y upgrade

echo "${red}Install Docker...${reset}"
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

mkdir ~/.config/

echo "${red}Install kitty...${reset}"
dnf -y install kitty
cp -r kitty ~/.config/

echo "${red}Install zsh...${reset}"
dnf -y install zsh
chsh -s $(which zsh)
echo "${red}Install oh-my-zsh...${reset}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "${red}Install zsh plugins...${reset}"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
cp .zshrc ~/

echo "${red}Git config...${reset}"
cp .gitconfig ~/

echo "${red}Install Flatpak...${reset}"
dnf -y install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "${red}Install some app...${reset}"
dnf -y install neofetch
dnf -y install btop
dnf -y install cava
dnf -y install cmatrix
dnf -y install cbonsai
dnf -y install jetbrains-mono-fonts-all
flatpak -y install flathub org.videolan.VLC
flatpak -y install flathub com.spotify.Client
flatpak -y install flathub tv.plex.PlexDesktop
flatpak -y install flathub com.getpostman.Postman
flatpak -y install flathub com.jetbrains.IntelliJ-IDEA-Ultimate
flatpak -y install flathub com.jetbrains.Rider
flatpak -y install flathub org.qbittorrent.qBittorrent
flatpak -y install flathub com.anydesk.Anydesk
flatpak -y install flathub com.visualstudio.code

echo "${red}Install Pop Shell...${reset}"
dnf -y install gnome-shell-extension-pop-shell xprop