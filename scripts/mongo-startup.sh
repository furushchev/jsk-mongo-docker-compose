#!/bin/bash

if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
   echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
   echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi    

# run mongod
/usr/bin/mongod --replSet rs1 --shardsvr --dbpath /db --journal --directoryperdb --rest --httpinterface --port 27017
