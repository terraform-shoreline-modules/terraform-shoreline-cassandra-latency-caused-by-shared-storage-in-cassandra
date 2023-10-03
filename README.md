
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Latency Caused by Shared Storage in Cassandra
---

This incident type refers to a situation where a delay or slowness occurs in a system that uses Cassandra database due to the shared storage. Shared storage means multiple servers are accessing the same storage unit, and this can cause latency issues. This type of incident can lead to performance degradation, and it needs to be addressed promptly to ensure optimal system performance.

### Parameters
```shell
export SHARED_STORAGE="PLACEHOLDER"

export CASSANDRA_NODE1="PLACEHOLDER"

export CASSANDRA_NODE2="PLACEHOLDER"

export CASSANDRA_NODE="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"

export SHARED_STORAGE_PATH="PLACEHOLDER"

export NEW_STORAGE_PATH="PLACEHOLDER"
```

## Debug

### Check if Cassandra is running
```shell
systemctl status cassandra
```

### Check for any errors in Cassandra logs
```shell
tail -f /var/log/cassandra/system.log
```

### Check the Cassandra cluster status
```shell
nodetool status
```

### Check the status of the shared storage
```shell
df -h ${SHARED_STORAGE}
```

### Check the network latency between Cassandra nodes
```shell
ping ${CASSANDRA_NODE1}

ping ${CASSANDRA_NODE2}
```

### Check the read/write latency of Cassandra using cqlsh
```shell
cqlsh ${CASSANDRA_NODE} -e "SELECT * FROM ${TABLE_NAME} LIMIT 10;"
```

## Repair

### Split the shared storage into separate storage units to reduce contention for resources. It is recommended to avoid shared storage like EBS, SAN, NAS. Shared storage degrades performance and creates a single point of failure.
```shell
bash

#!/bin/bash



# Define the variables

${SHARED_STORAGE_PATH}="/path/to/shared/storage"

${NEW_STORAGE_PATH}="/path/to/new/storage"



# Stop the Cassandra service

sudo systemctl stop cassandra



# Copy the shared storage to the new storage location

sudo cp -r $SHARED_STORAGE_PATH/* $NEW_STORAGE_PATH/



# Modify the Cassandra configuration to use the new storage location

sudo sed -i "s|$SHARED_STORAGE_PATH|$NEW_STORAGE_PATH|g" /etc/cassandra/cassandra.yaml



# Start the Cassandra service

sudo systemctl start cassandra


```