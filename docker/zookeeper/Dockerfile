FROM ubuntu:16.04
MAINTAINER larluo@clojurians.org

USER root

ADD jdk-8u161-linux-x64.tar.gz .
ADD zookeeper-3.4.11.tar.gz .

RUN ln -s jdk1.8.0_161 jdk8 && ln -s zookeeper-3.4.11 zookeeper
ENV JAVA_HOME /jdk8

VOLUME /store/zookeeper

ADD entrypoint.sh /
ENTRYPOINT ["bin/sh", "/entrypoint.sh"]
CMD ["-d"]

EXPOSE 2181 2888 3888
