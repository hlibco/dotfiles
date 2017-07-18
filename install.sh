#!/usr/bin/env bash
# How to use:
# . /setup.sh
sudo pmset -a sleep 0
sudo pmset -a disksleep 0

# Ensure .bash_profile exists
touch ~/.bash_profile

sudo mkdir -p '/usr/local/Caskroom'
sudo chgrp admin '/usr/local/' '/usr/local/Caskroom/' '/Library/ColorPickers/' '/Library/Screen Savers/'
sudo chmod g+w '/usr/local/' '/usr/local/Caskroom/' '/Library/ColorPickers/' '/Library/Screen Savers/'

# Setup /etc/environment
sudo tee /etc/environment > /dev/null <<-EOF
#!/bin/sh
set -e
syslog -s -l warn "Set environment variables for \$(whoami) - start"
CASK_OPTS="--appdir=/Applications"
CASK_OPTS="\${CASK_OPTS} --caskroom=/usr/local/Caskroom"
CASK_OPTS="\${CASK_OPTS} --colorpickerdir=/Library/ColorPickers"
CASK_OPTS="\${CASK_OPTS} --fontdir=/Library/Fonts"
CASK_OPTS="\${CASK_OPTS} --prefpanedir=/Library/PreferencePanes"
CASK_OPTS="\${CASK_OPTS} --screen_saverdir='/Library/Screen Savers'"
export HOMEBREW_CASK_OPTS=\$CASK_OPTS
launchctl setenv HOMEBREW_CASK_OPTS "\$CASK_OPTS"
if [ -x /usr/libexec/path_helper ]; then
  export PATH=""
  eval \`/usr/libexec/path_helper -s\`
  launchctl setenv PATH \$PATH
fi
osascript -e 'tell app "Dock" to quit'
syslog -s -l warn "Set environment variables for \$(whoami) - complete"
EOF

sudo chmod a+x /etc/environment


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
prompt "Install Homebrew"
sudo chown $(whoami) '/usr/local' '/usr/local/Caskroom' "${HOME}/Library/Caches/Homebrew/"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# if test ! $(which brew); then
#   prompt "Install Xcode"
#   xcode-select --install

#   prompt "Install Homebrew"
#   sudo chown $(whoami) '/usr/local' '/usr/local/Caskroom' "${HOME}/Library/Caches/Homebrew/"
#   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# else
#   prompt "Update Homebrew"
#   brew update
#   brew upgrade
#   brew prune
#   brew cleanup
# fi
brew doctor
brew tap homebrew/bundle
# brew tap homebrew/dupes

prompt "Install brew packages"
brew info ${brews[@]}
install 'brew install' ${brews[@]}

prompt "Install software"
brew tap caskroom/versions
brew tap caskroom/cask
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}

prompt "Installing secondary packages"
install 'npm install --global' ${npms[@]}
install 'code --install-extension' ${vscode[@]}
brew tap caskroom/fonts
# install 'brew cask install' ${fonts[@]}

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
