#!/bin/sh

set -e
set -x

if test ! $(which brew); then
  info 'install homebrew'
  sudo chown $(whoami) '/usr/local' '/usr/local/Caskroom' "${HOME}/Library/Caches/Homebrew/"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /tmp/homebrew-install.log

  run 'tap caskroom/versions' 'brew tap caskroom/versions'
  run 'tap homebrew/versions' 'brew tap homebrew/versions'
  run 'tap homebrew/bundle' 'brew tap homebrew/bundle'
fi

brew doctor

# brews=(
#   # Infrastructure
#   ansible
#   awscli
#   terraform

#   # Linux
#   tree
#   wget

#   # Others
#   hugo # Static website generator https://gohugo.io
#   node
#   nodenv
#   openssl
#   yarn
# )

# prompt "Install brew packages"
# brew info ${brews[@]}
# install 'brew install' ${brews[@]}



# casks=(
#   # Databases
#   postgres
#   robomongo
#   sequel-pro

#   # Others
#   atom
#   docker

# )

# npms=(
#   commitizen
#   plop
#   pm2
#   surge
#   tsd
# )

# # List installed extensions: code --list-extensions
# vscode=(
#   # Alan.stylus
#   # DSKWRK.vscode-generate-getter-setter
#   # EditorConfig.EditorConfig
#   # HookyQR.ExtensionUpdateCheck
#   # HookyQR.JSDocTagComplete
#   # LaurentTreguier.vscode-simple-icons
#   # MattiasPernhult.vscode-todo
#   # PKief.material-icon-theme
#   # TwentyChung.jsx
#   # Tyriar.sort-lines
#   # akamud.vscode-theme-onedark
#   # alefragnani.Bookmarks
#   # bradgashler.htmltagwrap
#   # chenxsan.vscode-standardjs
#   # christian-kohler.npm-intellisense
#   # christian-kohler.path-intellisense
#   # dbaeumer.vscode-eslint
#   # donjayamanne.githistory
#   # dzannotti.vscode-babel-coloring
#   # eg2.tslint
#   # emmanuelbeziat.vscode-great-icons
#   # file-icons.file-icons
#   # formulahendry.auto-rename-tag
#   # formulahendry.code-runner
#   # mattyjones.vscode-tickscript
#   # mauve.terraform
#   # mindginative.terraform-snippets
#   # ms-vscode.Theme-MaterialKit
#   # msjsdiag.debugger-for-chrome
#   # ow.vscode-subword-navigation
#   # pprice.better-merge
#   # robertohuertasm.vscode-icons
#   # shardulm94.trailing-spaces
#   # shyykoserhiy.vscode-spotify
#   # spywhere.guides
#   # stevencl.addDocComments
#   # sysoev.language-stylus
#   # vector-of-bool.gitflow
#   # wmaurer.html2jade
#   # wmaurer.join-lines
# )

# prompt "Install software"
# brew tap caskroom/versions
# brew tap caskroom/cask
# brew cask info ${casks[@]}
# install 'brew cask install' ${casks[@]}


# prompt "Installing secondary packages"
# install 'npm install --global' ${npms[@]}

# if test "$(which code)"; then
#   if [ "$(uname -s)" = "Darwin" ]; then
#     VSCODE_HOME="$HOME/Library/Application Support/Code"
#   else
#     VSCODE_HOME="$HOME/.config/Code"
#   fi

#   ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_HOME/User/settings.json"
#   # ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_HOME/User/keybindings.json"

#   install 'code --install-extension' ${vscode[@]}
# fi 

# brew tap caskroom/fonts
# # install 'brew cask install' ${fonts[@]}
