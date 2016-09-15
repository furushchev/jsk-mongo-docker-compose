#!/bin/bash

#MONGO=$(getent hosts mongo1 | head -1 | awk '{ print $1 }')
#ES=$(getent hosts elasticsearch | awk '{print $1}')

cd $GOPATH
mkdir pkg
git clone https://github.com/compose/transporter src/github.com/compose/transporter
(cd src/github.com/compose/transporter && git checkout tags/v0.1.0)

go get github.com/tools/godep
godep restore
godep go build ./cmd/...
godep go install ./cmd/...

/scripts/wait-mongo-elastic.sh

cd /transporter
transporter run --config ./config.yaml ./mongo-elastic.js


