
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB lock escalation conflicts.
---

This incident type refers to situations where MongoDB database experiences lock escalation conflicts. MongoDB uses locks to control concurrent access to the database. When the number of locks held by a process reaches a certain threshold, the process may escalate its locks to a higher level, which can cause conflicts with other processes. These conflicts can result in performance degradation and even system crashes. Resolving this incident requires identifying the root cause of the lock escalation conflicts and implementing appropriate measures such as optimizing database queries, increasing the available system resources, or adjusting the MongoDB lock settings.

### Parameters
```shell
export MONGODB_HOST="PLACEHOLDER"

export MONGODB_PORT="PLACEHOLDER"

export MONGODB_USER="PLACEHOLDER"

export MONGODB_PASSWORD="PLACEHOLDER"

export MAX_CONNECTIONS="PLACEHOLDER"

export BATCH_SIZE="PLACEHOLDER"
```

## Debug

### Check if MongoDB is running
```shell
systemctl status mongod
```

### Check if MongoDB is stuck or unresponsive
```shell
mongo --eval "db.stats()"
```

### Check if there are any lock escalations
```shell
mongo --eval "db.currentOp({'active': true, 'waitingForLock': true})"
```

### Check if there are any active transactions
```shell
mongo --eval "db.currentOp({'active': true, 'waitingForLock': false, 'txnNumber': {\$gt: 0}})"
```

### Check if there are any blocked transactions
```shell
mongo --eval "db.currentOp({'active': true, 'waitingForLock': true, 'txnNumber': {\$gt: 0}})"
```

### Check the MongoDB log for any errors or warnings
```shell
tail -n 50 /var/log/mongodb/mongod.log
```

## Repair

### Increase the number of available connections to the MongoDB server and optimize the queries to reduce contention and reduce the likelihood of lock escalation conflicts.
```shell


#!/bin/bash



# Set MongoDB connection parameters

MONGODB_HOST=${MONGODB_HOST}

MONGODB_PORT=${MONGODB_PORT}

MONGODB_USER=${MONGODB_USER}

MONGODB_PASSWORD=${MONGODB_PASSWORD}



# Increase the number of available connections to the MongoDB server

mongo --host $MONGODB_HOST --port $MONGODB_PORT --username $MONGODB_USER --password $MONGODB_PASSWORD --eval "db.adminCommand({ setParameter: 1, maxIncomingConnections: ${MAX_CONNECTIONS} })"



# Optimize the MongoDB queries to reduce contention

mongo --host $MONGODB_HOST --port $MONGODB_PORT --username $MONGODB_USER --password $MONGODB_PASSWORD --eval "db.adminCommand({ setParameter: 1, queryExecutorBatchSize: ${BATCH_SIZE} })"


```

### Configure MongoDB to use lock escalation sparingly or disable it altogether if it is causing too many conflicts.
```shell


#!/bin/bash



# Stop the MongoDB service

sudo service mongodb stop



# Backup the MongoDB configuration file

sudo cp /etc/mongod.conf /etc/mongod.conf.bak



# Edit the MongoDB configuration file to disable lock escalation

sudo sed -i 's/#operationProfiling:/operationProfiling:\n  slowOpThresholdMs: 1000\n  mode: off\n  slowOpSampleRate: 0.1/' /etc/mongod.conf



# Start the MongoDB service

sudo service mongodb start



echo "MongoDB lock escalation has been disabled."


```