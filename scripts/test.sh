#!/bin/bash

function error(){
    echo "Test exited with failure."
    for f in `ls /tmp/*_test_result`; do
	echo "=============================================="
	echo "cat $f"
	cat $f
	echo "=============================================="
    done
    trap - ERR
    exit 1
}
trap error ERR

MONGO1=$(getent hosts mongo1 | head -1 | awk '{print $1}')
MONGO2=$(getent hosts mongo2 | head -1 | awk '{print $1}')
ELASTIC=$(getent hosts elasticsearch | head -1 | awk '{print $1}')

/scripts/wait-mongo-elastic.sh

echo "Test: write to mongo"
mongo ${MONGO1} > /tmp/write_test_result <<EOF
  use jsk_robot_lifelog
  rs.config()
  var p = { message: "hi" }
  db.pr1012.save(p)
EOF
cat /tmp/write_test_result | grep "\"nInserted\" : 1"

echo "Test: read from mongo"
curl "http://${MONGO1}:28017/jsk_robot_lifelog/pr1012/?limit=10" > /tmp/read_test_result
cat /tmp/read_test_result  | grep "\"message\" : \"hi\""

echo "Waiting for transporter"
sleep 40
echo "Test: read from elasticsearch"
curl -XGET "http://${ELASTIC}:9200/jsk_robot_lifelog/_search?pretty&q=*:*" > /tmp/elastic_test_result
cat /tmp/elastic_test_result | grep "\"timed_out\" : false"

echo "Done All Tests."
exit 0
