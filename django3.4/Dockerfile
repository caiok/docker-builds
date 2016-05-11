FROM django:1.9-python3
MAINTAINER CaioK

ADD * /root/

VOLUME /repo

RUN /root/build.sh

EXPOSE 22 80 3306

ENTRYPOINT /root/run.sh
