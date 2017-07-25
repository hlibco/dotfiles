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
