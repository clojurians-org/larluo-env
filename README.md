```sh
# sudo systemctl stop firewalld
# :colorscheme desert 
  mkdir -p opt

#--------------------
# JDK 8
#--------------------
  cp download/jdk-8u161-linux-x64.tar.gz opt
  cd opt && tar -xvf jdk-8u161-linux-x64.tar.gz && ln -s jdk1.8.0_161 jdk8 && cd ..

#--------------------
# MAVEN
#--------------------
  cp download/apache-maven-3.5.3-bin.tar.gz opt
  cd opt && tar -xvf apache-maven-3.5.3-bin.tar.gz && ln -s apache-maven-3.5.3 mvn3 && cd ..

#--------------------
# CLOJURE & LEIN
#--------------------
  cp download/lein opt
  chmod +x opt/lein
  mkdir -p home/.lein/self-installs
  cp download/leiningen-2.8.1-standalone.zip  home/.lein/self-installs/leiningen-2.8.1-standalone.jar

#--------------------
# HASKELL & STACK 
#--------------------
  curl -sSL https://get.haskellstack.org/ | sh

#--------------------
# EMACS 25
#--------------------
  cp download/emacs-25.3.tar.gz opt
  cd opt && tar -xvf emacs-25.3.tar.gz && ln -s emacs-25.3 emacs25-src && cd ..
  my=$(pwd) && cd opt/emacs25-src && ./configure --prefix=$my/opt/emacs25 --without-x && make && make install && cd ../..
  # sudo apt-get install make gcc libncurses-dev
  cp download/init.el home/.emacs.d/init.el
  # package-list-packages
  package-install paredit
  package-install cider

#--------------------
# DOCKER 
#--------------------
  mkdir -p /store/share
  mkdir -p docker.dist
  sudo sh -c "ifconfig > /store/share/ifconfig.out"
  #==== ZOOKEEPER ====
    cp download/zookeeper-3.4.11.tar.gz opt
    cd opt && tar -xvf zookeeper-3.4.11.tar.gz && ln -s zookeeper-3.4.11 zookeeper && cd ..

    mkdir -p docker.dist/zookeeper
    cp docker/zookeeper/* docker.dist/zookeeper
    cp download/jdk-8u161-linux-x64.tar.gz docker.dist/zookeeper
    cp download/zookeeper-3.4.11.tar.gz docker.dist/zookeeper

    cd docker.dist/zookeeper && sudo docker build -t larluo/zookeeper:1.0 .

    MY_IP=10.0.2.15
    SERVERS="${MY_IP}:2181:2888:3888,${MY_IP}:2182:2889:3889,${MY_IP}:2183:2890:3890"
    #---------------------------------------------
    # zookeeper/bin/zkServer.sh start-foreground
    #---------------------------------------------
    # ${MY_IP}:2181:2888:3888
    #------------------------
    sudo mkdir -p /store/zookeeper/${MY_IP}_2181_2888_3888
    #sudo docker run --name zookeeper-test1 -it --net=host -p '0.0.0.0:2181:2181' -p '0.0.0.0:2888:2888' -p '0.0.0.0:3888:3888' -e PORT=2181:2888:3888 \
    #  -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/zookeeper/${MY_IP}_2181_2888_3888:/store/zookeeper larluo/zookeeper:1.0 bash
    sudo docker run -d --name zookeeper_2181_2888_3888 --net=host -p '0.0.0.0:2181:2181' -p '0.0.0.0:2888:2888' -p '0.0.0.0:3888:3888' -e PORT=2181:2888:3888 \
      -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/zookeeper/${MY_IP}_2181_2888_3888:/store/zookeeper larluo/zookeeper:1.0
    #------------------------
    # ${MY_IP}:2182:2889:3889
    #------------------------
    sudo mkdir -p /store/zookeeper/${MY_IP}_2182_2889_3889 
    #sudo docker run --name zookeeper-test2 -it --net=host -p '0.0.0.0:2182:2181' -p '0.0.0.0:2889:2888' -p '0.0.0.0:3889:3888' -e PORT=2182:2889:3889 \
    #  -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/zookeeper/${MY_IP}_2182_2889_3889:/store/zookeeper larluo/zookeeper:1.0 bash
    sudo docker run -d --name zookeeper_2182_2889_3889 --net=host -p '0.0.0.0:2182:2181' -p '0.0.0.0:2889:2888' -p '0.0.0.0:3889:3888' -e PORT=2182:2889:3889 \
      -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/zookeeper/${MY_IP}_2182_2889_3889:/store/zookeeper larluo/zookeeper:1.0
    #------------------------
    # ${MY_IP}:2183:2890:3890
    #------------------------
    sudo mkdir -p /store/zookeeper/${MY_IP}_2183_2890_3890 
    #sudo docker run --name zookeeper-test3 -it --net=host -p '0.0.0.0:2183:2181' -p '0.0.0.0:2890:2888' -p '0.0.0.0:3890:3888' -e PORT=2183:2890:3890 \
    #  -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/zookeeper/${MY_IP}_2183_2890_3890:/store/zookeeper larluo/zookeeper:1.0 bash
    sudo docker run -d --name zookeeper_2183_2890_3890 --net=host -p '0.0.0.0:2183:2181' -p '0.0.0.0:2890:2888' -p '0.0.0.0:3890:3888' -e PORT=2183:2890:3890 \
      -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/zookeeper/${MY_IP}_2183_2890_3890:/store/zookeeper larluo/zookeeper:1.0

  #==== KAFKA ====
    cp download/kafka_2.11-1.1.0.tgz opt
    cd opt && tar -xvf kafka_2.11-1.1.0.tgz && ln -s kafka_2.11-1.1.0 kafka && cd ..

    mkdir -p docker.dist/kafka
    cp docker/kafka/* docker.dist/kafka
    cp download/jdk-8u161-linux-x64.tar.gz docker.dist/kafka
    cp download/kafka_2.11-1.1.0.tgz docker.dist/kafka

    cd docker.dist/kafka && sudo docker build -t larluo/kafka:1.0 .

    MY_IP=10.0.2.15
    SERVERS="${MY_IP}:9092,${MY_IP}:9093,${MY_IP}:9094"
    ZK_URL="${MY_IP}:2181,${MY_IP}:2182,${MY_IP}:2183/kafka_larluo"
    #------------------------
    # kafka/bin/kafka-server-start.sh kafka/config/server.properties
    #------------------------
    sudo mkdir -p /store/kafka/{${MY_IP}_9092,${MY_IP}_9093,${MY_IP}_9094}

    sudo docker run --name kafka-test1 -it --net=host -p '0.0.0.0:9092:9092' -e PORT=9092 \
      -e SERVERS=$SERVERS -e ZK_URL=$ZK_URL -v /store/share:/store/share -v /store/kafka/${MY_IP}_9092:/store/kafka larluo/kafka:1.0 bash
    sudo docker run --name kafka-test2 -it --net=host -p '0.0.0.0:9093:9092' -e PORT=9093 \
      -e SERVERS=$SERVERS -e ZK_URL=$ZK_URL -v /store/share:/store/share -v /store/kafka/${MY_IP}_9093:/store/kafka larluo/kafka:1.0 bash
    sudo docker run --name kafka-test3 -it --net=host -p '0.0.0.0:9094:9092' -e PORT=9094 \
      -e SERVERS=$SERVERS -e ZK_URL=$ZK_URL -v /store/share:/store/share -v /store/kafka/${MY_IP}_9094:/store/kafka larluo/kafka:1.0 bash

    sudo docker run -d --name kafka_10.0.2.15_9092 -it --net=host -p '0.0.0.0:9092:9092' -e PORT=9092 \
      -e SERVERS=$SERVERS -e ZK_URL=$ZK_URL -v /store/share:/store/share -v /store/kafka/${MY_IP}_9092:/store/kafka larluo/kafka:1.0
    sudo docker run -d --name kafka_10.0.2.15_9093 -it --net=host -p '0.0.0.0:9093:9092' -e PORT=9093 \
      -e SERVERS=$SERVERS -e ZK_URL=$ZK_URL -v /store/share:/store/share -v /store/kafka/${MY_IP}_9093:/store/kafka larluo/kafka:1.0
    sudo docker run -d --name kafka_10.0.2.15_9094 -it --net=host -p '0.0.0.0:9094:9092' -e PORT=9094 \
      -e SERVERS=$SERVERS -e ZK_URL=$ZK_URL -v /store/share:/store/share -v /store/kafka/${MY_IP}_9094:/store/kafka larluo/kafka:1.0

    #------------------------
    # RUN
    #------------------------
    sudo mkdir -p /store/kafka/${MY_IP}_9092
    kafka-topics.sh --zookeeper localhost:2181/kafka_larluo --create --replication-factor 1 --partitions 1 --topic test
    kafka-topics.sh --zookeeper localhost:2181/kafka_larluo --list
    kafka-console-producer.sh --broker-list localhost:9092 --topic test
    kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning

    #------------------------
    # USE
    #------------------------
    mkdir -p opt.dist/kafka/config/fs_127.0.0.1
    cp opt/kafka/config/connect-standalone.properties opt.dist/kafka/config/connect-standalone.properties
    cp opt/kafka/config/connect-file-source.properties opt.dist/kafka/config/fs_127.0.0.1/test.txt.properties
    connect-standalone.sh opt.dist/kafka/config/connect-standalone.properties opt.dist/kafka/config/fs_127.0.0.1/test.txt.properties

    kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning

  #==== REDIS ====
    cp download/redis-4.0.9.tar.gz opt
    cd opt && tar -xvf redis-4.0.9.tar.gz && ln -s redis-4.0.9 redis-src && \
      cd redis-src && make && cd .. && \
      mkdir -p redis-4.0.9-bin/bin && cp redis-src/src/{redis-server,redis-cli,redis-trib.rb} redis-4.0.9-bin/bin && \
      ln -s redis-4.0.9-bin redis && \
      tar -cvf redis-4.0.9-bin.tar redis-4.0.9-bin && gzip redis-4.0.9-bin.tar && cd ..

    mkdir -p docker.dist/redis
    cp docker/redis/* docker.dist/redis
    cp opt/jdk-8u161-linux-x64.tar.gz docker.dist/redis
    cp opt/redis-4.0.9-bin.tar.gz docker.dist/redis

    #------------------------
    # redis/bin/redis-server redis.conf
    #------------------------
    cd docker.dist/redis && sudo docker build -t larluo/redis:1.0 .

    MY_IP=10.0.2.15
    SERVERS="${MY_IP}:6379,${MY_IP}:6380,${MY_IP}:6381"

    sudo mkdir -p /store/redis/{${MY_IP}_6379,${MY_IP}_6380,${MY_IP}_6381}
    sudo docker run --name redis-test1 -it --net=host -p '0.0.0.0:6379:6379' -p '0.0.0.0:16379:16379' -e PORT=6379 \
      -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/redis/${MY_IP}_6379:/store/redis larluo/redis:1.0 bash
    sudo docker run --name redis-test2 -it --net=host -p '0.0.0.0:6380:6379' -p '0.0.0.0:16380:16379' -e PORT=6380 \
      -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/redis/${MY_IP}_6380:/store/redis larluo/redis:1.0 bash
    sudo docker run --name redis-test3 -it --net=host -p '0.0.0.0:6381:6379' -p '0.0.0.0:16381:16379' -e PORT=6381 \
      -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/redis/${MY_IP}_6381:/store/redis larluo/redis:1.0 bash

    sudo docker run -d --name redis_6379 -it --net=host -p '0.0.0.0:6379:6379' -p '0.0.0.0:16379:16379' -e PORT=6379 \
      -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/redis/${MY_IP}_6379:/store/redis larluo/redis:1.0
    sudo docker run -d --name redis_6380 -it --net=host -p '0.0.0.0:6380:6379' -p '0.0.0.0:16380:16379' -e PORT=6380 \
      -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/redis/${MY_IP}_6380:/store/redis larluo/redis:1.0
    sudo docker run -d --name redis_6381 -it --net=host -p '0.0.0.0:6381:6379' -p '0.0.0.0:16381:16379' -e PORT=6381 \
      -e SERVERS=$SERVERS -v /store/share:/store/share -v /store/redis/${MY_IP}_6381:/store/redis larluo/redis:1.0

    redis-trib.rb create ${MY_IP}:6379 ${MY_IP}:6380 ${MY_IP}:6381

    #------------------------
    # RUN
    #------------------------
    sudo apt install ruby
    sudo gem install redis

  #==== MSTR ====
  if ! sudo grep 'larluo' /etc/sudoers > /dev/null; then echo "larluo ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers; fi

  sudo yum install compat-libstdc++-33.i686
  sudo yum install libXp.x86_64
  sudo yum install elfutils-devel.x86_64
  sudo yum install libstdc++
  sudo yum install krb5-libs.i686
  sudo yum install nss-pam-ldapd.i686
  sudo yum install ksh.x86_64
#--------------------
# ETHEREUM
#--------------------
  cp download/go1.10.2.linux-amd64.tar.gz opt
  cd opt && tar -xvf go1.10.2.linux-amd64.tar.gz && cd ..
  

#--------------------
# CARDANO
#--------------------
  stack install cpphs
  sudo apt-get install librocksdb-dev
  sudo apt-get install liblzma-dev
  sudo apt-get install libssl-dev

  .stack-work/install/x86_64-linux/lts-9.1/8.0.2/bin/cardano-launcher --config larluo.launcher-config.yaml

  #==== IELE ====
  https://github.com/runtimeverification/iele-semantics/blob/master/INSTALL.md
  sudo apt-get install virtualenv

#--------------------
# METABASE
#--------------------
  export MB_PLUGINS_DIR=opt/metabase.plugins
  java -jar opt/metabase.jar

#--------------------
# SHADOWSOCKS
#--------------------
  sudo $(pwd)/home/.local/bin/sslocal -c my/shadowsocks.json -d start

#--------------------
# NIX: https://nixos.org/nix/manual/
#--------------------
  bash <(curl https://nixos.org/nix/install)
```
