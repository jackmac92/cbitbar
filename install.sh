#! /bin/bash

export BITBAR_PLUGIN_DIR="$HOME/bitbar"

cleanUp() {
    [ -d ~/bitbar ] && rm -rf ~/bitbar
    mkdir  ~/bitbar
}

if [[ -z $JENKINS_USERNAME ]]; then
    echo "You need to set JENKINS_USERNAME"
    exit 1
fi

if [[ -z $JENKINS_PASSWORD ]]; then
    echo "You need to set JENKINS_PASSWORD"
    exit 1
fi

if [[ -z $JIRA_USERNAME ]]; then
    echo "You need to set JIRA_USERNAME"
    exit 1
fi

if [[ -z $JIRA_PASSWORD ]]; then
    echo "You need to set JIRA_PASSWORD"
    exit 1
fi

if [[ -z $CRUCIBLE_USERNAME ]]; then
    echo "You need to set CRUCIBLE_USERNAME"
    exit 1
fi

if [[ -z $CRUCIBLE_PASSWORD ]]; then
    echo "You need to set CRUCIBLE_PASSWORD"
    exit 1
fi

cleanUp
which yarn || npm i -g yarn
which nestor || npm i -g nestor
yarn install
set -ex

git submodule init
git submodule update --remote
git submodule foreach "git checkout master && git pull && yarn run bitBuild"

if ! [[ -f bitbar.zip ]]; then
    node installBitBar.js
    unzip bitbar.zip
    mv BitBar.app /Applications/BitBar.app
fi
defaults write com.matryer.BitBar pluginsDirectory "$HOME/bitbar"
defaults write com.matryer.BitBar appHasRun -bool false
defaults write com.matryer.BitBar userConfigDisabled -bool false

open -a BitBar
