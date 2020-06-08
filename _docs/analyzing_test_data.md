---
title: Collecting and Analyzing Test Data
tags: []
author: whiteblock
permalink: /analyzing_test_data
---
## Whiteblock Genesis Data Collection Pipeline
Whiteblock Genesis simplifies data collection using a variety of available tools to monitor test networks, parse logs, and digest output data in volumes for faster search and analysis.

## Writing Out Test Data for Later Analysis
Two main tools available in the Test Definition File aid with data collection when designing tests: `volumes` and `sidecars`.

While data from tests collected in  [`volumes`](/schema.html#volumes) can be analyzed in later tests phases, it can also be used for analysis with our suite of integrated analytics tools after tests complete.

[`Sidecars`](/defining_tests.html#defining-sidecars) may also be used for network monitoring and data collection.

### Using Sidecars for Data Collection
Sidecars are supplemental services that can enhance or provide utility to main services running on a test network. Services, such as [Prometheus](https://prometheus.io/), can be added to a test network as sidecars to serve as preferential data analysis tools when desired.

## Inspecting & Analyzing Test Data

### Logs 
Whiteblock Genesis logs are in JSON line format, and are sent out via syslog-ng instances. An example of what to expect from a log line is this 
```
{"TESTRUN":"c43eb6e0-09e3-4adc-a11e-bbc723dc24a3","TEST":"geth_network_2_nodes","PRIORITY":"3","PHASE":"start","ORG":"e6bec93a-8fda-11ea-86e0-42010a90000d","NAME":"geth1-service0","MESSAGE":"INFO [05-13|14:05:45.132] Generating DAG in progress               epoch=1 percentage=39 elapsed=16.265s","IMAGE_NAME":"ethereum/client-go:alltools-latest","CONTAINER_TAG":"9bb1f8a9e6c0","CONTAINER_NAME":"geth1-service0"}
```
The tags allow you to easily identify the source of each log line, making processing easier. 

### Connecting logs to your internal tool set
It is easy to connect Genesis to your internal log processing tooling. All that is needed is a syslog compatible log server. To send the logs to this server, you can use the command `genesis settings set syslogng-host <host>` to set the host destination. Genesis will by default try to connect to tcp port 514 on this host. If you wish to change this, you can use the command `genesis settings set syslogng-port <port>` to set the port number, as well as  `genesis settings set syslogng-protocol <protocol>` to change to protocol. 

Note: Settings are organization wide, all users in the same org will have the same settings. If you wish to have separate settings, you can either use your personal organization (your username) or contact us for a more customized solution