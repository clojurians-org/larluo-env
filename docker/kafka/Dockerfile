FROM ubuntu:16.04
MAINTAINER larluo@clojurians.org

USER root

ADD jdk-8u161-linux-x64.tar.gz .
ADD kafka_2.11-1.1.0.tgz .

RUN ln -s jdk1.8.0_161 jdk8 && ln -s kafka_2.11-1.1.0 kafka
ENV JAVA_HOME /jdk8

VOLUME /store/kafka

ADD entrypoint.sh /
ENTRYPOINT ["bin/sh", "/entrypoint.sh"]
CMD ["-d"]

EXPOSE 9092 7203
