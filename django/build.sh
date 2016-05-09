#!/bin/bash
# Warning: this script is CentOS based

# -------------- #
# Set bash to stop the script if a command terminates with an error
set -e
# Set bash to echo each command
set -x
# -------------- #

# -------------- #
# Bash initialization
cat >> /etc/profile.d/custom.sh << EOF
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
EOF
# -------------- #

# -------------- #
# DT only initialization, executed if invoked with:
#   docker build --build-arg HTTP_PROXY=http://proxy.mmfg.it:8080 -t <image>:<tag>
if [ ! -z ${HTTP_PROXY+x} ]; then
  cat >> /etc/profile.d/custom.sh << EOF
export http_proxy=${HTTP_PROXY}
export https_proxy=\$http_proxy
export ftp_proxy=\$http_proxy
export HTTP_PROXY=\$http_proxy
export HTTPS_PROXY=\$http_proxy
export FTP_PROXY=\$http_proxy
export no_proxy=
EOF
fi
# -------------- #

# -------------- #
source /etc/profile.d/custom.sh
# -------------- #

# -------------- #
# EPEL + Update
yum update -y
yum install -y epel-release
yum update -y
# -------------- #

# -------------- #
# Installing Python
yum install -y python-pip
pip install --upgrade pip
pip install --upgrade django
# -------------- #

# -------------- #
# PostgreSQL Install
yum install -y \
    postgresql \
    postgresql-server \
    postgresql-contrib
# -------------- #

# -------------- #
# Let's check that all is ok
python -c "import django; print('Django Version: ' + django.get_version())"
# -------------- #

# -------------- #
# Some housekeeping...
yum clean all
# -------------- #
