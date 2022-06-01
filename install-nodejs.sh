#!/usr/bin/env bash

# specify nodejs version
CPU_VERSION="armv7l"
NODE_VERSION="14.19.3"

# initiate folder
sudo mkdir -p /opt/nodejs
sudo chmod -R 777 /opt/nodejs
cd /opt/nodejs

# download & extract nodejs
wget https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$CPU_VERSION.tar.xz
tar -xJf node-v$NODE_VERSION-linux-$CPU_VERSION.tar.xz

# make executable link
sudo ln -s /opt/nodejs/node-v$NODE_VERSION-linux-$CPU_VERSION/bin/node /usr/local/bin/node
sudo ln -s /opt/nodejs/node-v$NODE_VERSION-linux-$CPU_VERSION/bin/npm /usr/local/bin/npm
sudo ln -s /opt/nodejs/node-v$NODE_VERSION-linux-$CPU_VERSION/bin/npx /usr/local/bin/npx

# cleanup
sudo rm node-v$NODE_VERSION-linux-$CPU_VERSION.tar.xz
