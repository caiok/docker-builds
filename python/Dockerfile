FROM python:3.4
MAINTAINER CaioK

ADD * /root/

VOLUME /repo

RUN /root/build.sh

EXPOSE 22

ENTRYPOINT /root/run.sh
