#!/bin/sh

set -e

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )"

if test "$(which code)"; then
	if [ "$(uname -s)" = "Darwin" ]; then
		VSCODE_HOME="$HOME/Library/Application Support/Code"
	else
		VSCODE_HOME="$HOME/.config/Code"
	fi

	ln -sf "$DOTFILES/config/vscode/settings.json" "$VSCODE_HOME/User/settings.json"
  ln -sf "$DOTFILES/config/vscode/snippets/javascript.json" "$VSCODE_HOME/User/snippets/javascript.json"
	# ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_HOME/User/keybindings.json"

	# Get a list of extensions: `code --list-extensions`
	modules="
    Alan.stylus
    DSKWRK.vscode-generate-getter-setter
    EditorConfig.EditorConfig
    HookyQR.ExtensionUpdateCheck
    HookyQR.JSDocTagComplete
    kumar-harsh.graphql
    LaurentTreguier.vscode-simple-icons
    MattiasPernhult.vscode-todo
    PKief.material-icon-theme
    TwentyChung.jsx
    Tyriar.sort-lines
    akamud.vscode-theme-onedark
    alefragnani.Bookmarks
    bradgashler.htmltagwrap
    chenxsan.vscode-standardjs
    christian-kohler.npm-intellisense
    christian-kohler.path-intellisense
    dbaeumer.vscode-eslint
    deerawan.vscode-dash
    donjayamanne.githistory
    dzannotti.vscode-babel-coloring
    eg2.tslint
    emmanuelbeziat.vscode-great-icons
    file-icons.file-icons
    formulahendry.auto-rename-tag
    formulahendry.code-runner
    joelday.docthis
    mattyjones.vscode-tickscript
    mauve.terraform
    mindginative.terraform-snippets
    ms-vscode.Theme-MaterialKit
    msjsdiag.debugger-for-chrome
    ow.vscode-subword-navigation
    pprice.better-merge
    robertohuertasm.vscode-icons
    shardulm94.trailing-spaces
    shyykoserhiy.vscode-spotify
    spywhere.guides
    stevencl.addDocComments
    sysoev.language-stylus
    vector-of-bool.gitflow
    xabikos.JavaScriptSnippets
    WallabyJs.wallaby-vscode
    wmaurer.html2jade
    wmaurer.join-lines
    wholroyd.jinja
  "

  for module in $modules; do
    echo 1
  	# code --install-extension "$module" || true
  done
fi
