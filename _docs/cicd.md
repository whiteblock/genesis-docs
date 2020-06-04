---
title: Integrating into CI/CD
tags: []
author: whiteblock
permalink: /cicd
---

## Authenticating the CLI
The Genesis CLI can be authenticated by providing the access token in the environment variable `GENESIS_CREDENTIALS`. See the section below to learn how to get an access token.

## Obtaining an access token
You can easily obtain an access token via the Genesis CLI on your local machine. Simply run the command `genesis auth print-access-token` and copy the output. This will need to be placed into the environment variable `GENESIS_CREDENTIALS` in the CI/CD tool you are using for the Genesis CLI to work

## Error Behavior
If there is an error in the test and/or one of the cases fails, the Genesis CLI will exit with a non-zero status code. 