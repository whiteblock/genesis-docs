---
title: Running Your Tests
tags: []
author: whiteblock
permalink: /running_tests
---

## Installing the Whiteblock Genesis CLI

The Whiteblock Genesis CLI is open source and available for download from our [Github repository](https://github.com/whiteblock/genesis-cli).

## Runtime Environment
Once you've downloaded the Whiteblock Genesis CLI, run the following command to see the environment variables provided to your container: 

```
genesis env <file>
```

### Environment Variables for IPs
The Genesis platform provides environment variables to give you the IP addresses of services in the network. All environment variables for IPs will be in all caps and also have `-` replaced with an underscore.

### Services
The environment variables for the IP addresses of Services will be of the following format: 
```
{service}_SERVICE{instance_no}_{network}
``` 

So, if you have a service `foo-baz` on the network 
`bar`, then the first instance's IP address would be given in the environment variable `FOO_BAZ_SERVICE0_BAR`.

### Sidecars
The naming of environment variables for sidecars is very similar to that of Services, with a few differences: 
* The service's IP in the sidecar network will be the instance name of service, i.e., `{service}_SERVICE{instance_no}`.
* The sidecars' IP environment variables are formatted as though the service is their network. For example, to find the IP of a sidecar `soap-bar` to the 0th service instance of `foo-baz`, you would check the value of `SOAP_BAR_FOO_BAZ_SERVICE0`.

## Running Tests from the CLI

Once you've created a [test definition](/defining_tests.html) to run, you can run them using our CLI tool with the following command:

```
genesis run test-definition.yml
```

Where `test-definition.yml` is the path to your test definition file on your local filesystem.

## Running Tests from the Whiteblock Genesis Dashboard

To run a test via the Whiteblock Genesis web dashboard, simply drag your test file into the upload element of our webpage as shown below.

![upload](/assets/img/upload.gif)

## Understanding Test Results

On completion, tests will have one of the statuses below

| Status  | Success | Description                                                                                                                                                       |
| ------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Passed  | yes     | Indicates that your test ran successfully and no tasks exited with a nonzero exit code.                                                                           |
| Failed  | no      | Indicates that one or more tasks exited with a nonzero exit code during one of your test phases.                                                                  |
| Timeout | no      | Indicates that one or more tasks didn't exit before the timeout specified. Note that a default timeout of 2 minutes is enforced if no other timeout is specified. |
| Error   | no      | (rare) Indicates that your test could not start, or once started, your test could not be run to completion due to some error in the Whiteblock Genesis platform.  |

