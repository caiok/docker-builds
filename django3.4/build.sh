#!/bin/bash
# Warning: this script is Debian based

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
# Installations
apt-get update -y
echo -e 'When asked, \e[31minsert "test" as root password\e[0m. Press enter to resume...' ; read RESP
apt-get install -y mysql-client mysql-server
# -------------- #

# -------------- #
# service mysql start
#
# #mysqladmin -u root -p'$oldrootpass' password '$newrootpass'
# mysqladmin -u root -p'' password 'test'
#
# mysql -u root -ptest << EOF
# create database test;
# create user 'test'@'%' identified by 'test';
# grant all on test.* to 'test' identified by 'test';
# EOF
#
# service mysql stop
# -------------- #


# -------------- #
# Let's check that all is ok
python -V
python -c "import django; print('Django Version: ' + django.get_version())"
mysql -V
# -------------- #

# -------------- #
# Some housekeeping...
apt-get clean
# -------------- #
