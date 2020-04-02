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

### Whiteblock Genesis Dashboard
The `Tests` page in the [Whiteblock Genesis Dashboard](https://www.genesis.whiteblock.io/login) shows data related to the test you've submitted, such as its current status, its current phase, and its up-to-date logs. 

You may choose to display logs according to the variety of filters offered by the Genesis Dashboard, including time, test ID, service, service instance number, sidecar, task, phase, among other options. 

