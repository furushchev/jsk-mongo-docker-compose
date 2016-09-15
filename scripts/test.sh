#!/bin/bash

MONGO1=$(getent hosts mongo1 | head -1 | awk '{print $1}')
MONGO2=$(getent hosts mongo2 | head -1 | awk '{print $1}')
ELASTIC=$(getent hosts elasticsearch | head -1 | awk '{print $1}')

/scripts/wait-mongo-elastic.sh

echo "Test: write to mongo"
mongo ${MONGO1}:27018 <<EOF
  use jsk_robot_lifelog
  rs.config()
  var p = { message: "hi" }
  db.pr1012.save(p)
EOF

echo "Test: read from mongo"
curl "http://${MONGO1}:28018/jsk_robot_lifelog/pr1012/?limit=10"

echo "Waiting for transporter"
sleep 40
echo "Test: read from elasticsearch"
curl -XGET "http://${ELASTIC}:9200/jsk_robot_lifelog/_search?pretty&q=*:*"

echo "Done"
