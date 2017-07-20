#!/usr/bin/env bash
# How to use:
# . /setup.sh
DOTFILES_ROOT=$(pwd -P)

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

# ln -s $(pwd)/.aliases ~/.aliases
# ln -s $(pwd)/.exports ~/.exports
# ln -s $(pwd)/.functions ~/.functions
# ln -s $(pwd)/.gitconfig ~/.gitconfig
# ln -s $(pwd)/.gitignore ~/.gitignore
# ln -s $(pwd)/.inputrc ~/.inputrc
# ln -s $(pwd)/.path ~/.path
# ln -s $(pwd)/.tmux.conf ~/.tmux.conf
# ln -s $(pwd)/.zshrc ~/.zshrc


# ==============================================================================
# HELPERS
# ==============================================================================
set +e
set -x

# link_file() {
#   if [ -e "$2" ]; then
#     if [ "$(readlink "$2")" = "$1" ]; then
#       success "skipped $1"
#       return 0
#     else
#       mv "$2" "$2.backup"
#       success "moved $2 to $2.backup"
#     fi
#   fi
#   ln -sf "$1" "$2"
#   success "linked $1 to $2"
# }

# install_dotfiles() {
#   info 'installing dotfiles'
#   find -H "$DOTFILES_ROOT" -maxdepth 3 -name '*.symlink' -not -path '*.git*' |
#     while read -r src; do
#       dst="$HOME/.$(basename "${src%.*}")"
#       echo $dst
#       # link_file "$src" "$dst"
#     done
# }

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
if test ! $(which gcc); then
  echo "Installing Xcode..."
  xcode-select --install
fi


# Shell
# ==============================================================================
echo "Making Zsh the default shell"

find_zsh() {
  if which zsh >/dev/null 2>&1 && grep "$(which zsh)" /etc/shells >/dev/null; then
    which zsh
  else
    echo "/bin/zsh"
  fi
}

zsh="$(find_zsh)"
test which chsh >/dev/null 2>&1 &&
  chsh -s "$zsh" &&
  success "set $("$zsh" --version) at $zsh as default shell"


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
