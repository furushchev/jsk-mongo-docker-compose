#!/bin/bash

MONGO1=$(getent hosts mongo1 | awk '{print $1}') 
ELASTIC=$(getent hosts elasticsearch | awk '{print $1}')

echo "Waiting for mongo"
until curl "http://${MONGO1}:28017/isMaster?text=1" 2>&1 | grep ismaster | grep true; do
    printf '.'
    sleep 1
done

echo "Waiting for elasticsearch"
until curl "${ELASTIC}:9200/_cluster/health?pretty" 2>&1 | grep status | grep -E "(green|yellow)"; do
    printf '.'
    sleep 1
done
