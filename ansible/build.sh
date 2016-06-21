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
apt-get install -y nano less sudo
apt-get install -y python ansible
# -------------- #

# -------------- #
# SSH Server installation (useful for scp and sshfs)
#   Copied from: https://docs.docker.com/engine/examples/running_ssh_service/
apt-get install -y --force-yes openssh-server
mkdir /var/run/sshd
echo 'root:test' | chpasswd
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# -------------- #

# -------------- #
# SSH Authorized Keys configuration
mkdir -pv /root/.ssh
cp /root/authorized_keys /root/.ssh
cd /root/.ssh
ln -s authorized_keys authorized_keys2
ln -s authorized_keys auth_keys
cd -
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config
# -------------- #

# -------------- #
# This installation lacks the "test" user used by Linux Academy course.
# If you want to create such user, do the following:
# - # adduser test
# - # chpasswd test
# - # visudo
# -   (under "root        ALL=(ALL:ALL) ALL"
#        add "test        ALL=(ALL:ALL) ALL"
# - # su -l test
# - $ ssh-keygen
# - $ ssh-copy-id test@0.0.0.0
# - $ ssh test@0.0.0.0 (just for make sure)
# -------------- #

# -------------- #
# Some housekeeping...
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /usr/share/man/*
rm -rf /usr/share/doc/*
find /usr/share/locale -mindepth 1 -maxdepth 1 | grep -v '/usr/share/locale/en' | xargs rm -rf
# -------------- #

# -------------- #
# Let's check that all is ok
python -V
# -------------- #
