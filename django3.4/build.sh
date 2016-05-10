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

export PS1='\[\e[0;32m\][[${debian_chroot:+($debian_chroot)}\u@\h:\w]]\$\[\e[0m\] '
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
# -------------- #

# -------------- #
# Old MySQL installation (from official repository)
#debconf-set-selections <<< 'mysql-server mysql-server/root_password password test'
#debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password test'
#apt-get install -y mysql-client mysql-server
# -------------- #

# -------------- #
# MySQL installation (copied from the "mysql" docker image Dockerfile)
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys A4A9406876FCBD3C456770C88C718D3B5072E1F5

export MYSQL_MAJOR=5.6
export MYSQL_VERSION=5.6.30-1debian8

echo -e "\ndeb http://repo.mysql.com/apt/debian/ jessie mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list
apt-get update -y

debconf-set-selections <<< 'mysql-community-server mysql-community-server/root-pass password test'
debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password test'
apt-get install -y mysql-client mysql-server="${MYSQL_VERSION}"
# -------------- #

# -------------- #
# MySQL initialization
chown -R mysql:mysql /var/lib/mysql
mysql_install_db

service mysql start

# Give "debian-sys-maint" user access privileges 
debian_maint_password=$(cat /etc/mysql/debian.cnf | grep password | awk '{print $3}' | head -n1)
mysql -u root -ptest -c <<< "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'%' IDENTIFIED BY '${debian_maint_password}';"

service mysql status

mysql_upgrade -u root -ptest

# Create "test" user and "test" database
mysql -u root -ptest << EOF
create database test;
create user 'test'@'%' identified by 'test';
grant all on test.* to 'test' identified by 'test';
EOF

service mysql stop
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
