#!/bin/bash
# Modified but from:
#   https://github.com/yeasy/docker-compose-files/blob/master/mongo_cluster/scripts/mongosetup.sh

echo "Waiting for startup..."
until curl http://member1:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

echo curl http://member1:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1
echo "Started. Waiting 10 seconds before initializing the replica set..."

sleep 10

echo SETUP.sh time now: `date +"%T" `
mongo --host member1:27017 <<EOF
   var cfg = {
        "_id": "replset1",
        "version": 1,
        "members": [
            {
                "_id": 0,
                "host": "member1:27017",
                "priority": 2
            },
            {
                "_id": 1,
                "host": "member2:27017",
                "priority": 0
            },
            {
                "_id": 2,
                "host": "member3:27017",
                "priority": 0
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    rs.reconfig(cfg, { force: true });
    db.getMongo().setReadPref('nearest');
EOF

echo "***READY***"

tail -f /dev/null