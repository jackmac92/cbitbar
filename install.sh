#! /bin/bash -exu

cleanUp() {
    rm -rf ~/bitbar
    mkdir  ~/bitbar
}

insertSheBang() {
    nodePath=$(which node)
    echo "#! /usr/bin/env $nodePath" | cat - "$1" > temp && mv -f temp "$1"
}

installMonitor() {
    yarn
    webpack plugins/jenkinsStatus bitbar.5m.js --config webpack.config.js --optimize-minimize
    insertSheBang bitbar.5m.js
    mv -f bitbar.5m.js ~/bitbar
    sudo chmod +x ~/bitbar/bitbar.5m.js
}

installBitBar() {
    if ! [[ -f bitbar.zip ]]; then
        node installBitBar.js
        unzip bitbar.zip
        mv BitBar.app /Applications/BitBar.app
    fi
    defaults write com.matryer.BitBar pluginsDirectory "$HOME/bitbar"
    defaults write com.matryer.BitBar appHasRun -bool false
    defaults write com.matryer.BitBar userConfigDisabled -bool false

    open -a BitBar
}

cleanUp
installMonitor
installBitBar
