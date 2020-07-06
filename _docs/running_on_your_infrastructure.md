---
title: Running on external infrastructure
tags: []
author: whiteblock
permalink: /my_infra
---

## Google Cloud Platform

### Getting Started
We assume here that you already have registered with GCP and have the gcloud tool installed and setup on your computer. If you do not have it setup, [here](https://cloud.google.com/functions/docs/quickstart) is the quick start guide.

### Importing the base image
The first step in having Genesis deploy to your infrastructure, is to have import the image into compute.
The gcloud tool makes this super easy! Just run the command `gcloud compute images import wb-biome --os=ubuntu-1804 --source-file=gs://assets.whiteblock.io/images/biome.qcow2` and it will import our image as an image named "wb-biome". You can name it whatever you want, but take note of what you name it for the next step.

### Configuring the Network/Firewall
First, let's create the compute network, this command may take a couple minutes to complete.
`gcloud compute networks create whiteblock`
Note: Only use this network for Whiteblock Genesis biomes, these configuration options turn off firewall protection for the network we just created. 
To expose everything on the newly created whiteblock network, run the command:
`gcloud compute firewall-rules create whiteblock-open --network whiteblock --allow tcp,udp,icmp --source-ranges 0.0.0.0/0`
This gives you the greatest ability to interact with the network, without this you wouldn't be able to arbitrarily open ports and access them externally.

#### Genesis Secure Setup
If you are an enterprise tier client and have special needs for security or just want more security for your genesis test networks. Please contact support at support@whiteblock.io so we may work with you to ensure the strictest policies that function.

For non-enterprise tier clients, you can try using the command:
`gcloud compute firewall-rules create whiteblock-open --network whiteblock --allow tcp:22,tcp:2376 --source-ranges 0.0.0.0/0`
Those 2 ports are the bare minimum for Genesis to function, but keep in mind that certain functionality such as global volumes and port-mapping will no longer work. 

### Configuring the CLI
Run the command `genesis cloud` to start the cli wizard which will guide you through the setup.
It will first ask you which provide you wish to use, in this case, that would be gcp.
It will then prompt you if you want to use an access-token from the gcloud command. This is the convient way to authenticate the genesis cli with gcp, as it simply uses the existing auth. If you want to use a service account's json credentials, then enter N, and put the path to the account's json credentials in the next prompt. You can also leave this one empty if you wish for the [default application credentials](https://cloud.google.com/sdk/gcloud/reference/auth/application-default) to be used. 
It will then ask you for the zone to build in, the image name (what you called it above, if you just copy & pasted the command, this will be wb-biome), and finally the project. Please note that the image must exist in the given project in order for a successful build to happen.

### Service Account Permissions

* Compute Instance Admin (v1)

### CI/CD
You can set the genesis cli to deploy to your gcp environment using these environment variables. They are required unless marked as optional. Note, if you don't set GCP_USE_ACCESS_TOKEN or GCP_SERVICE_ACCOUNT_KEY, genesis will attempt to use [google cloud default credentials](https://cloud.google.com/docs/authentication/production). 

* GENESIS_PROVIDER : This needs to be set to "gcp" in order to use GCP
* GCP_USE_ACCESS_TOKEN: (optional) Set this if you would like to use the access token generated from the `gcloud auth print-access-token`
* GCP_SERVICE_ACCOUNT_KEY: (optional) Set this to the path to the service account key json file if you wish to authenticate using that service account details
* GCP_ZONE : The zone in the GCP to deploy to
* GCP_PROJECT : The project in GCP to deploy to
* GCP_IMAGE : The Genesis Biome image created in the setup.
* GCP_NETWORK : (Optional) The GCP network to run the instances inside. Defaults to the default network.
* GCP_SUBNETWORK: (Optional) The GCP sub-network to run the instances inside. Defaults to the default network.


## AWS

### Getting Started
Getting Started with AWS is super easy. 
Simply run the command `genesis cloud`, select the aws provider, and then simply provide answers to the guided setup.

### CI/CD
If you wish to configure AWS for your CI/CD platform, you can do so by setting these environment variables. 
* GENESIS_PROVIDER : This needs to be set to "aws" in order to use AWS
* AWS_REGION : The region in AWS to deploy to, for example us-east-2
* AWS_ACCESS_KEY_ID : Your AWS access key id
* AWS_SECRET_ACCESS_KEY : Your AWS secret access key

### Notice
AWS support is still considered experimental. There are many unstable features, and some features may not work in AWS. If you encounter any issues with the AWS implementation. 

