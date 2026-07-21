#!/usr/bin/env node
const https = require('https');
const fs = require('fs');
const path = require('path');

const UPSTREAM_VERSION = require('./package.json').version;
const ASSET = 'opencode-linux-arm64-musl.tar.gz';
const URL = `https://github.com/sst/opencode/releases/download/v${UPSTREAM_VERSION}/${ASSET}`;
const OUT = path.join(__dirname, 'opencode-termux-aarch64.tar.gz');

function download(url, dest, redirects = 5) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      if ([301, 302, 307, 308].includes(res.statusCode)) {
        res.resume();
        if (redirects === 0) return reject(new Error('Too many redirects'));
        return resolve(download(res.headers.location, dest, redirects - 1));
      }
      if (res.statusCode !== 200) {
        res.resume();
        return reject(new Error(`Download failed: HTTP ${res.statusCode} for ${url}`));
      }
      const file = fs.createWriteStream(dest);
      res.pipe(file);
      file.on('finish', () => file.close(resolve));
      file.on('error', reject);
    }).on('error', reject);
  });
}

console.log(`Fetching opencode v${UPSTREAM_VERSION} (linux-arm64-musl) from upstream...`);
download(URL, OUT)
  .then(() => {
    console.log('✓ Archive created:', OUT);
    console.log('File size:', (fs.statSync(OUT).size / 1024 / 1024).toFixed(2), 'MB');
  })
  .catch((err) => {
    console.error('Error:', err.message);
    if (fs.existsSync(OUT)) fs.unlinkSync(OUT);
    process.exit(1);
  });
