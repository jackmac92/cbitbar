const shell = require('shelljs');
const fs = require('fs');
const path = require('path');

const listFolders = folder =>
  fs
    .readdirSync(folder)
    .filter(
      item =>
        item.endsWith('.') || !fs.lstatSync(path.join(folder, item)).isFile()
    );

const exec = cmd =>
  new Promise((resolve, reject) =>
    shell.exec(cmd, code => (code === 0 ? resolve() : reject()))
  );

listFolders('./plugins').map(plugin => {
  console.log(plugin);
  shell.cd(`./plugins/${plugin}`);
  exec('rollup -c').then(() =>
    exec(`cp bundle.js ~/bitbar/plugins/${plugin}.1m.js`)
  );
});
