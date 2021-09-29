#!/bin/sh
# this file is used to deploy a mina node on a server running Docker

echo "Deploying Mina node to Docker"

# launch docker instance with logging exposed
sudo docker run --name mina -d \
-p 8302:8302 -p 8303:8303 \
--restart=always \
--mount "type=bind,source=`$HOME`/keys,dst=/keys,readonly" \
--mount "type=bind,source=`$HOME`/.mina-config,dst=/root/.mina-config" \
-e CODA_PRIVKEY_PASS="$1" \
gcr.io/o1labs-192920/mina-daemon-baked:1.1.8-b10c0e3-mainnet \
daemon \
--block-producer-key /keys/my-wallet \
--insecure-rest-server \
--file-log-level Debug \
--log-level Info \
--peer-list-url https://storage.googleapis.com/mina-seed-lists/mainnet_seeds.txt \
--metrics-port 8303

echo "Mina protocol deployed on port 8302"
echo "Mina logging deployed on port 8303"