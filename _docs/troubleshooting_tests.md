---
title: Troubleshooting Guide
tags: []
author: whiteblock
permalink: /troubleshooting
---

## Local Execution
You are able to run tests locally using the command: `genesis local <file>`, this allows for fast iteration when developing your test. All users all allowed unlimited local builds. However, it is worth noting that local builds are not useful outside of debugging.

### Cleanup
You can cleanup whatever was built last with the `genesis local...` command by using the command `genesis local teardown`

### Limitations
There are various limitations to local execution. 

#### Resources
You are limited to the resources of your local machine. This should be kept in mind as larger tests may not be able to execute locally. We suggest lowering the node count when running locally, 

#### Port mappings
Since you are bound to single machine, it is important to be aware of potential port mapping conflicts. If you request 2 containers with the same host port request, the test will not be able to deploy

#### Connecting to docker
Ensure that the user you are running as has access to the docker daemon. A easy way to check this is to see if you can run `docker ps` as the user. 

#### Disabled Features
* Prefabs are ignored in the local execution
* Logging preferences established using `genesis settings` have no impact on local deployments
* Network emulation is ignored for local environments.
* Deploying over multiple machines
* Some DSL functions may be disabled, such as `$_host`.
