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


### MythX

[MythX](https://mythx.io/) is the premier security analysis service for Ethereum smart contracts. There are two ways that Genesis and MythX work together. The first way allows you to gather massive amounts of information about the performance/security of your contract in a shorter period of time. In combination with Genesis, you are able to run a MythX scan in parallel to your Genesis test. The second way is best for those who want to get results fast. You can setup a MythX scan as a pre-check for a Genesis run, if the scan fails, the run fails without spinning up a single VM.


#### Getting started

1. [Create a MythX account](https://dashboard.mythx.io/#/registration) if you do not have already have a MythX account.
2. Install the [MythX CLI tool](https://mythx-cli.readthedocs.io/en/latest/installation.html).
3. Configure MythX via the `.mythx.yaml` file, [here is a guide on how to do so](https://mythx-cli.readthedocs.io/en/latest/advanced-usage.html#configuration-using-mythx-yml)
4. Set the environment variables for MythX authentication, [here are the details on how to do so.](https://mythx-cli.readthedocs.io/en/latest/usage.html#authentication)
5. Tell Genesis you want to use MythX in your yaml file, by adding the `mythx` key under integrations, and setting `enabled` to true as follows:

```
integrations:
  mythx:
    enabled: true
```

6. If you want to use MythX as a pre-check, then add `pre-check: true` to the MythX configuration. Genesis will then run a MythX scan according to your configuration before running.


#### Further information

Check out the [official MythX documentation](https://docs.mythx.io/) helpful guides and a tool overview! A comprehensive overview of the detectors MythX offers is available on the [official website](https://mythx.io/detectors/).

Does anything not work as expected? Feel free to [contact us](https://docs.mythx.io/getting-help) directly or log a bug on the MythX CLI [Github repository](https://github.com/dmuhs/mythx-cli)!
