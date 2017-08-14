#! /bin/bash

cleanUp() {
    rm -rf ~/bitbar
    mkdir  ~/bitbar
}

insertSheBang() {
    nodePath=$(which node)
    echo "#! /usr/bin/env $nodePath" | cat - "$1" > temp && mv -f temp "$1"
}

installPlugin() {
    outputName="$1.$2.js"
    webpack "plugins/$1" "$outputName" --config webpack.config.js --optimize-minimize
    insertSheBang "$outputName"
    sudo chmod +x "$outputName"
    mv -f "$outputName" ~/bitbar
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

git submodule init
git submodule update --remote 
git submodule foreach yarn

if [[ -z $JENKINS_USERNAME ]]; then
    echo "You need to set JENKINS_USERNAME"
    exit 1
fi

if [[ -z $JENKINS_PASSWORD ]]; then
    echo "You need to set JENKINS_PASSWORD"
    exit 1
fi

cleanUp
set -ex
installPlugin "jenkinsStatus" "15s"
installPlugin "serverJump" "10m"
installBitBar
