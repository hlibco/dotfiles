#!/usr/bin/env bash
#
# common script functions and variables

set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

echo ''

info() {
  # shellcheck disable=SC2059
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
  # shellcheck disable=SC2059
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
  # shellcheck disable=SC2059
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
  # shellcheck disable=SC2059
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

run() {
  set +e
  info "$1"
  output=$($2 2>&1)
  if [ $? -ne 0 ]; then
    fail "failed to run '$1': $output"
    exit
  fi
  set -e
}

dotfiles_find() {
    find -L "$DOTFILES_ROOT" -maxdepth 3 -name "$1" -not -path "*.git*"
}