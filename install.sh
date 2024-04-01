#!/bin/bash

color=$(tput setaf 3) # yellow
reset=$(tput sgr0)

if [ "$EUID" -ne 0 ]; then
  echo "${color}Run script with root permissions.${reset}"
  exit 1
fi

echo "${color}Time config...${reset}"
timedatectl set-local-rtc 1

echo "${color}Dnf config...${reset}"
echo "fastestmirror=true" >> /etc/dnf/dnf.conf
echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
echo "deltarpm=true" >> /etc/dnf/dnf.conf

echo "${color}Update and upgrade system...${reset}"
dnf -y update && dnf -y upgrade 

echo "${color}Install Docker...${reset}"
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
usermod -a -G docker $USER
newgrp docker

echo "${color}Install VSCode...${reset}"
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update 
dnf -y install code 

echo "${color}Install kitty...${reset}"
dnf -y install kitty 

echo "${color}Install Flatpak...${reset}"
dnf -y install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "${color}Install ibus...${reset}"
dnf config-manager --add-repo https://download.opensuse.org/repositories/home:lamlng/Fedora_39/home:lamlng.repo
dnf -y install ibus-bamboo

echo "${color}Install Input Remapper ...${reset}"
dnf -y install input-remapper
systemctl enable --now input-remapper


echo "${color}Install Table Plus...${reset}"
rpm -v --import https://yum.tableplus.com/apt.tableplus.com.gpg.key
dnf config-manager --add-repo https://yum.tableplus.com/rpm/x86_64/tableplus.repo
dnf -y install tableplus

echo "${color}Install some app...${reset}"
dnf -y install neofetch btop cava cmatrix cbonsai jetbrains-mono-fonts-all ranger gnome-tweaks xkill util-linux-user
flatpak -y install flathub com.spotify.Client
flatpak -y install flathub com.getpostman.Postman 
flatpak -y install flathub tv.plex.PlexDesktop
flatpak -y install flathub org.videolan.VLC
flatpak install flathub one.ablaze.floorp

echo "${color}Install Postman Proxy...${reset}"
cd ~/.var/app/com.getpostman.Postman/config/Postman/proxy
openssl req -subj '/C=US/CN=Postman Proxy' -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -keyout postman-proxy-ca.key -out postman-proxy-ca.crt

echo "${color}Install Nodejs...${reset}"
curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm env use --global lts

echo "${color}Install Pop Shell...${reset}"
dnf -y install gnome-shell-extension-pop-shell xprop 

echo "${color}Done.${reset}"
