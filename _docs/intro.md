---
title: Introduction
tags: []
permalink: /
order: 1
---

## An End-To-End Testing & Development Platform For Distributed Systems

Whiteblock Genesis is the only fully automated platform that helps development teams quickly design and run end-to-end distributed systems tests. Whiteblock Genesis is here to accelerate your testing process to maturity.

The following sections include helpful user guides for creating an account, setting up Genesis, running your first tests, reviewing test results on the Genesis Dashboard, and more. 


Use the sidebar to navigate Genesis topics.

## Getting Started

Whiteblock Genesis enables you to test real-world scenarios on full-scale distributed systems. With Genesis you can define, run, and analyze an end-to-end test in just a few minutes.

**TLDR**: view the [Quick Start](/quick_start.html) tutorial and run a test now!

### Define

The Genesis platform allows you to build distributed systems to test within a private, controlled environment.  You define this environment and the tests running within it by writing YAML files that follow our simple, declarative YAML [test definition file format](/defining_tests.html).  Our only requirement for your software is that it can be deployed from a [Docker image](https://docs.docker.com/develop/) or a script that can run within a Docker container.

### Run

[Execute your tests](/running_tests.html) in a single command with the [Whiteblock Genesis CLI](https://www.github.com/whiteblock/genesis-cli), or by uploading your test definition files directly from the Whiteblock Genesis Dashboard. The Whiteblock Genesis dashboard will display previous test runs, queued tests, and the results and data output from tests that you've executed in the past. For the console warriors out there, this information is also available via the Whiteblock Genesis CLI.

### Analyze

Sometimes a simple pass or fail result isn't good enough and you need to dive into the finer details of what happened while your test was running.  Fortunately, Whiteblock Genesis includes a robust, high-throughput [data collection and analysis pipeline](/analyzing_test_data.html) that gives you complete visibility into the behavior of your systems. Outputting data to collect for later analysis is as simple as writing a JSON object to stdout. You can review the data we collect from each test on the test details page in the dashboard, build your own metrics and analytics dashboards with Kibana, and write your own custom data analysis and reports using Jupyter Notebooks.
