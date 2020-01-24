---
title: Test Definition Format Schema Reference
tags: []
author: whiteblock
permalink: /schema
---

# Schema

```
https://assets.whiteblock.io/schema/schema.json
```

A definition for a set of full-scale distributed systems tests that each exercise a common set of software.

| Abstract            | Extensible | Status       | Identifiable | Custom Properties | Additional Properties | Defined In |
| ------------------- | ---------- | ------------ | ------------ | ----------------- | --------------------- | ---------- |
| Can be instantiated | No         | Experimental | No           | Forbidden         | Forbidden             |            |

# Properties

| Property                      | Type       | Required     | Nullable | Defined by    |
| ----------------------------- | ---------- | ------------ | -------- | ------------- |
| [services](#services)         | `object[]` | Optional     | No       | (this schema) |
| [sidecars](#sidecars)         | `object[]` | Optional     | No       | (this schema) |
| [task-runners](#task-runners) | `object[]` | **Required** | No       | (this schema) |
| [tests](#tests)               | `object[]` | **Required** | No       | (this schema) |

## services

An array of component service definitions that can be later referenced to create a specific distributed system definition to test. 

Services must be included in your `system` definition to run during your test, and they are expected to run for the lifetime of the test.

`services`

- is optional
- type: `object[]`
- defined in this schema

### services Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property         | Type   | Required     |
| ---------------- | ------ | ------------ |
| `args`           | array  | Optional     |
| `description`    | string | Optional     |
| `environment`    | object | Optional     |
| `image`          | string | Optional     |
| `input-files`    | array  | Optional     |
| `name`           | string | **Required** |
| `resources`      | object | Optional     |
| `script`         | object | Optional     |
| `volumes`        | array  | Optional     |

#### args

A sequence of command-line arguments to be passed directly to the service container on startup.

`args`

- is optional
- type: `string[]`\* at least `1` items in the array

##### args Type

Array type: `string[]`

All items must be of the type: `string`

#### description

A short description of the service to be used for display purposes.

`description`

- is optional
- type: `string`

##### description Type

`string`

#### environment

A map of environment variables to be set in the container on startup, where the keys in the map are the environment variable names, and the values are the environment variable values.

`environment`

- is optional
- type: `object`

##### environment Type

`object` with following properties:

| Property | Type | Required |
| -------- | ---- | -------- |


#### image

A string that represents a reference to a docker image and tag that can be used to create processes of this type. This string must be of a format that can be accepted by the docker pull command.

This key is required if the script key is not specified. If image is not specified, the script is run inside of the
latest Ubuntu LTE release docker image.

`image`

- is optional
- type: `string`

##### image Type

`string`

All instances must conform to this regular expression (test examples
[here](<https://regexr.com/?expression=%5E(%3F%3A(%3F%3D%5B%5E%3A%2F%5D%7B4%2C253%7D)(%3F!-)%5Ba-zA-Z0-9-%5D%7B1%2C63%7D(%3F%3C!-)(%3F%3A%5C.(%3F!-)%5Ba-zA-Z0-9-%5D%7B1%2C63%7D(%3F%3C!-))*(%3F%3A%3A%5B0-9%5D%7B1%2C5%7D)%3F%2F)%3F((%3F!%5B._-%5D)(%3F%3A%5Ba-z0-9._-%5D*)(%3F%3C!%5B._-%5D)(%3F%3A%2F(%3F!%5B._-%5D)%5Ba-z0-9._-%5D*(%3F%3C!%5B._-%5D))*)(%3F%3A%3A(%3F!%5B.-%5D)%5Ba-zA-Z0-9_.-%5D%7B1%2C128%7D)%3F%24>)):

```regex
^(?:(?=[^:/]{4,253})(?!-)[a-zA-Z0-9-]{1,63}(?<!-)(?:\.(?!-)[a-zA-Z0-9-]{1,63}(?<!-))*(?::[0-9]{1,5})?/)?((?![._-])(?:[a-z0-9._-]*)(?<![._-])(?:/(?![._-])[a-z0-9._-]*(?<![._-]))*)(?::(?![.-])[a-zA-Z0-9_.-]{1,128})?$
```

#### input-files

A sequence of local files or directories that should be included in the container when it is created.

`input-files`

- is optional
- type: `object[]`

##### input-files Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property           | Type    | Required     |
| ------------------ | ------- | ------------ |
| `destination-path` | string  | **Required** |
| `source-path`      | string  | **Required** |

#### source-path

The local path to the file or directory to be included, relative to the directory that contains the test definition file, or a URL.

`source-path`

- is **required**
- type: `string`

##### source-path Type

`string`

#### destination-path

The path within the docker container where this file or directory should be placed.

`destination-path`

- is **required**
- type: `string`

##### destination-path Type

`string`

#### name

A short string used to reference this service type in your system definition in your tests. Also used to identify logging messages produced by services of this type.

`name`

- is **required**
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### resources

A mapping that defines the hardware and network resources available to this process.

`resources`

- is optional
- type: `object`

##### resources Type

`object` with following properties:

| Property  | Type          | Required | Default     |
| --------- | ------------- | -------- | ----------- |
| `cpus`    | number        | Optional | `1`         |
| `memory`  | string,number | Optional | `"512 MiB"` |
| `storage` | string,number | Optional | `"8 GiB"`   |

#### cpus

A positive integer that defines the number of CPU cores to be used for each running instance of this service.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions. Defaults to 1.

`cpus`

- is optional
- type: `number`
- default: `1`

##### cpus Type

`number`

- minimum value: `1`
- must be a multiple of `1`

#### memory

The amount of RAM to be allocated for each running instance of this service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as MB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 512 MiB.

`memory`

- is optional
- type: multiple
- default: `"512 MiB"`

##### memory Type

Unknown type `string,number`.

```json
{
  "description": "The amount of RAM to be allocated for each running instance of this service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as MB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 512 MiB.",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgG][iI]?[bB]$",
  "default": "512 MiB",
  "simpletype": "multiple"
}
```

#### storage

The amount of disk space to be made available for each running instance of the service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as GiB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 8 GiB

`storage`

- is optional
- type: multiple
- default: `"8 GiB"`

##### storage Type

Unknown type `string,number`.

```json
{
  "description": "The amount of disk space to be made available for each running instance of the service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as GiB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 8 GiB",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgGtT][iI]?[bB]$",
  "default": "8 GiB",
  "simpletype": "multiple"
}
```

#### script

Allows the user to define a custom script to execute as the main container process. When image is specified, this script overrides the startup command specified by the docker image. Conversely if this key is not defined but the image key is present, the startup command defined in the docker image should be used.

The value of this item is a mapping which must either the inline key, or the source_path key.

`script`

- is optional
- type: `object`

##### script Type

`object` with following properties:

| Property      | Type   | Required |
| ------------- | ------ | -------- |
| `inline`      | string | Optional |
| `source-path` | string | Optional |

#### inline

This key allows the user to specify their script inline in the test definition file, observing YAML’s multiline quoting syntax.

This key is required if the source-path key is not specified.

`inline`

- is optional
- type: `string`

##### inline Type

`string`

## sidecars

An array of service sidecar definitions. Sidecars augment, instrument and/or exercise the services under test in some way. One sidecar process is deployed per service process in the system, and they share some machine-level resources. Like services, sidecars run for the lifetime of the test.

`sidecars`

- is optional
- type: `object[]`
- defined in this schema

### sidecars Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property          | Type   | Required     |
| ----------------- | ------ | ------------ |
| `args`            | array  | Optional     |
| `description`     | string | Optional     |
| `environment`     | object | Optional     |
| `image`           | string | Optional     |
| `input-files`     | array  | Optional     |
| `volumes`         | array  | Optional     |
| `name`            | string | **Required** |
| `resources`       | object | Optional     |
| `script`          | object | Optional     |
| `sidecar-to`      | array  | **Required** |

#### args

A sequence of command-line arguments to be passed directly to the service container on startup.

`args`

- is optional
- type: `string[]`\* at least `1` items in the array

##### args Type

Array type: `string[]`

All items must be of the type: `string`

#### description

A short description of the sidecar to be used for display purposes.

`description`

- is optional
- type: `string`

##### description Type

`string`

#### environment

A map of environment variables to be set in the container on startup, where the keys in the map are the environment variable names, and the values are the environment variable values.

`environment`

- is optional
- type: `object`

##### environment Type

`object` with following properties:

| Property | Type | Required |
| -------- | ---- | -------- |


#### image

A string that represents a reference to a docker image and tag that can be used to create processes of this type. This string must be of a format that can be accepted by the docker pull command.

This key is required if the script key is not specified. If image is not specified, the script is run inside of the
latest Ubuntu LTE release docker image.

`image`

- is optional
- type: `string`

##### image Type

`string`

All instances must conform to this regular expression (test examples
[here](<https://regexr.com/?expression=%5E(%3F%3A(%3F%3D%5B%5E%3A%2F%5D%7B4%2C253%7D)(%3F!-)%5Ba-zA-Z0-9-%5D%7B1%2C63%7D(%3F%3C!-)(%3F%3A%5C.(%3F!-)%5Ba-zA-Z0-9-%5D%7B1%2C63%7D(%3F%3C!-))*(%3F%3A%3A%5B0-9%5D%7B1%2C5%7D)%3F%2F)%3F((%3F!%5B._-%5D)(%3F%3A%5Ba-z0-9._-%5D*)(%3F%3C!%5B._-%5D)(%3F%3A%2F(%3F!%5B._-%5D)%5Ba-z0-9._-%5D*(%3F%3C!%5B._-%5D))*)(%3F%3A%3A(%3F!%5B.-%5D)%5Ba-zA-Z0-9_.-%5D%7B1%2C128%7D)%3F%24>)):

```regex
^(?:(?=[^:/]{4,253})(?!-)[a-zA-Z0-9-]{1,63}(?<!-)(?:\.(?!-)[a-zA-Z0-9-]{1,63}(?<!-))*(?::[0-9]{1,5})?/)?((?![._-])(?:[a-z0-9._-]*)(?<![._-])(?:/(?![._-])[a-z0-9._-]*(?<![._-]))*)(?::(?![.-])[a-zA-Z0-9_.-]{1,128})?$
```

#### input-files

A sequence of local files or directories that should be included in the container when it is created.

`input-files`

- is optional
- type: `object[]`

##### input-files Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property           | Type    | Required     |
| ------------------ | ------- | ------------ |
| `destination-path` | string  | **Required** |
| `source-path`      | string  | **Required** |

#### destination-path

The path within the docker container where this file or directory should be placed.

`destination-path`

- is **required**
- type: `string`

##### destination-path Type

`string`

#### source-path

The local path to the file or directory to be included, relative to the directory that contains the test definition
file.

`source-path`

- is **required**
- type: `string`

##### source-path Type

`string`

#### volumes

A sequence of volumes shared by the service container that should be mounted in the sidecar container.

`volumes`

- is optional
- type: `object[]`

##### volumes Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property           | Type   | Required     | Default |
| ------------------ | ------ | ------------ | ------- |
| `path`             | string | **Required** |         |
| `permissions`      | string | Optional     | `"rw"`  |
| `name`             | string | **Required** |         |

#### path

Defines the path to which the file or directory will be mounted inside of the sidecar container.

`path`

- is **required**
- type: `string`

##### path Type

`string`

#### permissions

Defines the file level permissions used when mounting the volume into the sidecar. Can be one of ‘ro’ or ‘rw’. Defaults to ‘rw’ if not specified.

`permissions`

- is optional
- type: `enum`
- default: `"rw"`

The value of this property **must** be equal to one of the [known values below](#sidecars-known-values).

##### permissions Known Values

| Value | Description |
| ----- | ----------- |
| `ro`  |             |
| `rw`  |             |

#### name

The name of a volume produced by a service. Must correspond to an exposed volume definition for a service to which this container is a sidecar, or for a volume that is exposed by another sidecar that is attached to the corresponding service.

`name`

- is **required**
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5D%2B%24)):

```regex
^[0-9a-zA-Z-_]+$
```

#### name

A short string used to reference this sidecar type in your system definition in your tests. Also used to identify logging messages produced by sidecars of this type.

`name`

- is **required**
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### resources

A mapping that defines the hardware and network resources available to this process.

`resources`

- is optional
- type: `object`

##### resources Type

`object` with following properties:

| Property  | Type          | Required | Default     |
| --------- | ------------- | -------- | ----------- |
| `cpus`    | number        | Optional | `1`         |
| `memory`  | string,number | Optional | `"512 MiB"` |
| `storage` | string,number | Optional | `"8 GiB"`   |

#### cpus

A positive integer that defines the number of CPU cores to be used for each running instance of this service.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions. Defaults to 1.

`cpus`

- is optional
- type: `number`
- default: `1`

##### cpus Type

`number`

- minimum value: `1`
- must be a multiple of `1`

#### memory

The amount of RAM to be allocated for each running instance of this service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as MB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 512 MiB.

`memory`

- is optional
- type: multiple
- default: `"512 MiB"`

##### memory Type

Unknown type `string,number`.

```json
{
  "description": "The amount of RAM to be allocated for each running instance of this service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as MB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 512 MiB.",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgG][iI]?[bB]$",
  "default": "512 MiB",
  "simpletype": "multiple"
}
```

#### storage

The amount of disk space to be made available for each running instance of the service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as GiB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 8 GiB

`storage`

- is optional
- type: multiple
- default: `"8 GiB"`

##### storage Type

Unknown type `string,number`.

```json
{
  "description": "The amount of disk space to be made available for each running instance of the service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as GiB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 8 GiB",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgGtT][iI]?[bB]$",
  "default": "8 GiB",
  "simpletype": "multiple"
}
```

#### script

Allows the user to define a custom script to execute as the main container process. When image is specified, this script overrides the startup command specified by the docker image. Conversely if this key is not defined but the image key is present, the startup command defined in the docker image should be used.

The value of this item is a mapping which must either the inline key, or the source_path key.

`script`

- is optional
- type: `object`

##### script Type

`object` with following properties:

| Property      | Type   | Required |
| ------------- | ------ | -------- |
| `inline`      | string | Optional |
| `source-path` | string | Optional |

#### inline

This key allows the user to specify their script inline in the test definition file, observing YAML’s multiline quoting syntax.

This key is required if the source-path key is not specified.

`inline`

- is optional
- type: `string`

##### inline Type

`string`

#### source-path

This key defines a path to a local file which will be executed within the docker container with the shebang interpreter directive observed.

This key is required if the inline key is not specified.

`source-path`

- is optional
- type: `string`

##### source-path Type

`string`

#### sidecar-to

A sequence of service names to which instances of this sidecar should be associated. During a test run, one sidecar container instance will be started per container instance of the service(s) with which it is associated.

`sidecar-to`

- is **required**
- type: `string[]`

##### sidecar-to Type

Array type: `string[]`

All items must be of the type: `string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

## task-runners

An array of definitions for processes that are expected to run and terminate during the course of a test phase. These are usually used to run short-lived tasks that perform some setup step, exercise the system in some way, or monitor the system for the occurrence of some event.

Task runners are defined at the root level of the file, but the tasks key in the test phase definition determines when they are executed, and a single task runner definition may be executed by multiple test phases.

Test phases transition when all tasks defined for a phase have terminated. If any task terminates with a nonzero exit code, the test is considered to have failed.

`task-runners`

- is **required**
- type: `object[]`
- at least `1` items in the array
- defined in this schema

### task-runners Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property       | Type   | Required     |
| -------------- | ------ | ------------ |
| `args`         | array  | Optional     |
| `description`  | string | Optional     |
| `environment`  | object | Optional     |
| `image`        | string | Optional     |
| `input-files`  | array  | Optional     |
| `name`         | string | **Required** |
| `resources`    | object | Optional     |
| `script`       | object | Optional     |

#### args

A sequence of command-line arguments to be passed directly to the service container on startup.

`args`

- is optional
- type: `string[]`\* at least `1` items in the array

##### args Type

Array type: `string[]`

All items must be of the type: `string`

#### description

A short description of the task-runner to be used for display purposes.

`description`

- is optional
- type: `string`

##### description Type

`string`

#### environment

A map of environment variables to be set in the container on startup, where the keys in the map are the environment variable names, and the values are the environment variable values.

`environment`

- is optional
- type: `object`

##### environment Type

`object` with following properties:

| Property | Type | Required |
| -------- | ---- | -------- |


#### image

A string that represents a reference to a docker image and tag that can be used to create processes of this type. This string must be of a format that can be accepted by the docker pull command.

This key is required if the script key is not specified. If image is not specified, the script is run inside of the
latest Ubuntu LTE release docker image.

`image`

- is optional
- type: `string`

##### image Type

`string`

All instances must conform to this regular expression (test examples
[here](<https://regexr.com/?expression=%5E(%3F%3A(%3F%3D%5B%5E%3A%2F%5D%7B4%2C253%7D)(%3F!-)%5Ba-zA-Z0-9-%5D%7B1%2C63%7D(%3F%3C!-)(%3F%3A%5C.(%3F!-)%5Ba-zA-Z0-9-%5D%7B1%2C63%7D(%3F%3C!-))*(%3F%3A%3A%5B0-9%5D%7B1%2C5%7D)%3F%2F)%3F((%3F!%5B._-%5D)(%3F%3A%5Ba-z0-9._-%5D*)(%3F%3C!%5B._-%5D)(%3F%3A%2F(%3F!%5B._-%5D)%5Ba-z0-9._-%5D*(%3F%3C!%5B._-%5D))*)(%3F%3A%3A(%3F!%5B.-%5D)%5Ba-zA-Z0-9_.-%5D%7B1%2C128%7D)%3F%24>)):

```regex
^(?:(?=[^:/]{4,253})(?!-)[a-zA-Z0-9-]{1,63}(?<!-)(?:\.(?!-)[a-zA-Z0-9-]{1,63}(?<!-))*(?::[0-9]{1,5})?/)?((?![._-])(?:[a-z0-9._-]*)(?<![._-])(?:/(?![._-])[a-z0-9._-]*(?<![._-]))*)(?::(?![.-])[a-zA-Z0-9_.-]{1,128})?$
```

#### input-files

A sequence of local files or directories that should be included in the container when it is created.

`input-files`

- is optional
- type: `object[]`

##### input-files Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property           | Type    | Required     |
| ------------------ | ------- | ------------ |
| `destination-path` | string  | **Required** |
| `source-path`      | string  | **Required** |

#### destination-path

The path within the docker container where this file or directory should be placed.

`destination-path`

- is **required**
- type: `string`

##### destination-path Type

`string`

#### source-path

The local path to the file or directory to be included, relative to the directory that contains the test definition
file.

`source-path`

- is **required**
- type: `string`

##### source-path Type

`string`

#### name

A short string used to reference this task-runner when creating tasks in test phases. Also used to identify logging
messages produced by tasks of this type.

`name`

- is **required**
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### resources

A mapping that defines the hardware and network resources available to this process.

`resources`

- is optional
- type: `object`

##### resources Type

`object` with following properties:

| Property  | Type          | Required | Default     |
| --------- | ------------- | -------- | ----------- |
| `cpus`    | number        | Optional | `1`         |
| `memory`  | string,number | Optional | `"512 MiB"` |
| `storage` | string,number | Optional | `"8 GiB"`   |

#### cpus

A positive integer that defines the number of CPU cores to be used for each running instance of this service.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions. Defaults to 1

`cpus`

- is optional
- type: `number`
- default: `1`

##### cpus Type

`number`

- minimum value: `1`
- must be a multiple of `1`

#### memory

The amount of RAM to be allocated for each running instance of this service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as MB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 512 MiB.

`memory`

- is optional
- type: multiple
- default: `"512 MiB"`

##### memory Type

Unknown type `string,number`.

```json
{
  "description": "The amount of RAM to be allocated for each running instance of this service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as MB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 512 MiB.",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgG][iI]?[bB]$",
  "default": "512 MiB",
  "simpletype": "multiple"
}
```

#### storage

The amount of disk space to be made available for each running instance of the service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as GiB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 8 GiB

`storage`

- is optional
- type: multiple
- default: `"8 GiB"`

##### storage Type

Unknown type `string,number`.

```json
{
  "description": "The amount of disk space to be made available for each running instance of the service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as GiB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 8 GiB",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgGtT][iI]?[bB]$",
  "default": "8 GiB",
  "simpletype": "multiple"
}
```

#### script

Allows the user to define a custom script to execute as the main container process. When image is specified, this
script overrides the startup command specified by the docker image. Conversely if this key is not defined but the image
key is present, the startup command defined in the docker image should be used.

The value of this item is a mapping which must either the inline key, or the source_path key.

`script`

- is optional
- type: `object`

##### script Type

`object` with following properties:

| Property      | Type   | Required |
| ------------- | ------ | -------- |
| `inline`      | string | Optional |
| `source-path` | string | Optional |

#### inline

This key allows the user to specify their script inline in the test definition file, observing YAML’s multiline quoting
syntax.

This key is required if the source-path key is not specified.

`inline`

- is optional
- type: `string`

##### inline Type

`string`

#### source-path

This key defines a path to a local file which will be executed within the docker container with the shebang interpreter
directive observed.

This key is required if the inline key is not specified.

`source-path`

- is optional
- type: `string`

##### source-path Type

`string`

## tests

A list of test definitions, with each entry being a map containing a system definition that is composed from the
services defined in the top-level “services” map. Test definitions also contain test phases that declare how the system
composition or underlying hardware resources should be mutated to emulate the scenario under which the user is
exercising their distributed system.

`tests`

- is **required**
- type: `object[]`
- at least `1` items in the array
- defined in this schema

### tests Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property      | Type   | Required     |
| ------------- | ------ | ------------ |
| `description` | string | Optional     |
| `name`        | string | **Required** |
| `phases`      | array  | Optional     |
| `system`      | array  | Optional     |

#### description

A short description of the test being run.

`description`

- is optional
- type: `string`

##### description Type

`string`

#### name

A short name used to identify the test in the UI and for data analysis purposes.

`name`

- is **required**
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### phases

A sequence of test phase definition maps. Test phases define the sequence of events for Genesis to perform when
executing this test.

`phases`

- is optional
- type: `object[]`\* at least `1` items in the array

##### phases Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property      | Type   | Required     |
| ------------- | ------ | ------------ |
| `description` | string | Optional     |
| `name`        | string | **Required** |
| `remove`      | array  | Optional     |
| `system`      | array  | Optional     |
| `tasks`       | array  | **Required** |

#### description

A description of the test phase to be shown in the UI.

`description`

- is optional
- type: `string`

##### description Type

`string`

#### name

A short name that is used to identify the test phase in the UI and data analysis.

`name`

- is **required**
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### remove

A list of service names to remove from the system during this test phase.

`remove`

- is optional
- type: `string[]`\* at least `1` items in the array

##### remove Type

Array type: `string[]`

All items must be of the type: `string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### system

A sequence of service instance maps that are intended to add to, or modify the existing service instance definitions.

If the name specified matches the name of a preexisting service instance, that service instance definition is modified.
If the name does not match an existing service instance definition, the service instance specified here is added to the
system.

When modifying an existing service instance definition, only the name field is required, and only the values of the
keys that are specified are modified. The special value default is permitted to reset the value of the specified key to
its default.

`system`

- is optional
- type: `object[]`\* at least `0` items in the array

##### system Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property        | Type   | Required     |
| --------------- | ------ | ------------ |
| `args`          | array  | Optional     |
| `count`         | number | Optional     |
| `environment`   | object | Optional     |
| `name`          | string | Optional     |
| `port-mappings` | array  | Optional     |
| `resources`     | object | Optional     |
| `sidecars`      | array  | Optional     |
| `type`          | string | **Required** |

#### args

A sequence of command-line arguments to be passed directly to the service container on startup.

`args`

- is optional
- type: `string[]`\* at least `1` items in the array

##### args Type

Array type: `string[]`

All items must be of the type: `string`

#### count

A positive integer that defines the number of instances of the service type to run. If not specified, it will default to 1.

`count`

- is optional
- type: `number`

##### count Type

`number`

- minimum value: `0`
- must be a multiple of `1`

#### environment

A map of environment variables to be set in the container on startup, where the keys in the map are the environment
variable names, and the values are the environment variable values.

`environment`

- is optional
- type: `object`

##### environment Type

`object` with following properties:

| Property | Type | Required |
| -------- | ---- | -------- |


#### name

A name that can be referenced when mutating systems definitions as part of a test phase transition.

If name isn’t specified, the name of the service type is used. This field is required when multiple services instances
exist with the same type.

`name`

- is optional
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### port-mappings

A list of port mapping strings, allowing you to expose ports on which this service listens to the open internet. Must
match the format 'external:internal'

`port-mappings`

- is optional
- type: `string[]`

##### port-mappings Type

Array type: `string[]`

All items must be of the type: `string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9%5D%7B1%2C5%7D%3A%5B0-9%5D%7B1%2C5%7D%24)):

```regex
^[0-9]{1,5}:[0-9]{1,5}$
```

#### resources

A map that defines the system resources available to each instance of the service. If not specified, then the resources
values defined in the services definition are used, if specified. If neither the services definition nor this map are
defined, then default values are used.

`resources`

- is optional
- type: `object`

##### resources Type

`object` with following properties:

| Property   | Type          | Required | Default     |
| ---------- | ------------- | -------- | ----------- |
| `cpus`     | number        | Optional | `1`         |
| `memory`   | string,number | Optional | `"512 MiB"` |
| `networks` | array         | Optional |             |
| `storage`  | string,number | Optional | `"8 GiB"`   |

#### cpus

A positive integer that defines the number of CPU cores to be used for each running instance of this service.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions. Defaults to 1

`cpus`

- is optional
- type: `number`
- default: `1`

##### cpus Type

`number`

- minimum value: `1`
- must be a multiple of `1`

#### memory

The amount of RAM to be allocated for each running instance of this service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as MB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 512 MiB.

`memory`

- is optional
- type: multiple
- default: `"512 MiB"`

##### memory Type

Unknown type `string,number`.

```json
{
  "description": "The amount of RAM to be allocated for each running instance of this service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as MB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 512 MiB.",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgG][iI]?[bB]$",
  "default": "512 MiB",
  "simpletype": "multiple"
}
```

#### networks

A sequence of maps that define the connection of the service to a virtual network via a virtual NIC, where each entry
in the sequence represents a NIC that is connected to one of the virtual networks defined under the networks key of the
top-level system definition.

If no network is defined, then the service is connected to a default network with no impairments. This default network
has a name of 'default'.

`networks`

- is optional
- type: `object[]`\* at least `1` items in the array

##### networks Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property      | Type          | Required     | Default  |
| ------------- | ------------- | ------------ | -------- |
| `bandwidth`   | string,number | Optional     | `"none"` |
| `latency`     | string,number | Optional     |          |
| `name`        | string        | **Required** |          |
| `packet-loss` | string,number | Optional     | `"0%"`   |

#### bandwidth

The maximum data rate that this network connection can support. The suffixes Kbit, Kbyte, Mbit, Mbyte, Gbit, and Gbyte
are observed and are case insensitive. If no suffix is specified, Mbit is assumed.

A value of 0 is equivalent to not allowing any connections on this network.

A value of 'none' means that no limit is enforced.

If not specified, no bandwidth limit is enforced.

`bandwidth`

- is optional
- type: multiple
- default: `"none"`

##### bandwidth Type

Unknown type `string,number`.

```json
{
  "description": "The maximum data rate that this network connection can support. The suffixes Kbit, Kbyte, Mbit, Mbyte, Gbit, and Gbyte are observed and are case insensitive. If no suffix is specified, Mbit is assumed.\n\nA value of 0 is equivalent to not allowing any connections on this network.\n\nA value of 'none' means that no limit is enforced.\n\nIf not specified, no bandwidth limit is enforced.",
  "type": ["string", "number"],
  "minimum": 0,
  "pattern": "^([0-9]+(\\.[0-9]+)? ?([kKmMgG][bB]([yY][tT][eE]|[iI][tT]))?|none)$",
  "default": "none",
  "simpletype": "multiple"
}
```

#### latency

The minimum delay that packets experience before being received by this service instance.

Time suffixes us, ms, and s are observed and are case insensitive. If no suffix is specified, ms is assumed.

Packet delays defined at this level are additive, meaning that a service instance with a latency of 100ms that pings
another service instance with a latency of 50ms will observe a total minimum latency of 150ms.

A value of none or 0 means that no minimum packet delay is enforced.

If not specified, no minimum packet delay is enforced.

`latency`

- is optional
- type: multiple

##### latency Type

Unknown type `string,number`.

```json
{
  "description": "The minimum delay that packets experience before being received by this service instance.\n\nTime suffixes us, ms, and s are observed and are case insensitive. If no suffix is specified, ms is assumed.\n\nPacket delays defined at this level are additive, meaning that a service instance with a latency of 100ms that pings another service instance with a latency of 50ms will observe a total minimum latency of 150ms.\n\nA value of none or 0 means that no minimum packet delay is enforced.\n\nIf not specified, no minimum packet delay is enforced.\n\n",
  "type": ["string", "number"],
  "minimum": 0,
  "pattern": "^([0-9]+(\\.[0-9]+)? ?([uUmM]?[sS])?|none)$",
  "simpletype": "multiple"
}
```

#### name

The name of the network to which the service instance connects.

Network packets can only be routed to machines on the same network. If users wish to have packets routed between
networks they must define a service which handles this capability.

`name`

- is **required**
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### packet-loss

A floating point value representing the percentage of packets that are dropped by the network, ranging from 0 to 100%.

The % suffix is allowed, but not required. It is an error if the value is outside of the range of 0-100%.

Defaults to 0%

`packet-loss`

- is optional
- type: multiple
- default: `"0%"`

##### packet-loss Type

Unknown type `string,number`.

```json
{
  "description": "A floating point value representing the percentage of packets that are dropped by the network, ranging from 0 to 100%.\n\nThe % suffix is allowed, but not required. It is an error if the value is outside of the range of 0-100%.\n\nDefaults to 0%\n\n",
  "type": ["string", "number"],
  "minimum": 0,
  "pattern": "^[0-9]+(\\.[0-9]+)?%?$",
  "default": "0%",
  "simpletype": "multiple"
}
```

#### storage

The amount of disk space to be made available for each running instance of the service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as GiB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 8 GiB

`storage`

- is optional
- type: multiple
- default: `"8 GiB"`

##### storage Type

Unknown type `string,number`.

```json
{
  "description": "The amount of disk space to be made available for each running instance of the service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as GiB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 8 GiB",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgGtT][iI]?[bB]$",
  "default": "8 GiB",
  "simpletype": "multiple"
}
```

#### sidecars

An optional sequence of sidecar instance definitions to be run alongside this service. If this sequence is not
specified, all sidecars defined as running alongside this service will execute. You can optionally override properties
of the original sidecar definition here.

`sidecars`

- is optional
- type: `object[]`\* at least `1` items in the array

##### sidecars Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property      | Type   | Required     |
| ------------- | ------ | ------------ |
| `args`        | array  | Optional     |
| `environment` | object | Optional     |
| `name`        | string | Optional     |
| `resources`   | object | Optional     |
| `type`        | string | **Required** |

#### args

A sequence of command-line arguments to be passed directly to the service container on startup.

`args`

- is optional
- type: `string[]`\* at least `1` items in the array

##### args Type

Array type: `string[]`

All items must be of the type: `string`

#### environment

A map of environment variables to be set in the container on startup, where the keys in the map are the environment
variable names, and the values are the environment variable values.

`environment`

- is optional
- type: `object`

##### environment Type

`object` with following properties:

| Property | Type | Required |
| -------- | ---- | -------- |


#### name

A name that can be referenced when mutating sidecars as part of a test phase transition.

If name isn’t specified, the name of the sidecar type is used by default. This field is required when multiple sidecar
instances exist with the same type.

`name`

- is optional
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### resources

A map that defines the system resources available to the sidecar. If not specified, then the resources values defined
in the original sidecar definition are used. If neither the sidecar definition nor this map are defined, then default
values are used.

`resources`

- is optional
- type: `object`

##### resources Type

`object` with following properties:

| Property  | Type          | Required | Default     |
| --------- | ------------- | -------- | ----------- |
| `cpus`    | number        | Optional | `1`         |
| `memory`  | string,number | Optional | `"512 MiB"` |
| `storage` | string,number | Optional | `"8 GiB"`   |

#### cpus

A positive integer that defines the number of CPU cores to be used for each running instance of this service.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions. Defaults to 1

`cpus`

- is optional
- type: `number`
- default: `1`

##### cpus Type

`number`

- minimum value: `1`
- must be a multiple of `1`

#### memory

The amount of RAM to be allocated for each running instance of this service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as MB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 512 MiB.

`memory`

- is optional
- type: multiple
- default: `"512 MiB"`

##### memory Type

Unknown type `string,number`.

```json
{
  "description": "The amount of RAM to be allocated for each running instance of this service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as MB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 512 MiB.",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgG][iI]?[bB]$",
  "default": "512 MiB",
  "simpletype": "multiple"
}
```

#### storage

The amount of disk space to be made available for each running instance of the service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as GiB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 8 GiB

`storage`

- is optional
- type: multiple
- default: `"8 GiB"`

##### storage Type

Unknown type `string,number`.

```json
{
  "description": "The amount of disk space to be made available for each running instance of the service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as GiB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 8 GiB",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgGtT][iI]?[bB]$",
  "default": "8 GiB",
  "simpletype": "multiple"
}
```

#### type

The type of sidecar that you'd like to include/modify alongside this service instance, must match the name of a sidecar
definition from the root level of the document.

`type`

- is **required**
- type: `string`

##### type Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### type

A string that must match to the name of one of the services defined in the root-level services definition. Used to
identify which type of service you want to run.

`type`

- is **required**
- type: `string`

##### type Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### tasks

A sequence of tasks to run during this test phase, as defined by the task-runners key at the root level of the
document. Test phases don't complete until all tasks have finished running, and nonzero task exit codes are used to
terminate the test with a failure status.

`tasks`

- is **required**
- type: `object[]`\* at least `1` items in the array

##### tasks Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property           | Type          | Required     | Default |
| ------------------ | ------------- | ------------ | ------- |
| `args`             | array         | Optional     |         |
| `description`      | string        | Optional     |         |
| `environment`      | object        | Optional     |         |
| `ignore-exit-code` | boolean       | Optional     | `false` |
| `timeout`          | string,number | Optional     | `"2m"`  |
| `type`             | string        | **Required** |         |

#### args

A sequence of command-line arguments to be passed directly to the service container on startup.

`args`

- is optional
- type: `string[]`\* at least `1` items in the array

##### args Type

Array type: `string[]`

All items must be of the type: `string`

#### description

An optional textual description of the task to be run, used for display purposes.

`description`

- is optional
- type: `string`

##### description Type

`string`

#### environment

A map of environment variables to be set in the container on startup, where the keys in the map are the environment
variable names, and the values are the environment variable values.

`environment`

- is optional
- type: `object`

##### environment Type

`object` with following properties:

| Property | Type | Required |
| -------- | ---- | -------- |


#### ignore-exit-code

A boolean value that specifies that the success of this task is not necessary for the test to pass. In other words,
when this value is true, nonzero exit codes from this task do not cause the test to fail.

Defaults to false.

`ignore-exit-code`

- is optional
- type: `boolean`
- default: `false`

##### ignore-exit-code Type

`boolean`

#### timeout

A floating point value that specifies how long this task may execute before it should be killed by the test execution
system. This value accepts the case-insensitive suffixes ms, s, and m. If no suffix is specified, it’s expected that
the value is specified in seconds.

A zero value indicates that no timeout should be enforced for this task.

Defaults to 2 minutes.

`timeout`

- is optional
- type: multiple
- default: `"2m"`

##### timeout Type

Unknown type `string,number`.

```json
{
  "description": "A floating point value that specifies how long this task may execute before it should be killed by the test execution system. This value accepts the case-insensitive suffixes ms, s, and m. If no suffix is specified, it’s expected that the value is specified in seconds.\n\nA zero value indicates that no timeout should be enforced for this task.\n\nDefaults to 2 minutes.",
  "type": ["string", "number"],
  "pattern": "^[0-9]+(\\.[0-9]+)? ?([mM]?[sS]|[mM])?$",
  "minimum": 0,
  "default": "2m",
  "simpletype": "multiple"
}
```

#### type

The type of Task Runner to execute, to be taken from the set of of Task Runner names defined under the root-level
task-runner field.

`type`

- is **required**
- type: `string`

##### type Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### system

An array that provides a definition for the distributed system under test.

`system`

- is optional
- type: `object[]`

##### system Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property        | Type   | Required     |
| --------------- | ------ | ------------ |
| `args`          | array  | Optional     |
| `count`         | number | Optional     |
| `environment`   | object | Optional     |
| `name`          | string | Optional     |
| `port-mappings` | array  | Optional     |
| `resources`     | object | Optional     |
| `sidecars`      | array  | Optional     |
| `type`          | string | **Required** |

#### args

A sequence of command-line arguments to be passed directly to the service container on startup.

`args`

- is optional
- type: `string[]`\* at least `1` items in the array

##### args Type

Array type: `string[]`

All items must be of the type: `string`

#### count

A positive integer that defines the number of instances of the service type to run.

`count`

- is optional
- type: `number`

##### count Type

`number`

- minimum value: `0`
- must be a multiple of `1`

#### environment

A map of environment variables to be set in the container on startup, where the keys in the map are the environment
variable names, and the values are the environment variable values.

`environment`

- is optional
- type: `object`

##### environment Type

`object` with following properties:

| Property | Type | Required |
| -------- | ---- | -------- |


#### name

A name that can be referenced when mutating systems definitions as part of a test phase transition.

If name isn’t specified, the name of the service type is used. This field is required when multiple services instances
exist with the same type.

`name`

- is optional
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### port-mappings

A list of port mapping strings, allowing you to expose ports on which this service listens to the open internet. Must
match the format 'external:internal'

`port-mappings`

- is optional
- type: `string[]`

##### port-mappings Type

Array type: `string[]`

All items must be of the type: `string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9%5D%7B1%2C5%7D%3A%5B0-9%5D%7B1%2C5%7D%24)):

```regex
^[0-9]{1,5}:[0-9]{1,5}$
```

#### resources

A map that defines the system resources available to each instance of the service. If not specified, then the resources
values defined in the services definition are used, if specified. If neither the services definition nor this map are
defined, then default values are used.

`resources`

- is optional
- type: `object`

##### resources Type

`object` with following properties:

| Property   | Type          | Required | Default     |
| ---------- | ------------- | -------- | ----------- |
| `cpus`     | number        | Optional | `1`         |
| `memory`   | string,number | Optional | `"512 MiB"` |
| `networks` | array         | Optional |             |
| `storage`  | string,number | Optional | `"8 GiB"`   |

#### cpus

A positive integer that defines the number of CPU cores to be used for each running instance of this service.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions. Defaults to 1

`cpus`

- is optional
- type: `number`
- default: `1`

##### cpus Type

`number`

- minimum value: `1`
- must be a multiple of `1`

#### memory

The amount of RAM to be allocated for each running instance of this service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as MB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 512 MiB.

`memory`

- is optional
- type: multiple
- default: `"512 MiB"`

##### memory Type

Unknown type `string,number`.

```json
{
  "description": "The amount of RAM to be allocated for each running instance of this service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as MB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 512 MiB.",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgG][iI]?[bB]$",
  "default": "512 MiB",
  "simpletype": "multiple"
}
```

#### networks

A sequence of maps that define the connection of the service to a virtual network via a virtual NIC, where each entry
in the sequence represents a NIC that is connected to one of the virtual networks defined under the networks key of the
top-level system definition.

If no network is defined, then the service is connected to a default network with no impairments. This default network
has a name of 'default'.

`networks`

- is optional
- type: `object[]`\* at least `1` items in the array

##### networks Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property      | Type          | Required     | Default  |
| ------------- | ------------- | ------------ | -------- |
| `bandwidth`   | string,number | Optional     | `"none"` |
| `latency`     | string,number | Optional     |          |
| `name`        | string        | **Required** |          |
| `packet-loss` | string,number | Optional     | `"0%"`   |

#### bandwidth

The maximum data rate that this network connection can support. The suffixes Kbit, Kbyte, Mbit, Mbyte, Gbit, and Gbyte
are observed and are case insensitive. If no suffix is specified, Mbit is assumed.

A value of 0 is equivalent to not allowing any connections on this network.

A value of 'none' means that no limit is enforced.

If not specified, no bandwidth limit is enforced.

`bandwidth`

- is optional
- type: multiple
- default: `"none"`

##### bandwidth Type

Unknown type `string,number`.

```json
{
  "description": "The maximum data rate that this network connection can support. The suffixes Kbit, Kbyte, Mbit, Mbyte, Gbit, and Gbyte are observed and are case insensitive. If no suffix is specified, Mbit is assumed.\n\nA value of 0 is equivalent to not allowing any connections on this network.\n\nA value of 'none' means that no limit is enforced.\n\nIf not specified, no bandwidth limit is enforced.",
  "type": ["string", "number"],
  "minimum": 0,
  "pattern": "^([0-9]+(\\.[0-9]+)? ?([kKmMgG][bB]([yY][tT][eE]|[iI][tT]))?|none)$",
  "default": "none",
  "simpletype": "multiple"
}
```

#### latency

The minimum delay that packets experience before being received by this service instance.

Time suffixes us, ms, and s are observed and are case insensitive. If no suffix is specified, ms is assumed.

Packet delays defined at this level are additive, meaning that a service instance with a latency of 100ms that pings
another service instance with a latency of 50ms will observe a total minimum latency of 150ms.

A value of none or 0 means that no minimum packet delay is enforced.

If not specified, no minimum packet delay is enforced.

`latency`

- is optional
- type: multiple

##### latency Type

Unknown type `string,number`.

```json
{
  "description": "The minimum delay that packets experience before being received by this service instance.\n\nTime suffixes us, ms, and s are observed and are case insensitive. If no suffix is specified, ms is assumed.\n\nPacket delays defined at this level are additive, meaning that a service instance with a latency of 100ms that pings another service instance with a latency of 50ms will observe a total minimum latency of 150ms.\n\nA value of none or 0 means that no minimum packet delay is enforced.\n\nIf not specified, no minimum packet delay is enforced.\n\n",
  "type": ["string", "number"],
  "minimum": 0,
  "pattern": "^([0-9]+(\\.[0-9]+)? ?([uUmM]?[sS])?|none)$",
  "simpletype": "multiple"
}
```

#### name

The name of the network to which the service instance connects.

Network packets can only be routed to machines on the same network. If users wish to have packets routed between
networks they must define a service which handles this capability.

`name`

- is **required**
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### packet-loss

A floating point value representing the percentage of packets that are dropped by the network, ranging from 0 to 100%.

The % suffix is allowed, but not required. It is an error if the value is outside of the range of 0-100%.

Defaults to 0%

`packet-loss`

- is optional
- type: multiple
- default: `"0%"`

##### packet-loss Type

Unknown type `string,number`.

```json
{
  "description": "A floating point value representing the percentage of packets that are dropped by the network, ranging from 0 to 100%.\n\nThe % suffix is allowed, but not required. It is an error if the value is outside of the range of 0-100%.\n\nDefaults to 0%\n\n",
  "type": ["string", "number"],
  "minimum": 0,
  "pattern": "^[0-9]+(\\.[0-9]+)?%?$",
  "default": "0%",
  "simpletype": "multiple"
}
```

#### storage

The amount of disk space to be made available for each running instance of the service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as GiB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 8 GiB

`storage`

- is optional
- type: multiple
- default: `"8 GiB"`

##### storage Type

Unknown type `string,number`.

```json
{
  "description": "The amount of disk space to be made available for each running instance of the service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as GiB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 8 GiB",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgGtT][iI]?[bB]$",
  "default": "8 GiB",
  "simpletype": "multiple"
}
```

#### sidecars

An optional sequence of sidecar instance definitions to be run alongside this service. If this sequence is not
specified, all sidecars defined as running alongside this service will execute. You can optionally override properties
of the original sidecar definition here.

`sidecars`

- is optional
- type: `object[]`\* at least `1` items in the array

##### sidecars Type

Array type: `object[]`

All items must be of the type: `object` with following properties:

| Property      | Type   | Required     |
| ------------- | ------ | ------------ |
| `args`        | array  | Optional     |
| `environment` | object | Optional     |
| `name`        | string | Optional     |
| `resources`   | object | Optional     |
| `type`        | string | **Required** |

#### args

A sequence of command-line arguments to be passed directly to the service container on startup.

`args`

- is optional
- type: `string[]`\* at least `1` items in the array

##### args Type

Array type: `string[]`

All items must be of the type: `string`

#### environment

A map of environment variables to be set in the container on startup, where the keys in the map are the environment
variable names, and the values are the environment variable values.

`environment`

- is optional
- type: `object`

##### environment Type

`object` with following properties:

| Property | Type | Required |
| -------- | ---- | -------- |


#### name

A name that can be referenced when mutating sidecars as part of a test phase transition.

If name isn’t specified, the name of the sidecar type is used by default. This field is required when multiple sidecar
instances exist with the same type.

`name`

- is optional
- type: `string`

##### name Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### resources

A map that defines the system resources available to the sidecar. If not specified, then the resources values defined
in the original sidecar definition are used. If neither the sidecar definition nor this map are defined, then default
values are used.

`resources`

- is optional
- type: `object`

##### resources Type

`object` with following properties:

| Property  | Type          | Required | Default     |
| --------- | ------------- | -------- | ----------- |
| `cpus`    | number        | Optional | `1`         |
| `memory`  | string,number | Optional | `"512 MiB"` |
| `storage` | string,number | Optional | `"8 GiB"`   |

#### cpus

A positive integer that defines the number of CPU cores to be used for each running instance of this service.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions. Defaults to 1

`cpus`

- is optional
- type: `number`
- default: `1`

##### cpus Type

`number`

- minimum value: `1`
- must be a multiple of `1`

#### memory

The amount of RAM to be allocated for each running instance of this service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as MB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 512 MiB.

`memory`

- is optional
- type: multiple
- default: `"512 MiB"`

##### memory Type

Unknown type `string,number`.

```json
{
  "description": "The amount of RAM to be allocated for each running instance of this service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as MB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 512 MiB.",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgG][iI]?[bB]$",
  "default": "512 MiB",
  "simpletype": "multiple"
}
```

#### storage

The amount of disk space to be made available for each running instance of the service.

Size suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to
be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is
interpreted as GiB if no suffix is used.

Note that when this value is defined at the test phase level it overrides the value specified at the test level, and
similarly when specified at the test level it overrides the value specified in the root level
service/sidecar/task-runner definitions.

Defaults to 8 GiB

`storage`

- is optional
- type: multiple
- default: `"8 GiB"`

##### storage Type

Unknown type `string,number`.

```json
{
  "description": "The amount of disk space to be made available for each running instance of the service.\n\nSize suffixes KB, KiB, MB, MiB, GB, GiB, TB, and TiB are observed and are case insensitive. All suffixed values are to be interpreted as “power of twos” sizes (e.g. 5MB is equivalent to 5MiB by a strict definition of MiB). Value is interpreted as GiB if no suffix is used.\n\nNote that when this value is defined at the test phase level it overrides the value specified at the test level, and similarly when specified at the test level it overrides the value specified in the root level service/sidecar/task-runner definitions.\n\nDefaults to 8 GiB",
  "type": ["string", "number"],
  "minimum": 1,
  "pattern": "^[0-9]+ ?[kKmMgGtT][iI]?[bB]$",
  "default": "8 GiB",
  "simpletype": "multiple"
}
```

#### type

The type of sidecar that you'd like to include/modify alongside this service instance, must match the name of a sidecar
definition from the root level of the document.

`type`

- is **required**
- type: `string`

##### type Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```

#### type

A string that must match to the name of one of the services defined in the root-level services definition. Used to
identify which type of service you want to run.

`type`

- is **required**
- type: `string`

##### type Type

`string`

All instances must conform to this regular expression (test examples
[here](https://regexr.com/?expression=%5E%5B0-9a-zA-Z-_%5C.%5D%2B%24)):

```regex
^[0-9a-zA-Z-_\.]+$
```
