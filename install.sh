#!/usr/bin/env bash
# How to use:
# . /setup.sh

echo "Ensure .bash_profile exists"
touch ~/.bash_profile

# ==============================================================================
# SYMLINKS
# ==============================================================================
echo "Creating Symlinks:"

ln -s $(pwd)/.aliases ~/.aliases
ln -s $(pwd)/.exports ~/.exports
ln -s $(pwd)/.functions ~/.functions
ln -s $(pwd)/.gitconfig ~/.gitconfig
ln -s $(pwd)/.inputrc ~/.inputrc
ln -s $(pwd)/.path ~/.path
ln -s $(pwd)/.tmux.conf ~/.tmux.conf
ln -s $(pwd)/.zshrc ~/.zshrc

# ==============================================================================
# APPS
# ==============================================================================
brews=(
  # Infrastructure
  ansible
  awscli
  terraform

  # Linux
  tree
  wget

  # Others
  hugo # Static website generator https://gohugo.io
  node
  nodenv
  openssl
  yarn
)

casks=(
  # Databases
  postgres
  robomongo
  sequel-pro

  # Others
  atom
  chrome-devtools
  docker
  droplr
  google-chrome
  iconjar
  iterm2
  insomnia
  macdown
  ngrok
  postman
  screenhero
  skype
  slack
  telegram
  visual-studio-code
)

npms=(
  commitizen
  plop
  pm2
  surge
  tsd
)

# List installed extensions: code --list-extensions
vscode=(
  # Alan.stylus
  # DSKWRK.vscode-generate-getter-setter
  # EditorConfig.EditorConfig
  # HookyQR.ExtensionUpdateCheck
  # HookyQR.JSDocTagComplete
  # LaurentTreguier.vscode-simple-icons
  # MattiasPernhult.vscode-todo
  # PKief.material-icon-theme
  # TwentyChung.jsx
  # Tyriar.sort-lines
  # akamud.vscode-theme-onedark
  # alefragnani.Bookmarks
  # bradgashler.htmltagwrap
  # chenxsan.vscode-standardjs
  # christian-kohler.npm-intellisense
  # christian-kohler.path-intellisense
  # dbaeumer.vscode-eslint
  # donjayamanne.githistory
  # dzannotti.vscode-babel-coloring
  # eg2.tslint
  # emmanuelbeziat.vscode-great-icons
  # file-icons.file-icons
  # formulahendry.auto-rename-tag
  # formulahendry.code-runner
  # mattyjones.vscode-tickscript
  # mauve.terraform
  # mindginative.terraform-snippets
  # ms-vscode.Theme-MaterialKit
  # msjsdiag.debugger-for-chrome
  # ow.vscode-subword-navigation
  # pprice.better-merge
  # robertohuertasm.vscode-icons
  # shardulm94.trailing-spaces
  # shyykoserhiy.vscode-spotify
  # spywhere.guides
  # stevencl.addDocComments
  # sysoev.language-stylus
  # vector-of-bool.gitflow
  # wmaurer.html2jade
  # wmaurer.join-lines
)

# ==============================================================================
# HELPERS
# ==============================================================================
set +e
set -x

function prompt {
  # read -p "Hit Enter to $1 ..."
  echo "$1"
}

if test ! $(which brew); then
  prompt "Install Xcode"
  xcode-select --install

  prompt "Install Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  prompt "Update Homebrew"
  brew update
  brew upgrade
  brew prune
  brew cleanup
fi
brew doctor
brew tap homebrew/dupes

function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    prompt "Execute: $exec"
    if ${exec} ; then
      echo "Installed $pkg"
    else
      echo "Failed to execute: $exec"
    fi
  done
}

# ==============================================================================
# INSTALLATION
# ==============================================================================
prompt "Install brew packages"
brew info ${brews[@]}
install 'brew install' ${brews[@]}

prompt "Install software"
brew tap caskroom/versions
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}

prompt "Installing secondary packages"
install 'npm install --global' ${npms[@]}
install 'code --install-extension' ${vscode[@]}
# brew tap caskroom/fonts
# install 'brew cask install' ${fonts[@]}

# ==============================================================================
# SSH KEYS
# ==============================================================================
echo "Creating SSH Keys:"

# Create destination folder and file
sudo mkdir /etc/ssl && mkdir /etc/ssl/certs
sudo touch /etc/ssl/certs/ca-certificates.crt

# Create certificate file to use on Gitlab-ci runner
openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:4096 -keyout gitlab.key -out /etc/ssl/certs/gitlab.pem

# Copy the key to the right location
sudo tee -a /etc/ssl/certs/ca-certificates.crt < /etc/ssl/certs/gitlab.pem

# Create certificate file to use on Terraform AWS
sudo openssl genrsa -des3 -passout pass:x -out /etc/ssl/certs/server.pass.key 2048
sudo openssl rsa -passin pass:x -in /etc/ssl/certs/server.pass.key -out /etc/ssl/certs/server.key
sudo rm -f /etc/ssl/certs/server.pass.key
sudo openssl req -new -key /etc/ssl/certs/server.key -out /etc/ssl/certs/server.csr
sudo openssl x509 -req -sha256 -days 365 -in /etc/ssl/certs/server.csr -signkey /etc/ssl/certs/server.key -out /etc/ssl/certs/server.crt

# Databases
# ==============================================================================
echo "Installing Mongodb"
brew install mongodb --with-openssl
mkdir -p /data/db && chmod 777 /data/db

# Node
# ==============================================================================
echo "Installing nvm (https://github.com/creationix/nvm)"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash

echo "Installing Node"
nvm install node

echo "Node info"
npm which
npm -v

# Shell
# ==============================================================================
echo "Making Zsh the default shell"
chsh -s $(which zsh)

echo "Installing Oh My Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# Activate autocomplete
# ==============================================================================
autoload bashcompinit
bashcompinit
source ~/.bash_profile

# MacOS preferences
# ==============================================================================
source ./.macos

# Cleanup
# ==============================================================================
prompt "Cleanup"
brew cleanup
brew cask cleanup
echo "Done!"
