const axios = require('axios');
const shell = require('shelljs');
const fs = require('fs');
const Listr = require('listr');

const exec = cmd =>
  new Promise((resolve, reject) =>
    shell.exec(cmd, code => (code === 0 ? resolve() : reject()))
  );

const getRepoInfo = repo =>
  axios.get(`https://api.github.com/repos/${repo}/releases/latest`);

const findAssetUrl = ({ data: allAssets }) =>
  allAssets.filter(a => !a.name.includes('Distro'))[0].browser_download_url;

const downloadZip = url =>
  axios({ url, method: 'get', responseType: 'stream' }).then(response =>
    response.data.pipe(fs.createWriteStream('./bitbar.zip'))
  );

const task = new Listr([
  {
    title: 'Getting information about releases',
    task: ctx =>
      getRepoInfo('matryer/bitbar').then(res => {
        ctx.assetsUrl = res.data.assets_url;
      })
  },
  {
    title: 'Finding url download latest release',
    task: ctx =>
      axios.get(ctx.assetsUrl).then(findAssetUrl).then(url => {
        ctx.downloadUrl = url;
      })
  },
  {
    title: 'Downloading',
    task: ctx => downloadZip(ctx.downloadUrl).then(console.log)
  }
  // {
  //   title: 'Unzipping',
  //   task: ctx =>
  //     exec('unzip ./output/bitbar.zip').then(console.log).catch(console.log)
  // }
]);
module.exports = task;
if (require.main === module) {
  task.run().catch(err => {
    console.log(err);
  });
}
