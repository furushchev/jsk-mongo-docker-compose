#!/bin/bash

MONGO1=$(getent hosts mongo1 | head -1 | awk '{print $1}')
MONGO2=$(getent hosts mongo2 | head -1 | awk '{print $1}')
ELASTIC=$(getent hosts elasticsearch | head -1 | awk '{print $1}')

/scripts/wait-mongo-elastic.sh

echo "Test: write to mongo"
mongo ${MONGO1} <<EOF
  use test
  rs.config()
  var p = { message: "hi" }
  db.test.save(p)
EOF

echo "Test: read from mongo"
curl "http://${MONGO1}:28017/test/test/?limit=10"

echo "Waiting for transporter"
sleep 40
curl -XGET "http://${ELASTIC}:9200/test/_search?pretty&q=*:*"

echo "Done"
