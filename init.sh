#!/bin/bash

MYSQL_DATA="/opt/apps/ghost_mysql"
GHOST_DATA="/opt/apps/ghost_content"
export CERT=/nginx/cert

if ! [ -x "$(command -v docker-compose)" ] || ! [ "$(command -v docker)" ] ; then
  echo 'Error: Docker or docker-compose is not yet installed'
 if grep -iq "amzn" /etc/os-release ; then
     echo "Installing Docker and docker-compose on AWS EC2"
     sudo chmod +x docker-aws-linux-install.sh && ./docker-aws-linux-install.sh
 elif grep -iq "centos" /etc/os-release ; then
     echo "Installing Docker and docker-compose on RHEL or Centos"
     sudo chmod +x docker-centos-install.sh && ./docker-centos-install.sh
 else
     echo "Installing Docker and docker-compose on Ubuntu"
     sudo chmod +x docker-ubuntu-install.sh && ./docker-ubuntu-install.sh
 fi
fi

### Check for mysql and ghost home dir, if not found create it using the mkdir ##
[ ! -d "$MYSQL_DATA" ] && mkdir -p "$MYSQL_DATA"
[ ! -d "$GHOST_DATA" ] && mkdir -p "$GHOST_DATA"


if ls ${CERT}/*.crt &>/dev/null && ls ${CERT}/*.key &>/dev/null
then
    echo "Creating Containers"
    docker-compose up --force-recreate -d 
    exit 0
    
else
    echo 'Error: Missing Nginx certificates'
    exit 1
fi


