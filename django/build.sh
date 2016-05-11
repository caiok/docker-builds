#!/bin/bash

# Warning: this script is Debian based

# Tip: if the build fails, the best way to do some debug is to modify
#      this script adding an "exit 0" before the failing command,
#      then create a container based on the image created and running it
#      with "docker run". At this time, it will be easy to reproduce the
#      issue and make the needed changes. 

# -------------- #
# Set bash to stop the script if a command terminates with an error
set -e
# Set bash to echo each command
set -x
# -------------- #

# -------------- #
# Bash initialization
ln -sv /root/bash_profile.sh /etc/profile.d/
# -------------- #

# -------------- #
# DT only initialization, executed if invoked with:
#   docker build --build-arg HTTP_PROXY=http://proxy.mmfg.it:8080 -t <image>:<tag>
if [ ! -z ${HTTP_PROXY+x} ]; then
  cat >> /root/bash_profile.sh << EOF

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
source /root/bash_profile.sh
# -------------- #

# -------------- #
# Installations
apt-get update -y
apt-get install -y nano less
# -------------- #

# -------------- #
# SSH Server installation (useful for scp and sshfs)
#   Copied from: https://docs.docker.com/engine/examples/running_ssh_service/
apt-get install -y --force-yes openssh-server
mkdir /var/run/sshd
echo 'root:test' | chpasswd
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
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
apt-get install -y mysql-client mysql-server="${MYSQL_VERSION}" mysqltuner
# -------------- #

# -------------- #
# MySQL initialization
cp -vf /root/my.cnf /etc/mysql/my.cnf
chmod 644 /etc/mysql/my.cnf

mkdir -v /db
mkdir -v /db/mysql
mkdir -v /db/mysql/data
mkdir -v /db/mysql/temp
mkdir -v /db/mysql/log
mkdir -v /db/mysql/run
mkdir -v /db/mysql/datalog
mkdir -v /db/mysql/datalog/binlog
mkdir -v /db/mysql/datalog/innolog
mkdir -v /db/mysql/datalog/relaylog
chown -R mysql:mysql /db

mysql_install_db

service mysql start

/usr/bin/mysqladmin -u root password 'test'

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
# Some housekeeping...
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/mysql
rm -rf /var/lib/apt/lists/*
#rm -rf /usr/share/man/*
#rm -rf /usr/share/doc/*
#find /usr/share/locale -mindepth 1 -maxdepth 1 | grep -v '/usr/share/locale/en' | xargs rm -rf
# -------------- #

# -------------- #
# Let's check that all is ok
python -V
python -c "import django; print('Django Version: ' + django.get_version())"
mysql -V
# -------------- #