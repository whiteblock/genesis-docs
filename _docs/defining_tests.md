---
title: Defining Tests
tags: []
author: whiteblock
permalink: /defining_tests
---
Whiteblock Genesis uses a simple and declarative YAML format to describe your end-to-end test to execute. We refer to this format as our test definition format, and files that are written in this format as test definition files. Test definition files are declarative in that they let you simply describe the system you want to test and the way in which you want to test it, and Whiteblock Genesis does the work necessary to deploy and test that system.

The test definition format is formally defined as a JSON schema. We describe the format in depth here, and you may also refer to our [schema documentation](/schema.html) for a detailed, but shorter form reference.

Alternatively, it is also possible to run tests on Whiteblock Genesis using a [`docker-compose.yml` file](/docker_compose.html).

## Document Structure

Test definition files have two main sections. In the first section we define the reusable components of our system. In the second section, we define the tests that compose your system components into a running system and how to exercise that system.

## Defining Reusable System Components

Most distributed systems can be broken down into three main types of components: **services, sidecars,** and **task runners**. 
* **Services** are the long-running processes that usually house the bulk of your system's functionality. 
* **Sidecars** are additional processes that are deployed alongside your services to augment them with additional functionality, or monitor them. 
* Finally, **task runners** are short-lived processes that only run for the time necessary to complete their task. These are usually the behind-the-scenes processes that perform various tasks or checks asynchronously, either on a fixed schedule, as a response to some event, or when an administrator elects to run them.

In modern distributed systems, it's common for multiple instances of the same service and their sidecars to run alongside one another. This is usually done to improve some combination of availability, fault tolerance, responsiveness, and capacity.

Tasks on the other hand are usually run as single processes with no redundancy. They are run until they terminate, and success or failure is usually determined by their exit code.

Whiteblock Genesis properly respects the exit code of any task to determine if a test has passed or failed. We discuss this in more detail in the section titled [Test Phase Transitions & Test Results](#defining-test-phases) below.

### Defining Services

Services are first defined at the root level of the test definition file under the `services` array. Each entry of this array is an object that defines a type of service. These service definitions can be referenced in test and phase definitions, as discussed below in the section titled [Initial System Definition](#initial-system-definition)

Like all system components, you can create service definitions from a Docker image reference, or from local files. We examine both approaches in the subsections below.

#### Defining a Service from a Docker Image

Let's start off with a simple example:

```yaml
services:
  - name: nginx
    image: nginx
    
...
```

In this example we define a single service for running Nginx, the popular web server. When used in a test, this service will run as a Docker container provisioned from [the public `nginx` DockerHub image](https://hub.docker.com/_/nginx). In this case, we'll pull and run the version of the image tagged `latest`.

Any string that can be used as an image reference in the `docker pull` command can be used in the `image` field. 

The image tag will default to `latest` unless otherwise specified. To provision a specific version of the image, just specify the image [tag](https://hub.docker.com/_/nginx?tab=tags) that you want to use, as shown below. 

Note that in this example we use quotes around the image name and tag. This is because YAML requires strings that contain the `:` character to be quoted.

```yaml
services:
  - name: nginx
  - image: "nginx:1.17.6"

...
```

#### Defining a Service from Local Files

Services can also be defined from local files. For example, perhaps you have a NodeJS backend that you'd like to run, but you don't want to build and publish a Docker image for it.

First, let's assume that you have a simple project file structure like the following, where `genesis.yml` is your test definition file:

```
myProject
├── genesis.yml
├── index.js
├── package.json
└── ...
```

You can create a service from your local `myProject` directory and the [`node` image on DockerHub](https://hub.docker.com/_/node/) with the following example:

```yaml
services:
  - name: myProject
    image: node
    script:
      inline: "cd /opt/myProject && npm install && node index.js"
    input-files:
      - source-path: ./
        destination-path: /opt/myProject

...
```

This example makes use of two new fields in our service definitions: `script` and `input-files`.

##### Defining a Script for a Service
Adding the `script` field tells Whiteblock Genesis to start the container by executing the given script, rather than by running the default command specified by the Docker image. 

Scripts can be defined inline, as shown in the example above, or as a reference to a local file, by using `source-path` in place of `inline`. When using `source-path`, its value must be a path to a file on your local filesystem, relative to the directory that contains your test definition file.

All scripts are interpreted as shell scripts, unless a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) is included as the first line of your script.

For initialization, multi-line scripts are allowed in in-line, as demonstrated below.

```yaml
services:
  - name: myProject
    image: node
    script:
      inline: | 
        cd /opt/myProject
        npm install
        node index.js
    input-files:
      - source-path: ./
        destination-path: /opt/myProject

```

##### Defining Input Files for a Service
The `input-files` object is used to copy files or directories from your local filesystem into the service's container. The `source-path` is expected to be a path to the file or directory relative to the directory that contains your test definition file, or a URL. In the example case above, we specify our `source-path` as `./` to include the entire local directory in the service container. 

The `destination-path` field is expected to be the path to which the local file or directory should be copied, relative to the root of the container filesystem.

#### Defining the Hardware Requirements for a Service

Service definitions can specify the vCPU core count, system memory, and storage that the service requires to perform effectively. 

Services will be run on Intel Cascade Lake vCPUs with a base frequency of 2.8 GHz and a sustained all core turbo of 3.4 GHz. Storage will be allocated from NVMe SSDs connected to the host machine via a PCI Express bus.

Memory and vCPUs can be specified up to the limits that your subscription tier allows, with a maximum of 64 vCPU cores and 128GiB of memory per service instance. Up to 180 GiB of storage can be provisioned per service instance as well, with no additional limits imposed by your subscription tier.

Hardware requirements can be specified for your service as shown in the example below, under the `resources` key:

```yaml
services:
  - name: nginx
    image: nginx
    resources:
      cpus: 2
      memory: 4 GiB
      storage: 16 GiB
```

The `memory` and `storage` fields allow the case-insensitive suffixes KB, KiB, MB, MiB, GB, GiB, and if no suffix is given, the value for `memory` is interpreted as `MB`, and the value for `storage` is interpreted as `GB`. We use "power-of-two" sizes for all values, meaning that the suffixes `MB` and `MiB` are considered to be equivalent, and `1 MB = 1 MiB = 1,048,576 bytes`.

If `resources` are not specified, we default to 1 vCPU, 512 MiB of memory, and 8 GiB of storage.

#### Defining Volumes
Service definitions, as well as `sidecars` and `task-runners`, can specify volumes to be read from and/or written to throughout the duration of the test(s) in your test definition file.

The `volumes` array is optional and is used to specify which of the peer service's `volumes` to mount, and the path in the sidecar's filesystem to which they should be mounted.

Each object in the `volumes` array is required to specify a `name` and `path`. The `name` must match the name of a `volume` exposed by the service to which the sidecar is peered. 

Optionally, a `permissions` field can be specified with a value of either `ro` or `rw` to specify whether the file or directory should be mounted into the sidecar with read-only (`ro`), or read-write (`rw`) permissions. If `permissions` is not specified, a default value of `rw` is assumed.

```yaml
services:
  - name: nginx
    image: nginx
    volumes:
      - name: accessLog
        path: /var/log/nginx/access.log
        permissions: ro
      - name: errorLog # this volume will have read-write permissions, as that is the default
        path: /var/log/nginx/error.log
```

### Defining Sidecars

Sidecars are first defined at the root level of the test definition document under the `sidecars` array. Each entry of this array is an object that defines a type of sidecar that can be ran alongside a given service type.

Sidecar definitions are structurally identical to service definitions, with one exception: sidecar definitions require you to specify to which service they are paired via the `sidecar-to` field.

The `sidecar-to` array must contain the name of at least one service to which your sidecar will be paired. It is required to specify this field for all sidecar definitions.

Additionally, similar to services, sidecars may use `volumes`. Both the `sidecar-to` and `volumes` can be seen in the example below, repeated from the [Sharing Data With Sidecars](#sharing-data-with-sidecars) section above.

```yaml
sidecars:
  - name: nginx-log-monitor
    sidecar-to: 
      - nginx
    image: alpine
    script:
      source-path: ./log-monitor.sh
    volumes:
      - name: accessLog
        path: /var/log/nginx/access.log
        permissions: ro
      - name: errorLog # this volume will have read-write permissions, as that is the default
        path: /var/log/nginx/error.log

...
```

##### Sharing Data with Sidecars

Let's assume that you have a sidecar that needs access to a file or directory from the service's filesystem. A common example of this is a sidecar that parses a service's logs and transforms them into JSON objects to be written to stdout for the data collection pipeline. 

To give that sidecar access to the service's filesystem, we must specify `volumes`, as shown in the example below.

```yaml
sidecars:
  - name: nginx-log-monitor
    sidecar-to: nginx
    image: alpine
    script:
      source-path: ./log-monitor.sh
    volumes:
      - name: accessLog
        path: /var/log/nginx/access.log
        permissions: ro
      - name: errorLog # this volume will have read-write permissions, as that is the default
        path: /var/log/nginx/error.log

...
```

In the example above, we specify two volumes that can be read from and/or written to in the sidecar containers: Nginx's access and error logs. 

### Defining Task Runners
Task runners are first defined at the root level of the test definition document under the `task-runners` array. Each entry of this array is an object that defines a type of task to be executed during a test, as such: 

```yaml
task-runners:
  - name: task_1
    volumes:
      - name: myVolume # this volume will have read-write permissions, as that is the default
        path: /path/to/volume
    script:
      inline: curl http://localhost:4000 >> /path/to/volume/output.json
  - name: task_2
    script:
      inline: cat /path/to/volume/output.json
  - name: task_3
    script: 
      inline: curl http://localhost:4000 >> output_2.json  
```

Task runners can be referenced in phase definitions under the `tasks` array. If two tasks are referenced in the same phase, they will execute simultaneously, but if a task is referenced in an earlier phase and another task is referenced in a later phase, they will execute sequentially. An example can be seen below.

```yaml
    phases:
      - name: phase_1
        description: this phase will run first
        tasks:
        - type: task_1 # this task will run first
      - name: phase_2 
        description: this phase will run second
        tasks: # these tasks will run concurrently
        - type: task_2
        - type: task_3
```

A task may be goal-oriented and may use a success or failure to determine phase transition. For example, if a task exits with a nonzero exit code, the test will terminate with a failure result and any further tasks and phases will not be executed. Task exit codes can also be ignored if desired. See the [Defining Task Runners](#defining-task-runners) section for more details.

Tasks must have a `name`, but all other [properties](/schema.html#task-runners) are optional. 

## Defining Tests
Tests are first defined at the root level of the test definition file under the `tests` array, where each entry is a test. 

A test is a map, with several keys, including: 
* `name` for the test
* `description` of the test
* a `system` map containing a system definition that is composed from the services defined in the top-level “services” array
* test [`phases`](#defining-test-phases ) 


Each test may have only one `system` definition, but it can contain several `phases`, as seen below: 

```yaml
tests:
  - name: test_1
    description: run a simple test
    system:
      - name: alpha
        type: service_1
        count: 1 # the number of instances defaults to 1 unless otherwise specified by the `count` key.        
        resources:
          networks:
            - name: individual_a
            - name: common
              bandwidth: 3 Mbyte
              packet-loss: 1% 
              latency: 2 ms
        sidecars:
        - name: gamma
          type: sidecar_1                 
      - name: beta
        type: service_2
        resources:
          networks:
            - name: individual_b
            - name: common                                              
    phases:
      - name: phase_1
        description: this phase will run first
        tasks:
        - type: task_1
          description: this task runs first
      - name: phase_2 
        description: this phase will run second
        tasks: 
        - type: task_2
          description: this task runs second
```

### Initial System Definition
Each test contains one `system` that provides a definition for the distributed system under test. Systems are collections of running instances of the software defined under the `services` and `sidecars` arrays at the root level of the test definition file. 


While there can only be one system definition per test, the system definition can be [mutated](#changing-your-system-definition) at the start of each test `phase`.

#### Defining Networks
Several networks may be defined in a `system` definition at the `resources` level, seen below.

```yaml
    system:
      - name: alpha
        type: service_1        
        resources:
          networks:
            - name: individual_a
            - name: common
              bandwidth: 3 Mbyte
              packet-loss: 1% 
              latency: 2 ms           
      - name: beta
        type: service_2
        resources:
          networks:
            - name: individual_b
            - name: common
```
In the example above, the `alpha` and `beta` services are each connected to two networks, but only share one network in common: the `common` network.


Each entry in the `networks` array is a map that specifies the connection of the service to a virtual network via a virtual NIC. 

If no network is defined, then the service is connected to a default network with no impairments. This default network has the name `default`.

##### Defining Network Impairments
Network impairments can be introduced when a network is defined at the `resources` level, as seen below. 

```yaml
    system:
      - name: alpha
        type: service_1
        resources:
          networks:
            - name: common
              bandwidth: 3 Mbyte
              packet-loss: 1% 
              latency: 2 ms
```

###### Bandwidth
Bandwidth is the maximum data rate that a network connection can support. 

The value of `bandwidth` can be a string or a number, ending with the valid [suffixes](/schema.html#bandwidth) referenced in the test definition format schema.

* A value of 0 for a bandwidth definition is equivalent to not allowing any connections on that network. 
* A value of 'none' for a bandwidth definition means that no limit is enforced.
* If no suffix is specified in the bandwidth definition, `Mbit` is assumed. 


If `bandwidth` is not specified, no bandwidth limit is enforced.

###### Packet Loss
In the test definition file, `packet-loss` is a floating point value representing the percentage of packets that are dropped, or "lost", by the network, ranging from 0 to 100%.


The `%` suffix is allowed, but not required. If the value is outside of the range of 0-100%, an error will result.


If `packet-loss` is not defined, the default value will be assumed as 0%.

###### Latency
Latency is the minimum delay that a service instance experiences before receiving packets. 


The following time suffixes are observed and are case insensitive: `us`, `ms`, and `s`. If no suffix is specified, `ms` is assumed.


Packet delays defined at this level are cumulative, meaning that a service instance with a latency of 100ms that pings another service instance with a latency of 50ms will observe a total minimum latency of 150ms.


A value of `none` or `0` for a latency definition means that no minimum packet delay is enforced.


If `latency` is not specified, no minimum packet delay is enforced.

### Defining Test Phases
Test phases can be thought of as the logical steps for executing a test – they define operations Genesis will perform while executing your test. Phases can mutate the system definition, execute short-lived tasks that perform some setup step, exercise the system, or monitor the system for the occurrence of some event.

Phases are executed in sequence, starting with the first phase defined in your `phases` array, as seen below.


```yaml
    phases:
      - name: phase_1
        description: this phase will run first
      - name: phase_2 
        description: this phase will run second
```

#### Changing Your System Definition
You'll notice that you can specify a `system` within each `phase` as well as in the `test` itself. This might seem redundant at first, but the two `system` fields serve different purposes. The `system` defined in your test is intended to describe the initial state of the system when test execution begins. The `system` defined at the phase level composes with the initial system defined at the test level, allowing you to change the structure of your system at the start of each phase.


To keep things simple at the phase level, we've made it so that you only need to specify the changes that you want to make to the system. 


A user can modify the details of a `system` at the phase level by naming the service instance which they intend to modify and adding a new value to the keys in the service instance map they wish to change.


When modifying an existing service instance definition, only the `name` field is required, and only the values of the keys that are specified are modified. If the `name` field matches the name of a preexisting service instance within the test level system definition, that service instance definition is modified. If the name does not match an existing service instance definition, the service instance specified is added to the system for that phase. 


Once a system is mutated in one phase, it will remain mutated unless the system is mutated further or reverted in a later phase definition.


An example can be seen below. 
```yaml
    system:
      - name: alpha
        type: service_1
        resources:
          networks:
            - name: common
              bandwidth: 3 Mbyte
              packet-loss: 1% 
              latency: 2 ms
      - name: beta
        type: service_2
        resources:
          networks:
            - name: common                                              
    phases:
      - name: phase_1
        description: this phase will run first
        tasks:
        - type: task_1
      - name: phase_2 
        description: this phase will mutate the system and run second
        system:
          - name: alpha
            type: service_1
            resources:
              cpus: 2
        tasks: 
        - type: task_2
      - name: phase_3
        description: this phase will revert the system and run third  
        system: 
          - name: alpha
            type: service_1
            resources:
              cpus: 1
        tasks: 
        - type: task_3
          description: this task runs third           
```

#### Removing Services from a System
One or more services can be removed from a `system` in a phase definition. The `remove` array, defined at the phase level, only requires the name of the service or services you wish to remove.

Below, the service instance called `beta` is removed from the system definition in `phase_2`.

```yaml
tests:
  - name: test_1
    description: run a simple test
    system:
      - name: alpha
        type: service_1
        resources:
          networks:
            - name: common
              bandwidth: 3 Mbyte
              packet-loss: 1% 
              latency: 2 ms
      - name: beta
        type: service_2
        resources:
          networks:
            - name: common                                              
    phases:
      - name: phase_1
        description: this phase will run first
        tasks:
        - type: task_1
          description: this task runs first
      - name: phase_2 
        description: this phase will mutate the system and run second
        system:
          - name: alpha
            type: service_1
            resources:
              cpus: 2
        remove:
          - beta      
        tasks: 
        - type: task_2
          description: this task runs second
```

A service instance may be added back into the system in later phases by defining it in the `system` definition at the phase level with the`name` and `type` keys, as illustrated in the `phase_3` definition below.

```yaml
    phases:
      - name: phase_1
        description: this phase will run first
        tasks:
        - type: task_1
          description: this task runs first
      - name: phase_2 
        description: this phase will mutate the system and run second
        system:
          - name: alpha
            type: service_1
            resources:
              cpus: 2
        remove:
          - beta      
        tasks: 
        - type: task_2
          description: this task runs second
      - name: phase_3
        description: this phase will revert the system, reinstate service_2 and run third  
        system: 
          - name: alpha
            type: service_1
            resources:
              cpus: 1
          - name: beta
            type: service_2     
        tasks: 
        - type: task_3
          description: this task runs third     
```

#### Tasking a System
One or several [`task-runners`](#defining-task-runners) may be added to a test phase definition. They are defined at the phase level as `tasks` and are executed simultaneously when added to the same test phase.

Test phases do not complete until all tasks have terminated. Additionally, nonzero task exit codes may be used to terminate the test with a failure status, but can also be explicitly ignored by setting the `ignore-exit-code` key to `true`, which defaults to `false` if it is left undefined.

More information about the properties of `tasks` can be found in the [Test Definition Format Schema](/schema.html#tasks).

#### Test Phase Transitions & Test Results
If a `task-runner` is added to a test phase, the exit code of that task can be used to determine test phase transition, success, and failure. 

Test phases transition when all tasks defined for a phase have terminated. If any task terminates with a nonzero exit code, the test is considered to have failed and will terminate before moving on to the next phase.

#### Generating Data for Use in Later Phases

You may use data generated by earlier phases by using a `task-runner` and specifying one or more [`volumes`](/schema.html#volumes) to which your program can write. As `volumes` may contain the results of a process or exercise, those results can be read and used in a later `phase`. 

For example, the contents of a volume can be used to determine a subsequent process or exercise, or can be used to determine the overall success of a test. An example can be seen below.

```yaml
task-runners:
  - name: task_1
    volumes:
      - name: myVolume
        path: /path/to/volume
        permissions: ro
    script:
      inline: curl http://localhost:4000 >> /path/to/volume/output.json        
  - name: task_2
    script:
      inline: cat /path/to/volume/output.json
tests:
  - name: test_1
    description: run a test
    system:
      - name: alpha
        type: service_1
        resources:
          networks:
            - name: common-network
      - name: beta
        type: service_2
        resources:
          networks:
            - name: common-network
    phases:
      - name: phase_1
        description: this phase runs first and writes to the file "output.json" in the volume "myVolume"
        tasks:
          - type: task_1
            timeout: 3 m
      - name: phase_2
        description: this phase runs second and reads from "output.json" in the volume "myVolume"
        tasks: 
          - type: task_2
            timeout: 3 m
```

