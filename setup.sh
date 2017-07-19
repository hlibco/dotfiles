#!/bin/bash

touch /etc/ansible/hosts

if test "$(uname)" = "Darwin"; then
  if test ! $(which gcc); then
    echo "Installing xcode..."
    xcode-select --install
  fi
  if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    brew update
  fi
  if test ! "$(which ansible)"; then
    echo "Installing ansible..."
    brew install ansible
  else
    brew upgrade ansible
  fi
elif test "$(uname)" = "Linux"; then
  if test -f /etc/lsb-release && test ! "$(which ansible)"; then
    echo "Installing ansible..."
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
ansible-playbook main.yml
test -d ~/dotfiles && cd $_ && ./bootstrap.sh