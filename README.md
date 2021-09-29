# mina-protocol
Documentation for deploying a Mina blockchain node with logging within Docker. To be user-friendly, these instructions can be executed all on a single compute instance. All files are written with limit dependancies so that they can be adapted for users deploying a node within a lab, Kubernetes, or any cloud provider. 

The Mina Metrics Server at the end of these instructions is written in Python with 2.X compatibility, so that it does not require additional installations and can easily be bundled as part of the Mina node itself if desired. 

The Metrics Dashboard currently has minimal parsing applied (only enough to make logs easily readable, but could be updated with further processing if desired. 

## Table of Contents
[Prerequisites (Task 1)](#pre-req)

[Launch Mina Docker Node (Task 1)](#no-logging)  

[Launch Mina Docker Node With Active Logging (Task 2)](#logging)

[Viewing Mina Metrics (Task 2)](#metrics)

<a name="pre-req"/>

## Prerequisites
All instructions assume an OS base of Ubuntu 18.04 LTS. This is required due to Python 2.X dependancies existing in the Mina container. 

### Docker Installation
If you are not already using a hosted container platform. You can install Docker to your compute instance running Ubuntu 18.04 using the ```docker_install.sh``` shell script. The shell script should not be run using sudo directly. 

```
> git clone https://github.com/stevenplatt/mina-protocol.git
> bash mina-protocol/docker_install.sh
```

### Create a Mina Private/Public Key

Mina requires a Private/Public key-pair to interact on the network. The ```mina_keygen.sh``` shell script will create the required keys and folder on your host computer instance. These folders are later mounted to the docker instance when it is launched. The shell script should not be run using sudo directly.

```
> bash mina-protocol/mina_keygen.sh
```

### Install Python modules for the Mina Metrics Server

Because the metrics webpage is deployed with Python Flask, additional dependancies must be installed. 

```
> sudo apt install -y python python-pip
> pip install flask prometheus_client requests argparse
```

<a name="no-logging"/>

# Deploy Mina within Docker

With prerequisites installed a new mina node can be launched using the Docker command below. Note that ```[YOUR_PRIVATE_KEY]``` will need to be updated with the private key/password used with the ```mina_keygen.sh``` tools earlier. 


```bash
sudo docker run --name mina -d \
-p 8302:8302 \
--restart=always \
--mount "type=bind,source=`pwd`/keys,dst=/keys,readonly" \
--mount "type=bind,source=`pwd`/.mina-config,dst=/root/.mina-config" \
-e CODA_PRIVKEY_PASS="[YOUR_PRIVATE_KEY]" \
gcr.io/o1labs-192920/mina-daemon-baked:1.1.8-b10c0e3-mainnet \
daemon \
--block-producer-key /keys/my-wallet \
--insecure-rest-server \
--file-log-level Debug \
--log-level Info \
--peer-list-url https://storage.googleapis.com/mina-seed-lists/mainnet_seeds.txt \
```

After waiting a few moments to sync, you can check the status of your node with ```docker exec -it mina mina client status```, the output should diplay as shown below: 

![Metric Dash](https://github.com/stevenplatt/mina-protocol/blob/main/img/mina_status_with_logging.png?raw=true)

<a name="logging"/>

# Deploy a Mina docker instance with logging exposed

Similar to the deployment in the last step, Mina can be deployed with Prometheus metrics exposed. To do this, an additional port is exposed for the metrics interface (```-p 8302:8302``` becomes ```-p 8302:8302 -p 8303:8303```) and an extra argument is passed to declare the chosen port number (```--metrics-port 8303```). After a period of initial syncing, using the ```docker exec -it mina mina client status``` command will return a similar output to the example above.


```bash
sudo docker run --name mina -d \
-p 8302:8302 -p 8303:8303 \
--restart=always \
--mount "type=bind,source=`pwd`/keys,dst=/keys,readonly" \
--mount "type=bind,source=`pwd`/.mina-config,dst=/root/.mina-config" \
-e CODA_PRIVKEY_PASS="[YOUR_PRIVATE_KEY]" \
gcr.io/o1labs-192920/mina-daemon-baked:1.1.8-b10c0e3-mainnet \
daemon \
--block-producer-key /keys/my-wallet \
--insecure-rest-server \
--file-log-level Debug \
--log-level Info \
--peer-list-url https://storage.googleapis.com/mina-seed-lists/mainnet_seeds.txt \
--metrics-port 8303
```

<a name="metrics"/>

# Display Mina Metrics over HTTP

Metrics output from the Mina node can be displayed in the browser using the ```mina_metrics.py``` script. This script launches a Python flask server and present a basic parsing of the Mina Prometheus logs in human readable format. The script must be run with an additional argument to specify the Mina Prometheus port that was defined with the Docker command above, for example ```python mina_metrics.py http://127.0.0.1:8303/metrics```. This script can be run on the same compute instance that runs the Mina docker container, or from another location. 

```python
> python mina-protocol/mina_metrics.py [URL_TARGET]
```

The log dashboard can be reach at ```http://[IP]:8304``` and will display as shown below: 

![Metric Dash](https://github.com/stevenplatt/mina-protocol/blob/main/img/mina_metrics_dash.png?raw=true)

