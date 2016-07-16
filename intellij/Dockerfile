FROM ubuntu:latest
MAINTAINER CaioK

ADD * /root/

VOLUME /workspace

RUN /root/build.sh

#EXPOSE 22

ENTRYPOINT /root/run.sh
