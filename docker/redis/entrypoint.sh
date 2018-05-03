#!/bin/sh

if [ ! -e /store/share/ifconfig.out ]; then
  echo "[ERROR]: /store/share/ifconfig.out not exist!"
  exit 1
fi

ID_IP_PORT=$(echo "$SERVERS" | tr ',' '\n' | egrep -n $(cat /store/share/ifconfig.out | awk '/inet addr/{print substr($2,6)}' | tr '\n' '|' | sed 's/.$//g') | grep "$PORT")
MY_ID=$(echo $ID_IP_PORT | cut -d: -f1)
MY_IP=$(echo $ID_IP_PORT | cut -d: -f2)

# based on https://github.com/apache/zookeeper/blob/trunk/conf/zoo_sample.cfg
tee redis.conf <<EOF
port $PORT
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
bind 0.0.0.0
EOF

if [ "$1" = "-d" ]; then
  redis/bin/redis-server redis.conf
else
  exec $@
fi
