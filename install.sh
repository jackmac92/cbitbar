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
    cd "plugins/$1"
    npm run build
    cd ../..
    mv "plugins/$1/bundle.js" "$outputName"
    if [[ -z "$3" ]]; then
        echo "Skipping JS modifications"
    else
        insertSheBang "$outputName"
        sudo chmod +x "$outputName"
    fi
    mv -f "$outputName" ~/bitbar
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

npm install
which yarn || npm i -g yarn

git submodule init
git submodule foreach "git checkout master && git pull"
git submodule foreach "yarn"

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
installPlugin "jenkinsStatus" "15s" 1
installPlugin "serverJump" "10m" 1
installPlugin "jira" "30m"
installBitBar
