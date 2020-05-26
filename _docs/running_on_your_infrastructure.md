---
title: Using Docker Compose
tags: []
author: whiteblock
permalink: /my_infra

## Google Cloud Platform

### Getting Started
We assume here that you already have registered with GCP and have the gcloud tool installed and setup on your computer. If you do not have it setup, [here](https://cloud.google.com/functions/docs/quickstart) is the quick start guide.

### Importing the base image
The first step in having Genesis deploy to your infrastructure, is to have import the image into compute.
The gcloud tool makes this super easy! Just run the command `gcloud compute images import wb-biome --os=ubuntu-1804 --source-file=gs://assets.whiteblock.io/images/biome.qcow2` and it will import our image as an image named "wb-biome". You can name it whatever you want, but take note of what you name it for the next step.

### Configuring the CLI
Run the command `genesis cloud` to start the cli wizard which will guide you through the setup.
It will first ask you which provide you wish to use, in this case, that would be gcp.
It will then prompt you if you want to use an access-token from the gcloud command. This is the convient way to authenticate the genesis cli with gcp, as it simply uses the existing auth. If you want to use a service account's json credentials, then enter N, and put the path to the account's json credentials in the next prompt. You can also leave this one empty if you wish for the [default application credentials](https://cloud.google.com/sdk/gcloud/reference/auth/application-default) to be used. 
It will then ask you for the zone to build in, the image name (what you called it above, if you just copy & pasted the command, this will be wb-biome), and finally the project. Please note that the image must exist in the given project in order for a successful build to happen.

### Service Account Permissions

* Compute Instance Admin (v1)

## AWS
Coming soon!