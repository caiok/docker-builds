FROM alpine:latest
MAINTAINER CaioK

ADD * /root/

VOLUME /repo

RUN apk update && \
    apk add bash && \
    /root/build.sh

EXPOSE 22

ENTRYPOINT /root/run.sh
