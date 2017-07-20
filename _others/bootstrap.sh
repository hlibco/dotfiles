#!/usr/bin/env bash
#
# bootstrap dotfiles

set -e # exit the script if any statement returns a non-true return value
# set -x

source setup/common.sh

setup_gitconfig() {
	info 'setup gitconfig'
	# if there is no user.email, we'll assume it's a new machine/setup and ask it
	if [ -z "$(git config --global --get user.email)" ]; then
		user ' - What is your github author name?'
		read -r user_name
		user ' - What is your github author email?'
		read -r user_email

		git config --global user.name "$user_name"
		git config --global user.email "$user_email"
	elif [ "$(git config --global --get dotfiles.managed)" != "true" ]; then
		# if user.email exists, let's check for dotfiles.managed config. If it is
		# not true, we'll backup the gitconfig file and set previous user.email and
		# user.name in the new one
		user_name="$(git config --global --get user.name)"
		user_email="$(git config --global --get user.email)"
		mv ~/.gitconfig ~/.gitconfig.backup
		success "moved ~/.gitconfig to ~/.gitconfig.backup"
		git config --global user.name "$user_name"
		git config --global user.email "$user_email"
	else
		# otherwise this gitconfig was already made by the dotfiles
		info "already managed by dotfiles"
	fi
	# include the gitconfig.local file
	git config --global include.path ~/.gitconfig.local
	# finally make git knows this is a managed config already, preventing later
	# overrides by this script
	git config --global dotfiles.managed true
	success 'gitconfig'
}

link_files () {
  case "$1" in
    link )
      link_file $2 $3
      ;;
    copy )
      copy_file $2 $3
      ;;
    git )
      git_clone $2 $3
      ;;
    * )
      fail "Unknown link type: $1"
      ;;
  esac
}

link_file () {
  ln -s $1 $2
  success "linked $1 to $2"
}

copy_file () {
  cp $1 $2
  success "copied $1 to $2"
}

open_file () {
  run "opening $1" "open $1"
  success "opened $1"
}

install_dotfiles () {
  info 'installing dotfiles'
  overwrite_all=false
  backup_all=false
  skip_all=false

  # symlinks
  for file_source in $(dotfiles_find \*.symlink); do
    file_dest="$HOME/.`basename \"${file_source%.*}\"`"
    install_file link $file_source $file_dest
  done

  # git repositories
  for file_source in $(dotfiles_find \*.gitrepo); do
    file_dest="$HOME/.`basename \"${file_source%.*}\"`"
    install_file git $file_source $file_dest
  done

  # preferences
  for file_source in $(dotfiles_find \*.plist); do
    file_dest="$HOME/Library/Preferences/`basename $file_source`"
    install_file copy $file_source $file_dest
  done

  # fonts
  for file_source in $(dotfiles_find \*.otf -or -name \*.ttf -or -name \*.ttc); do
    file_dest="$HOME/Library/Fonts/$(basename $file_source)"
    install_file copy $file_source $file_dest
  done
}

install_file () {
  file_type=$1
  file_source=$2
  file_dest=$3
  if [ -f $file_dest ] || [ -d $file_dest ]; then
    overwrite=false
    backup=false
    skip=false

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
      user "File already exists: `basename $file_dest`, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
      read -n 1 action

      case "$action" in
        o )
          overwrite=true;;
        O )
          overwrite_all=true;;
        b )
          backup=true;;
        B )
          backup_all=true;;
        s )
          skip=true;;
        S )
          skip_all=true;;
        * )
          ;;
      esac
    fi

    if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]; then
      rm -rf $file_dest
      success "removed $file_dest"
    fi

    if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]; then
      mv $file_dest $file_dest\.backup
      success "moved $file_dest to $file_dest.backup"
    fi

    if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]; then
      link_files $file_type $file_source $file_dest
    else
      success "skipped $file_source"
    fi

  else
    link_files $file_type $file_source $file_dest
  fi
}

run_installers () {
  info 'running installers'
  find -L . -name install.sh | while read installer ; do run "running ${installer}" "${installer}" ; done

  info 'opening files'
  OLD_IFS=$IFS
  IFS=''
  for file_source in $(dotfiles_find install.open); do
    for file in `cat $file_source`; do
      expanded_file=$(eval echo $file)
      open_file $expanded_file
    done
  done
  IFS=$OLD_IFS
}

brew_install () {
  formula=$1
  if ! brew $2 ls --versions $formula 2> /dev/null | grep -q $formula; then
    if brew $2 install $formula > /dev/null 2>&1; then
      success "installed $formula"
    else
      fail "failed to install $formula"
    fi
  fi
}

install_formulas () {
  # assume that the installer did it's job, and use the default path for brew if it's not there already
  # if ! test $(which brew); then
  #   source $DOTFILES_ROOT/brew/path.zsh
  # fi

  for file in `dotfiles_find install.homebrew`; do
    for formula in `cat $file`; do
      brew_install $formula
    done
  done

  for file in `dotfiles_find install.homebrew-cask`; do
    for formula in `cat $file`; do
      brew_install $formula cask
    done
  done
}


create_localrc () {
  LOCALRC=$HOME/.localrc
  if [ ! -f "$LOCALRC" ]; then
    echo "DEFAULT_USER=$USER" > $LOCALRC
    success "created $LOCALRC"
  fi
}

pull_repos () {
  for file in $(dotfiles_find \*.gitrepo); do
    repo="$HOME/.`basename \"${file%.*}\"`"
    pushd $repo > /dev/null
    if ! git pull --rebase --quiet origin master; then
      fail "could not update $repo"
    fi
    success "updated $repo"
    popd >> /dev/null
  done
}

brew_upgrade () {
  run 'updating homebrew' 'brew update'
  run 'upgrading homebrew' 'brew upgrade'
  run 'pruning homebrew' 'brew prune'
  run 'cleaning up homebrew' 'brew cleanup'

  for update in $(brew outdated); do
    formula=$(echo "$update" | cut -d ' ' -f 1)
    run "upgrading $update" "brew upgrade $formula"
  done
}




if [ "$1" = "update" ]; then
  info 'updating...'
  # pull_repos

  run_installers
  brew_upgrade
  install_formulas
  run 'cleaning up homebrew' 'brew cleanup'
  run 'cleaning up homebrew-cask' 'brew cask cleanup'
else
  info 'installing...'
  #install_dotfiles
  # setup_gitconfig

  # run_installers
  # install_formulas
  # create_localrc
fi


echo ''
info 'Done.'
echo ''


