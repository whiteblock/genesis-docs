---
title: Quick Start
tags: []
author: whiteblock
permalink: /quick_start
---

## TL;DR
* [Sign up](https://genesis.whiteblock.io/)
* Install the [CLI](#run-your-test-definition-file)
* Download and [run](#run-your-test-definition-file) this Geth sample test: 

  ```bash
  curl https://raw.githubusercontent.com/whiteblock/genesis-examples/master/tutorials/tutorial.yaml >> geth.yaml
  genesis run geth.yaml
  ```

Looking to quickly build your own test definition file? Use the instructions below. 

## Build a Simple Test Definition YAML File
### Step 1 - Services
* Define the [services](/defining_tests.html#defining-services) you'd like to test. 
* Specify a Docker image that can be used with the `docker pull` command. 
* Optional: specify resources for your service instances.

```yaml
services:
  - name: service_1
    image: example/image
    resources:
      cpus: 1
      memory: 2 GB
      storage: 5 GiB
  - name: service_2
    image: example/image
    resources:
      cpus: 2
      memory: 2 GB
      storage: 5 GiB
```

### Step 2 - Sidecars
* Define your [sidecars](/defining_tests.html#defining-sidecars) (if you have any) in the same manner as your services.

```yaml
sidecars:
  - name: sidecar_1
    sidecar-to:  # specifies which services this sidecar is attached to
       - service_1
       - service_2
    image: example/image
    resources: 
      cpus: 1
      memory: 1 GB
      storage: 2 GiB
```

### Step 3 - Task Runners
* Define some [tasks](/defining_tests.html#defining-task-runners) you'd like to incorporate in your test(s).

```yaml
task-runners:
  - name: task_1
    script:
      inline: curl http://localhost:4000 >> output.json
    volumes:
      - name: myOutputFile # name of the volume
        path: /path/to/output.json  # path where the volume should be located
  - name: task_2
    script:
      inline: print ${output.json}
  - name: task_3
    script: 
      inline: sleep 120 # pause for two minutes before moving on to the next task or process
```

### Step 4 - Define your Test(s)
* Define a [test](/defining_tests.html#defining-tests) (or two, if you'd like) by giving the test a name.
* Give it a description (optional).

```yaml
tests:
  - name: test_1
    description: run one alpha service on both the common-network and alpha-network, run one beta service on both the common-network and beta-network, and run two gamma sidecars on all three networks mentioned  
```

### Step 5 - Define a System in your Test
* Define a [system](/defining_tests.html#initial-system-definition) in your test. A `system` just specifies all services and sidecars you'd like to include in the test.
* Here, you may also define [networks](defining_tests.html#defining-networks) you'd like your services and sidecars to connect to under the `resources` key.
```yaml
tests:
  - name: test_1
    description: run one alpha service on both the common-network and alpha-network, run one beta service on both the common-network and beta-network, and run two gamma sidecars on all three networks mentioned
    system:
      - name: alpha
        type: service_1
        count: 1
        resources:
          networks:
            - name: common-network
            - name: alpha-network
      - name: beta
        type: service_2
        count: 1
        resources:
          networks:
            - name: common-network
            - name: beta-network
      - name: gamma
        type: sidecar_1
        count: 2
        resources: 
          networks:
            - name: common-network  
            - name: alpha-network
            - name: beta-network     
```

### Step 6 - Add Phases to your Test
* Add some [phases](/defining_tests.html#defining-test-phases) to your test. Phases simply define a sequence of actions for your test to perform.
* Remember the task runners you defined earlier? You can run these [tasks](/defining_tests.html#tasking-a-system) in test phases! Add one or more tasks to the test phases you've defined.
* You can also define a timeout (optional) for your task in case you want to place a time limit for your task to execute. (Pro tip: if a phase terminates due to a timeout, it's typically considered to be a failure).
```yaml
tests:
  - name: test_1
    description: run one alpha service on both the common-network and alpha-network, run one beta service on both the common-network and beta-network, and run two gamma sidecars on all three networks mentioned
    system:
      - name: alpha
        type: service_1
        count: 1
        resources:
          networks:
            - name: common-network
            - name: alpha-network
      - name: beta
        type: service_2
        count: 1
        resources:
          networks:
            - name: common-network
            - name: beta-network
      - name: gamma
        type: sidecar_1
        count: 2
        resources: 
          networks:
            - name: common-network  
            - name: alpha-network
            - name: beta-network        
    phases:
      - name: phase_1
        description: this phase runs first and writes to the output file, output.json
        tasks:
          - type: task_1
            timeout: 3 m
      - name: phase_2
        description: this phase runs second and reads from output.json
        tasks:
          - type: task_2
          - type: task_3  
```

## Run your Test Definition File
### Step 1 - Download the Genesis CLI
```bash
curl -sSf https://assets.whiteblock.io/cli/install.sh | sh
```
or download from [source](https://github.com/whiteblock/genesis-cli).

### Step 2 - Run your Test
```bash
genesis run <path to your YAML file> <your-organization-name>
```

### Step 3 - View Logs from the Test
* Log into the [Genesis Dashboard](https://genesis.whiteblock.io/login).
* Navigate to Logs in the left sidebar.

Congratulations! Welcome to #WhiteblockWorld.
