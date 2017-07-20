#!/bin/bash

# sudo pmset -a sleep 0
# sudo pmset -a disksleep 0
# sudo chmod a+x /etc/environment

# -------------------------------------
# PREVENT WARNINGS
# -------------------------------------
create_ansible_hosts () {
  ANSIBLE=/usr/local/etc/ansible
  HOSTS=$ANSIBLE/hosts

  if [ ! -f "$HOSTS" ]; then
    mkdir -p $ANSIBLE && echo "Created $ANSIBLE"
    echo "localhost ansible_connection=local" > $HOSTS && echo "Created $HOSTS"
  fi
}

create_ansible_hosts


# Set permissions
chown $USER ~/.ssh
chmod 400 ~/.ssh/*
chmod 600 ~/.ssh/config

ssh-add -K ~/.ssh/id_rsa

ansible-playbook main.yml --check



# -------------------------------------
# START
# -------------------------------------
# if test "$(uname)" = "Darwin"; then
#   if test ! $(which gcc); then
#     echo "Install Xcode..."
#     xcode-select --install
#   fi
#   if test ! "$(which brew)"; then
#     echo "Install homebrew..."
#     sudo chown $(whoami) '/usr/local' '/usr/local/Caskroom' "${HOME}/Library/Caches/Homebrew/"
#     ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#   else
#     brew update
#     brew upgrade
#     brew prune
#     brew cleanup
#   fi
#   if test ! "$(which ansible)"; then
#     echo "Install Ansible..."
#     brew install ansible
#   else
#     brew upgrade ansible
#   fi
# elif test "$(uname)" = "Linux"; then
#   if test -f /etc/lsb-release && test ! "$(which ansible)"; then
#     echo "Install Ansible..."
#     sudo apt-get install -y software-properties-common
#     sudo apt-add-repository -y ppa:ansible/ansible
#     sudo apt-get update
#     sudo apt-get install -y ansible
#   fi
#   printf '\n%s\n%s\n' '[privilege_escalation]' 'become = True' >> ansible.cfg
# fi

# if test ! "$(which ansible)"; then
#   echo "Not supported yet."
#   exit 1
# fi

# python --version
# ansible --version
# ansible-playbook main.yml --check


# test -d ~/dotfiles && cd $_ && ./bootstrap.sh


# reboot after installation is done
# `sudo fdesetup isactive`
# if [[ $? != 0 ]]; then
#   read -p "##### Do you want to reboot? [Yn]" -n 1 -r
#   if [[ $REPLY =~ ^[Yy]$ ]]; then
#     echo ''
#     sudo reboot
#   fi
# fi