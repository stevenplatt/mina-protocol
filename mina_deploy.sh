#!/bin/sh
# this file is used to deploy a mina node on a server running Docker

# check that docker is installed
if ![ -x "$(command -v docker)" ]; then
    echo "Error: Docker is not currently installed"
    else
        echo "Deploying Mina node within Docker..."
fi

# deploy the mina docker image
if [ "$1" == "logging" ]; then
    # launch docker instance with logging exposed
    sudo docker run --name mina -d \
    -p 8302:8302 -p 8303:8303 \
    --restart=always \
    --mount "type=bind,source=`pwd`/keys,dst=/keys,readonly" \
    --mount "type=bind,source=`pwd`/.mina-config,dst=/root/.mina-config" \
    -e CODA_PRIVKEY_PASS="YitboS1899!" \
    gcr.io/o1labs-192920/mina-daemon-baked:1.1.8-b10c0e3-mainnet \
    daemon \
    --block-producer-key /keys/my-wallet \
    --insecure-rest-server \
    --file-log-level Debug \
    --log-level Info \
    --peer-list-url https://storage.googleapis.com/mina-seed-lists/mainnet_seeds.txt \
    --metrics-port 8303

    else
    # launch docker instance with no logging
        sudo docker run --name mina -d \
        -p 8302:8302 \
        --restart=always \
        --mount "type=bind,source=`pwd`/keys,dst=/keys,readonly" \
        --mount "type=bind,source=`pwd`/.mina-config,dst=/root/.mina-config" \
        -e CODA_PRIVKEY_PASS="YitboS1899!" \
        gcr.io/o1labs-192920/mina-daemon-baked:1.1.8-b10c0e3-mainnet \
        daemon \
        --block-producer-key /keys/my-wallet \
        --insecure-rest-server \
        --file-log-level Debug \
        --log-level Info \
        --peer-list-url https://storage.googleapis.com/mina-seed-lists/mainnet_seeds.txt
fi

echo "Mina node deployed successfully"