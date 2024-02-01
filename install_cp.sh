echo "${color}Copy config file...${reset}"
mkdir -p $HOME/.config/kitty/
cp -r $PWD/kitty/kitty.conf $HOME/.config/kitty/kitty.conf
cp -r $PWD/.gitconfig $HOME/.gitconfig
cp -r $PWD/.zshrc $HOME/.zshrc