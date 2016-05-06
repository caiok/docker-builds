FROM centos:latest
MAINTAINER CaioK

# ADD .bashrc /root/.bashrc
# 
# ENV http_proxy=http://proxy.mmfg.it:8080 \
#     https_proxy=$http_proxy \
#     ftp_proxy=$http_proxy \
#     HTTP_PROXY=$http_proxy \
#     HTTPS_PROXY=$http_proxy \
#     FTP_PROXY=$http_proxy \
#     no_proxy=$http_proxy
# 
# RUN yum update -y &&\
#     yum install -y epel-release &&\
#     yum update -y &&\
#     yum install -y python-pip &&\
#     \
#     pip install --upgrade pip &&\
#     pip install --upgrade django &&\
#     python -c "import django; print('Django Version: ' + django.get_version())"

ADD prepare.sh /root/prepare.sh
RUN /bin/bash /root/prepare.sh

EXPOSE 80

ENTRYPOINT /bin/bash