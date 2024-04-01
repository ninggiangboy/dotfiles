if [ "$EUID" -ne 0 ]; then
  echo "${color}Run script with root permissions.${reset}"
  exit 1
fi

echo "${color}Install zsh...${reset}"
dnf -y install zsh 
cp -r $PWD/.zshrc ~/.zshrc
echo "${color}Install oh-my-zsh...${reset}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "${color}Install zsh plugins...${reset}"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
