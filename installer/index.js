const shell = require('shelljs');

const exec = cmd =>
  new Promise((resolve, reject) =>
    shell.exec(
      cmd,
      { silent: true },
      (code, out, err) => (code === 0 ? resolve(out) : reject(err))
    )
  );

const insertSheBang = filePath => {
  exec('which node').then(nodePath =>
    exec(
      `echo "#! /usr/bin/env ${nodePath}" | cat - "${filePath}" > temp && mv -f temp "${filePath}"`
    )
  );
};

const installMonitor = () => {
  // yarn
  // webpack plugins/jenkinsStatus bitbar.20s.js --config webpack.config.js --optimize-minimize
  insertSheBang('bitbar.20s.js');
  exec('mv -f bitbar.20s.js ~/bitbar');
  exec('sudo chmod +x ~/bitbar/bitbar.20s.js');
};

const installBitBar = () => {
  // [[ -d /Applications/BitBar.app ]] && rm -rf /Applications/BitBar.app
  // node installBitBar.js
  // unzip ./bitbar.zip
  // mv ./BitBar.app /Applications/BitBar.app
  // defaults write com.matryer.BitBar pluginsDirectory "$HOME/bitbar"
  // defaults write com.matryer.BitBar appHasRun -bool false
  // defaults write com.matryer.BitBar userConfigDisabled -bool false
  // open -a BitBar
};

// installMonitor
// installBitBar
