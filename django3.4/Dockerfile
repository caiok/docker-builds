FROM django:1.9-python3
MAINTAINER CaioK

ADD *.sh /root/

VOLUME /var/lib/mysql /repo

RUN /root/build.sh

EXPOSE 80 3306

ENTRYPOINT /root/run.sh
