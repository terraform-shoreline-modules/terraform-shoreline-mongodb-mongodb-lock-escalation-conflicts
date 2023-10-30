

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