#!/usr/bin/env bash

# Install all global dependencies
npm which
npm -v

# Test packages
# npm i -g ava nyc snazzy tape faucet standard tslint retire

# Process management
npm i -g nodemon pm2

# Others
npm i -g commitizen plop tsd surge
