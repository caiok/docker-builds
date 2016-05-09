FROM centos:latest
MAINTAINER CaioK

ADD *.sh /root/
RUN /bin/bash /root/build.sh

EXPOSE 80

ENTRYPOINT /root/run.sh
