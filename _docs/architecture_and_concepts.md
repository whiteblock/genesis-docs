---
title: Architecture And Concepts
tags: []
author: whiteblock
permalink: /architecture
---


## General Overview
Genesis works by building a fresh, reproducible environment on cloud infrastructure. When you run a test, Genesis tells the cloud provider to create the VMs to provide the infrastructure for the Biome. It then configures those VMs and distributes the services among them as specified in the YAML test file.


## The Biome

The biome is the environment in which a Whiteblock test is run in, it consists of one or more VMs, and all of the containers in the network. Every test runs in it's own Biome, which is provisioned by Genesis. While the services are spread over an arbitrary number of machines, this is abstracted away by the Genesis platform. Allowing for a uniform environment for test execution.

![Biome Overview](/assets/img/biome.png)

## Networking
There are two types of networks. There are the primary system component networks, and there are the sidecar networks. Sidecar networks consist of a single service and all of the sidecars for that service. For this example, let's assume that you have a service type "serv" with sidecar "side", and a system declared as:
```yaml
system:
- type: serv
  count: 2
  resources:
    networks:
    - name: network1
- type: other-serv
  resources:
    networks:
    - name: network1
```
Then your network setup would look like the following for the services:
![service network](/assets/img/service_network.png)

And for the sidecar networks, you would have:
![sidecar network](/assets/img/sidecar_network.png)

It is important to note that sidecars cannot communicate with another service's sidecars nor can they communicate with any other sidecar. They are effectively isolated from the rest of the network. If you wish for this connectivity, then you should use a service instead of a sidecar. 

## Logging w/ Splunk
We use syslog-ng to aggregate the logs on each VM from all of the containners (task-runners, sidecars, and services). Once aggregated, these logs are then forwarded to the log collector you have setup in your settings. You can use other log collectors, as long as they support the syslog_message format and can process json lines from that. However, for the best experience, we suggest using [Splunk](https://www.splunk.com).

![log collection](/assets/img/log_collection.png)