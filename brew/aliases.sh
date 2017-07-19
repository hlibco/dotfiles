#!/bin/sh
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

# Brew
# alias brewup='brew update; brew upgrade --all; brew prune; brew cleanup; brew doctor'