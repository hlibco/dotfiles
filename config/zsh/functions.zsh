#!/usr/bin/env bash

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Create a git.io short URL
function gitio() {
	if [ -z "${1}" -o -z "${2}" ]; then
		echo "Usage: \`gitio slug url\`";
		return 1;
	fi;
	curl -i https://git.io/ -F "url=${2}" -F "code=${1}";
}

# Login as the user app
asapp() { sudo su app -c "$*" }

# Get docker container ip
# Use: docker-ip [container_id]
docker-ip() {
	docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
}

function status () {
	case ${1} in
		'php-fpm')
			lsof -Pni4 | grep LISTEN | grep php
		;;
		# 'mariadb'|'nginx')
		# 	brew services list | grep ${1}
		# ;;
		*)
			brew services list | grep ${1}
	esac
}

function restart () {
	sudo brew services restart ${1}
}
