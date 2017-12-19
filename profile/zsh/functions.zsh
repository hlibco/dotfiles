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
function asapp() { sudo su app -c "$*" }

# Process status (usage: status php-fpm)
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

# Get password for a given SSID
function wifipassword() {
  security find-generic-password -D "AirPort network password" -a ${@} -g
}

# Add "&& finished" after a long running script to send OSX notification when complete, e.g.:
#
#     somelongrunningscript && finished
#
function finished {
  osascript -e 'display notification "Enjoy!" with title "The thing is done"'
}

################
#   Docker
################

# Get docker container ip
# Use: docker-ip [container_id]
function docker-ip() {
	docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
}

function docker-container-image() {
    docker inspect $1 | jq -r '.[0].Image' | cut -d: -f2
}

function docker-nuke-container-image() {
    for container in $(docker ps -a | grep $1 | awk 'NF>1{print $NF}'); do
        docker-container-image ${container}
    done | sort | uniq | xargs docker rmi -f
}

function docker-killall() {
    docker kill $(docker ps -q)
}

function docker-rm-all() {
    docker rm -f $(docker ps -a -q)
}

function docker-rmi-all() {
    docker rmi -f $(docker images -q)
}

function docker-cleanup-space() {
    docker system prune -a
}
