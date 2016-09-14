#!/bin/bash

MONGODB1=$(getent hosts mongo1 | awk '{print $1}')
MONGODB2=$(getent hosts mongo2 | awk '{print $2}')

echo "Waiting for startup mongodb server..."
until curl "http://${MONGODB1}:28017/serverstatus?text=1" 2>&1 | grep uptime | head -1; do
    printf '.'
    sleep 1
done

echo "Started"

echo "Initializing database servers..."
mongo --host ${MONGODB1}:27017 <<EOF
  var cfg = {
    "_id": "rs1",
    "version": 1,
    "members": [
      { "_id": 0,
        "host": "${MONGODB1}:27017"
        "priority": 2
      },
      { "_id": 1,
        "host": "${MONGODB2}:27017"
        "priority": 0
      }
    ]
  };
  rs.initiate(cfg, { force: true });
  rs.reconfig(cfg, { force: true });
EOF
