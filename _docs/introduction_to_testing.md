---
title: Introduction to Testing Distributed Systems
tags: []
author: whiteblock
permalink: /introduction_to_testing
---
# Testing Distributed Systems
The following are types of tests one can perform on a distributed system: 

* **Functional Testing** is conducted to test whether a system performs as it was specified or in accordance with formal requirements
* **Performance Testing** tests the reliability and responsiveness of a system under different types of conditions and scenarios
* **Penetration Testing** tests the system for security vulnerabilities
* **End-to-End Testing** is used to determine whether a system’s process flow functions as expected
* **Fuzzing** is used to test how a system responds to unexpected, random, or invalid data or inputs


Genesis is a versatile testing platform designed to automate the tests listed above, making it faster and simpler to conduct them on distributed systems where it was traditionally difficult to do so. Where Performance, End-to-End, and Functional testing comprise the meat of Genesis’ services, other types of testing are enabled through the deployment of services and sidecars on the platform.


End-to-End tests can be designed by applying exit code checks for process completion, success, or failure in tasks and phases, while Performance tests can be conducted by analyzing data from tests on Genesis that apply a variety of network conditions and combinations thereof. Functional tests can use a combination of tasks, phases, supplemental services and sidecars, and network conditions, among other tools. 


These processes and tools are further described in this documentation.