#FROM alpine:latest
FROM frolvlad/alpine-oraclejdk8
MAINTAINER CaioK

#ARG HADOOP_VERSION=1.2.1
#ARG HADOOP_VERSION=2.5.2
#ARG HADOOP_VERSION=2.6.4
ARG HADOOP_VERSION=2.7.2

ARG TAR=hadoop-$HADOOP_VERSION.tar.gz

ENV PATH $PATH:/hadoop/bin

WORKDIR /

ADD * /root/

VOLUME /repo

RUN /bin/sh /root/build.sh

COPY conf/core-site.xml /hadoop/etc/hadoop/
COPY conf/hdfs-site.xml /hadoop/etc/hadoop/
COPY conf/yarn-site.xml /hadoop/etc/hadoop/
COPY conf/mapred-site.xml /hadoop/etc/hadoop/
COPY profile.d/hadoop.sh /etc/profile.d/

EXPOSE 22
EXPOSE 8020 8042 8088 9000 10020 19888 50010 50020 50070 50075 50090

ENTRYPOINT [ "/bin/sh", "/root/run.sh" ]
