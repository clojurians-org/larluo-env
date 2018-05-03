FROM ubuntu:16.04
MAINTAINER larluo@clojurians.org

USER root

ADD jdk-8u161-linux-x64.tar.gz .
ADD redis-4.0.9-bin.tar.gz .

RUN ln -s jdk1.8.0_161 jdk8 && ln -s redis-4.0.9 redis
ENV JAVA_HOME /jdk8

VOLUME /store/redis

ADD entrypoint.sh /
ENTRYPOINT ["bin/sh", "/entrypoint.sh"]
CMD ["-d"]

EXPOSE 6379 16379
