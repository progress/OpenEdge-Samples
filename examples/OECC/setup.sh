#!/bin/bash

if [ "$EUID" -eq "0" ]
then
  echo "Usage: ./setup.sh"
  echo "Program must be run as a non-root user with sudo access"
  exit 1
fi

export OPENEDGE_VERSION=12.8.3
export OECC_VERSION=1.3.0

export DEMO=`pwd`

FILE=PROGRESS_OE_${OPENEDGE_VERSION}_LNX_64.tar.gz
if [ ! -f /files/$FILE ]
then
  echo "Prerequisite: OpenEdge ${OPENEDGE_VERSION} media ($FILE) must be found in /files folder."
  exit
fi

FILE=response_${OPENEDGE_VERSION}.ini
if [ ! -f /files/$FILE ]
then
  echo "Prerequisite: OpenEdge ${OPENEDGE_VERSION} response.ini file ($FILE) must be found in /files folder."
  exit
fi

FILE=PROGRESS_OECC_SERVER_${OECC_VERSION}_LNX_64.tar.gz
if [ ! -f /files/$FILE ]
then
  echo "Prerequisite: OpenEdge Command Center Server ${OECC_VERSION} .tar.gz file ($FILE) must be found in /files folder."
  exit
fi

if [ ! -f docker/oecc/$FILE ]
then
  cp -vi /files/$FILE docker/oecc/
fi

FILE=PROGRESS_OECC_AGENT_${OECC_VERSION}_LNX_64.bin
if [ ! -f /files/$FILE ]
then
  echo "Prerequisite: OpenEdge Command Center Agent ${OECC_VERSION} .bin file ($FILE) must be found in /files folder."
  exit
fi

if [ ! -f /usr/bin/file ]
then
  apt-get update
  apt-get install -y file
fi

if [ ! -f /usr/bin/jq ]
then
  apt-get update
  apt-get install -y jq
fi

if [ -d /usr/sbin/dmidecode ]
then
  if sudo dmidecode -s bios-version | fgrep -qi amazon
  then
    PRIVATE_IP_ADDRESS=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
  else
    if sudo dmidecode -s system-manufacturer | fgrep -q "Microsoft Corporation"
    then
      PRIVATE_IP_ADDRESS=`curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq -r '.network.interface[0].ipv4.ipAddress[0].privateIpAddress'`
    fi
  fi
fi

if [ "$PRIVATE_IP_ADDRESS" == "" ]
then
  PRIVATE_IP_ADDRESS=`ip -4 -j a | jq -r '.[1].addr_info[0].local'`
fi

# echo PRIVATE_IP_ADDRESS: $PRIVATE_IP_ADDRESS

for file in openedge.properties otagentoedb.yaml otagentpasoe.yaml serverInfo.json
do
  cp files/$file /files
  if [ "${PRIVATE_IP_ADDRESS}" != "" ]
  then
    sed -i "s/192.168.56.215/${PRIVATE_IP_ADDRESS}/g" /files/$file
  fi
done

if [ ! -f /etc/rc.local ]
then
  cp files/rc.local /etc/rc.local
  chmod +x /etc/rc.local
fi    

chmod +x ../common/scripts/*.sh

echo Running install_docker.sh...
../common/scripts/install_docker.sh
echo Running install_openjdk.sh...
../common/scripts/install_openjdk.sh 17
echo Running install_openedge.sh...
../common/scripts/install_openedge.sh ${OPENEDGE_VERSION}
echo Running create_sports2020.sh...
../common/scripts/create_sports2020.sh
echo Running create_oepas1.sh...
../common/scripts/create_oepas1.sh

echo Running docker-compose up -d...
cd docker
echo "docker-compose up -d" | newgrp docker
cd ..

echo Running upload_agentkey.sh...
../common/scripts/upload_agentkey.sh
echo Running install_oecc_agent.sh...
../common/scripts/install_oecc_agent.sh
