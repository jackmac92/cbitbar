#! /bin/bash -exu

cleanUp() {
    rm -rf ~/bitbar
    mkdir  ~/bitbar
}

insertSheBang() {
    nodePath=$(which node)
    echo "#! /usr/bin/env $nodePath" | cat - "$1" > temp && mv -f temp "$1"
}

installSSH() {
    webpack plugins/serverJump serverjump.5m.js --config webpack.config.js --optimize-minimize
    insertSheBang serverjump.5m.js
    mv -f serverjump.5m.js ~/bitbar
    sudo chmod +x ~/bitbar/serverjump.5m.js
}
installMonitor() {
    yarn
    webpack plugins/jenkinsStatus bitbar.20s.js --config webpack.config.js --optimize-minimize
    insertSheBang bitbar.20s.js
    mv -f bitbar.20s.js ~/bitbar
    sudo chmod +x ~/bitbar/bitbar.20s.js
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

git pull --recurse-submodules
git submodule foreach yarn

which rollup || npm i -g rollup
which webpack || npm i -g webpack
which yarn || npm i -g yarn

cleanUp
installSSH
installBitBar
