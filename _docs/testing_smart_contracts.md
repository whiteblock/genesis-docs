---
title: Testing Smart Contracts With Genesis
tags: []
author: whiteblock
permalink: /testing_smart_contracts
---

## How to test your smart contract in Genesis

### Uploading

### Compilation

### Deployment

## How to get the most out of smart contract testing with Genesis
Genesis integrates with top of the line smart contract testing tools in order to provide you with the best testing experience. 

### Mythx
[MythX](https://mythx.io/) is the premier security analysis service for Ethereum smart contracts. There are two ways that Genesis and Mythx work together. The first way allows you to gather massive amounts of information about the performance/security of your contract in a shorter period of time. In combination with Genesis, you are able to run a Mythx scan in parallel to your Genesis test. The second way is best for those who want to get results fast. You can setup a Mythx scan as a pre-check for a Genesis run, if the scan fails, the run fails without spinning up a single VM. 

#### Getting started
1. [Create a Mythx account](https://dashboard.mythx.io/#/registration) if you do not have already have a Mythx account.  
2. Install the [Mythx CLI tool.](https://mythx-cli.readthedocs.io/en/latest/installation.html)
3. Configure Mythx via the .mythx.yaml file, [here is a guide on how to do so](https://mythx-cli.readthedocs.io/en/latest/advanced-usage.html#configuration-using-mythx-yml)
4. Set the environmental variables for Mythx authentication, [here are the details on how to do so.](https://mythx-cli.readthedocs.io/en/latest/usage.html#authentication)
5. Tell Genesis you want to use Mythx in your yaml file, by adding the mythx object under integrations, and setting enabled to true. 
It would look like this 
```
integrations:
  mythx:
    enabled: true
```
6. If you want to use Mythx as a precheck, then add `pre-check: true` to the mythx configuration under integrations. Genesis will then know to run a Mythx scan according to your configuration before running. 


