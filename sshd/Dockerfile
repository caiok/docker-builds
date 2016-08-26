FROM alpine:latest
MAINTAINER CaioK

ADD * /root/

VOLUME /repo

RUN /bin/sh /root/build.sh

EXPOSE 22

ENTRYPOINT [ "/bin/sh", "/root/run.sh" ]
