echo "${color}Copy config file...${reset}"
mkdir -p ~/.config/kitty/
cp -r $PWD/kitty.conf ~/.config/kitty/kitty.conf
cp -r $PWD/.gitconfig ~/.gitconfig
