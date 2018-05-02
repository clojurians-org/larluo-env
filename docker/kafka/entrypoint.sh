#!/bin/sh

if [ ! -e /store/share/ifconfig.out ]; then
  echo "[ERROR]: /store/share/ifconfig.out not exist!"
  exit 1
fi

ID_IP_PORT=$(echo "$SERVERS" | tr ',' '\n' | egrep -n $(cat /store/share/ifconfig.out | awk '/inet addr/{print substr($2,6)}' | tr '\n' '|' | sed 's/.$//g') | grep "$PORT")
MY_ID=$(echo $ID_IP_PORT | cut -d: -f1)
MY_IP=$(echo $ID_IP_PORT | cut -d: -f2)

# based on https://github.com/apache/zookeeper/blob/trunk/conf/zoo_sample.cfg
rm kafka/config/server.properties
tee kafka/config/server.properties <<EOF
zookeeper.connect=$ZK_URL
broker.id=$MY_ID
listeners=PLAINTEXT://0.0.0.0:$PORT
advertised.listeners=PLAINTEXT://$MY_IP:$PORT
log.dir=/store/kafka
log.retention.hours=48
EOF

if [ "$1" = "-d" ]; then
  kafka/bin/kafka-server-start.sh kafka/config/server.properties
else
  exec $@
fi
