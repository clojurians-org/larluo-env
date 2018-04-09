#!/bin/sh

if [ -e /store/share/ifconfig.out ]; then
    echo "$SERVERS" | tr ',' '\n' | egrep -n $(cat /store/share/ifconfig.out | awk '/inet addr/{print substr($2,6)}' | tr '\n' '|' | sed 's/.$//g') | grep "$PORT" | cut -d: -f1 > /store/zookeeper/$MY_SERVER/myid
fi

# based on https://github.com/apache/zookeeper/blob/trunk/conf/zoo_sample.cfg
CLIENT_PORT=$(echo "$PORT" | cut -d: -f1)
tee zookeeper/conf/zoo.cfg <<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/store/zookeeper
clientPort=$CLIENT_PORT
EOF

# server.1=...
if [ -n "$SERVERS" ]; then
    printf '%s' "$SERVERS" | awk 'BEGIN { RS = "," }; { split($0,a,":"); printf "server.%i=%s:%s:%s\n", NR, a[1], a[3], a[4]}' >> zookeeper/conf/zoo.cfg
fi

if [ "$1" = "-d" ]; then
  zookeeper/bin/zkServer.sh start-foreground
else
  exec $@
fi
