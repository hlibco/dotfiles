#!/usr/bin/env bash

alias work='cd ~/git/'
alias private='cd ~/git-private/'
alias convert='ffmpeg -i source.mov -crf 18 -color_primaries 6 -color_trc 6 -colorspace 6 -color_range 1 converted.mp4'

alias profile='sudo vi ~/.bash_profile'
alias hosts='sudo vi /etc/hosts'
alias ..='cd ..'
alias myip='curl ipecho.net/plain ; echo'
alias ping='ping -c 4'

# NPM
alias build="npm run build"
alias start="npm start"
alias test="npm test"
alias ns="npm start"
alias nr="npm run-script"
alias nt="npm test"
alias ni="npm install"
alias nig="npm install -g"
alias nis="npm install --save"
alias nid="npm install --save-dev"
alias nit="npm install && npm test"

# just reload the profile (mnemonic BashSource or BullS*)
bs() { echo "Sourcing ~/.bash_profile" && . ~/.bash_profile; }
reload() { echo "Sourcing ~/.zshrc" && . ~/.zshrc; }

# turn xv on/off
xv() { case $- in *[xv]*) set +xv;; *) set -xv ;; esac }

# simple aliases
alias vb="cd ${BASH_LOAD_ROOT}; v load_bash; cd -; bs;" # edit these conf files
alias less='less -R' # print raw characters
alias ll.='ls -AlhF' # before: 'ls -laF'
alias ls.='ls -F'
alias j='jobs'
alias op='open'

# protection from myself
alias rm='rm -i'
alias mv='mv -i'

# gs t -> g st; false t
alias gs="git st; false" # prevents poltergeist

# rarely used ones, but cool
alias epoch='date +"%s"'
alias version='echo "bash version: ${BASH_VERSION}"'
alias path='echo -e ${PATH//:/\\n}' # nice path printing

# system
alias www="clear; cd ~/git/; ls -l"
alias 777="chmod -Rv 777"
alias 755="chmod -Rv 755"
alias 644="chmod -Rv 644"

# utilities
alias passw="openssl rand -base64 20"
alias untar="tar -xvf"

# use hub wrapper to make me better at GitHub
alias git=hub

alias habits="history | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' | sort | uniq -c | sort -n -r | head -n 10"

# hardware
# alias battery="pmset -g batt | egrep "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';'"

# Linux
alias linux-version="cat /etc/*-release"

# Brew (usage: brew cleanup || brew bump)
if which brew >/dev/null 2>&1; then
	brew() {
		case "$1" in
			cleanup)
				(cd "$(brew --repo)" && git prune && git gc)
				command brew cleanup
				command brew cask cleanup
				command brew prune
				rm -rf "$(brew --cache)"
				;;
			bump)
				command brew update
				command brew upgrade --all
				brew cleanup
				;;
			*)
				command brew "$@"
				;;
		esac
	}
fi
