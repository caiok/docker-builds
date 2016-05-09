FROM django:python3
MAINTAINER CaioK

ADD *.sh /root/
RUN /bin/bash /root/build.sh

EXPOSE 80 3306

ENTRYPOINT /root/run.sh
