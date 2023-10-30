

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