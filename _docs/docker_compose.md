---
title: Running Tests Using Docker-Compose
tags: []
author: whiteblock
permalink: /docker_compose
---
The Whiteblock Genesis platform can also spin up a testing environment with a `docker-compose.yml` file by executing the following command with the [CLI](https://github.com/whiteblock/genesis-cli):

```bash
genesis run -c <path to docker-compose.yml> <your username or organization name>
```

## Requirements
There are a few requirements to the structure of the compose file you choose to run with Whiteblock Genesis: 

* The compose file you choose to run should follow the [Compose file version 3 guidelines](https://docs.docker.com/compose/compose-file/). 
* Instead of build context, the compose file should pull from a Docker image.

