---
title: Genesis YAML DSL
tags: []
author: whiteblock
permalink: /dsl
---

To make the process of writting YAML files significantly easier, we have a DSL which executes on the YAML as a pre-processor. This allows you to write short YAML files which do a lot. All expressions in the DSL begin with `$_` to uniquely identify them. 

There are currently two types of entities in the DSL, values and functions.

## Values
Values are simple substitions, where the token will be substituted with a value

### $\_n
`$_n` gets replaced by the service index. So, if you have a service whose definition is 
```yaml
 -  name: geth
    image: "ethereum/client-go:alltools-latest" 
    input-files: 
      - source-path: ./keystore/pk$_n
        destination-path: /geth/keystore/pk

```
and you definite a test which looks like
```yaml
tests: 
  - name: dsl_example_n 
    phases:
      - name: start
        system: 
        - type: geth
          count: 2
```
then there will be two instances of geth created from the start phase. The first instance would have its source file be ./keystore/pk0 and the second instance would have it be ./keystore/pk1.


### $\_host
`$_host` is a straight-forward value, it currently only applies when used in the environment variable declaration of a service, sidecar or taskrunner. It is simply replaced with the valid DNS name which resolves to the IP of the server on which the container resides.

## Functions
Functions are like values, in that they will be substituted with a value, the main difference is that they take in values, and perform logic on those values before outputting them. 

### $\_one\_of(service, network)
This function allows you to retrieve the IP of a random service of the given name on the given network. So, if you wanted the ip of a random geth service on the common network, you would use `$_one_of(geth,common)`

#### Example
```yaml
services:
  - name: bitcoin
    image: nicolasdorier/docker-bitcoin:0.16.3
    args:
      - bitcoind
      - '$_one_of(bitcoin,net)'
    environment:
      FOO: '$_one_of(bitcoin,net)'
tests:
  - name: simple-bitcoin-exercise
    system:
      - type: bitcoin
        resources:
          networks:
            - name: net
```

### $\_dist\_ports(port)
This function allows you to do a range based port mapping in order to expose multiple instances of a service on the same machine, conserving resources. It can only be used under port mappings in a system declaration. It is safe for ports which declare the transport type, such as 80/tcp or 512/udp. It is strongly encouraged to use this function only on higher port numbers rather than lower ones, to prevent clashes with system port bindings. 

The function uses a simple additive distribute, where the service instance index is simply added to the given value. So, if you have a service foo, with a count of 3, and an input of 10000/udp to this function, then you would get 10000/udp, 10001/udp, 10002/udp respectively for the instances