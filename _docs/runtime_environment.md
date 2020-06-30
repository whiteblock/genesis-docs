---
title: Getting to know the runtime environment
tags: []
author: whiteblock
permalink: /runtime_environment
---

## CPUs
When running on the Whiteblock platform in GCP, the provisioned VMs will be using "Intel Skylake" or newer generation CPU cores. For more details on the performance of these CPUs and how it may impact your results, we suggest either contacting our support team via support@whiteblock.io or contacting the cloud provider directly. Each sidecar, service, or task runner can use up to 90 cores each. 

## Memory
Each service, sidecar, or taskrunner has a RAM cap of 600GB. If you need to use more RAM than this per service, please contact us. We have additional options up to 3.7TB availible, which aren't shown by default. 

### Swap
In our environment, the swappiness is set to 0 as this is what most people want. However, we do plan on exposing swappiness as a setting to the user.

## Storage
Each service, sidecar, or taskrunner can have a maximum of 2,800GiB of storage. Our storage consists of many NVMe SSDs of size 375GB, which are setup in RAID 0. 