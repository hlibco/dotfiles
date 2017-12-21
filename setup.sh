#!/bin/bash

# -------------------------------------
# START
# -------------------------------------
if test "$(uname)" = "Darwin"; then
  if test ! $(which gcc); then
    echo "Install Xcode..."
    xcode-select --install
  fi
  if test ! "$(which brew)"; then
    echo "Install homebrew..."
    sudo chown $(whoami) '/usr/local' '/usr/local/Caskroom' "${HOME}/Library/Caches/Homebrew/"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    brew update
    brew upgrade
    brew prune
    brew cleanup
  fi
  if test ! "$(which ansible)"; then
    echo "Install Ansible..."
    brew install ansible
  else
    brew upgrade ansible
  fi
else
  echo "This script targets MacOSX."
  exit 1
fi

if test ! "$(which ansible)"; then
  echo "Not supported yet."
  exit 1
fi

# Print versions
python --version
ansible --version

# Run playbook
ansible-playbook main.yml -i hosts --flush-cache
# Use with: --check / --syntax-check

# Docker auto completion
mkdir -p ~/.zsh/completion
curl -L https://raw.githubusercontent.com/docker/compose/1.18.0/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose

ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion /usr/local/etc/bash_completion.d/docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion /usr/local/etc/bash_completion.d/docker-machine
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion /usr/local/etc/bash_completion.d/docker-compose

ln -s /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion /usr/local/share/zsh/site-functions/_docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.zsh-completion /usr/local/share/zsh/site-functions/_docker-machine
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion /usr/local/share/zsh/site-functions/_docker-compose

autoload -Uz compinit && compinit -i
exec $SHELL -l

# Reboot after installation is done
function reboot {
  `sudo fdesetup isactive`
  if [[ $? != 0 ]]; then
    read -p ">> Do you want to reboot? [Yn]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo ''
      sudo reboot
    fi
  fi
}
# reboot
