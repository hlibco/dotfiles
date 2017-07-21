#!/bin/bash

# Add mariadb into services to launch on startup
mysql=`brew list | grep mariadb`
if [[ ! $mariadb ]]; then
    echo ''

    # setup mysql
    ln -sfv /usr/local/opt/mariadb/*.plist ~/Library/LaunchAgents
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mariadb.plist
fi