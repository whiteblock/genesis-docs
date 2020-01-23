---
title: Using Docker Compose
tags: []
author: whiteblock
permalink: /docker_compose
---
The Whiteblock Genesis platform can also spin up a testing environment with a `docker-compose.yml` file by executing the following command with the [CLI](https://github.com/whiteblock/genesis-cli):

```bash
genesis run -c <path to docker-compose.yml> <your username or organization name>
```

## Requirements
There are a few requirements to the structure of the Compose file you choose to run with Whiteblock Genesis: 

* The Compose file you choose to run should follow the [Compose file version 3 guidelines](https://docs.docker.com/compose/compose-file/). 
* Build instructions are not currently supported.

