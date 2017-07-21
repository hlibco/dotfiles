#!/bin/bash

# ansible-playbook main.yml --flush-cache
# --syntax-check
# --check (dry mode: do not actually run)

# sudo pmset -a sleep 0
# sudo pmset -a disksleep 0
# sudo chmod a+x /etc/environment

# Set permissions
chown $USER ~/.ssh


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
elif test "$(uname)" = "Linux"; then
  if test -f /etc/lsb-release && test ! "$(which ansible)"; then
    echo "Install Ansible..."
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible
  fi
  printf '\n%s\n%s\n' '[privilege_escalation]' 'become = True' >> ansible.cfg
fi

if test ! "$(which ansible)"; then
  echo "Not supported yet."
  exit 1
fi

python --version
ansible --version
ansible-playbook main.yml -i hosts --flush-cache

# Reboot after installation is done
function reboot {
  `sudo fdesetup isactive`
  if [[ $? != 0 ]]; then
    read -p "##### Do you want to reboot? [Yn]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo ''
      sudo reboot
    fi
  fi
}
# reboot
