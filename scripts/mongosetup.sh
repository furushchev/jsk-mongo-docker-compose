#!/bin/bash

MONGO1=$(getent hosts mongo1 | head -1 | awk '{print $1}')
MONGO2=$(getent hosts mongo2 | head -1 | awk '{print $1}')

echo "Waiting for startup mongodb server [${MONGO1}]"
until curl "http://${MONGO1}:28017/serverstatus?text=1" 2>&1 | grep uptime | head -1; do
    printf '.'
    sleep 1
done
echo "Started"
echo "Waiting for startup mongodb server [${MONGO2}]"
until curl "http://${MONGO2}:28017/serverstatus?text=1" 2>&1 | grep uptime | head -1; do
    printf '.'
    sleep 1
done
echo "Started"

echo "Initializing database servers..."
mongo --host ${MONGO1}:27017 <<EOF
  var cfg = {
    "_id": "rs1",
    "version": 1,
    "members": [
      { "_id": 0,
        "host": "${MONGO1}:27017"
      },
      { "_id": 1,
        "host": "${MONGO2}:27017"
      }
    ]
  };
  rs.initiate(cfg, { force: true });
  rs.reconfig(cfg, { force: true });
  rs.status();
EOF
