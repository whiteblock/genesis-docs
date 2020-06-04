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

## AWS

AWS support is coming soon

### Getting Started
We assume that you already have the AWS CLI properly setup. If you do not have the AWS cli setup, you can follow [these instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) to get started.

## Diagnosing Build Issues

### Debug Mode
The default behavior for Genesis is to immediately teardown all involved instances once a test has reached an error state. You can add the flag `--debug-mode` to your genesis run command to tell it to avoid tearing down your instance. 