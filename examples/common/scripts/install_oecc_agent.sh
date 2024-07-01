#!/bin/bash
#
# Script to install OpenEdge Command Center Agent.
#

# Environment Variables
# DEMO: Location of demo files
# OECC_VERSION: Version of OpenEdge Command Center

# set -x
if [ "$DEMO" == "" ]
then
  echo "Environment variable 'DEMO' is not defined"
  exit 1
fi
if [ "$OECC_VERSION" == "" ]
then
  echo "Environment variable 'OECC_VERSION' is not defined"
  exit 1
fi

VERSION=${OECC_VERSION}

if [ ! -d /usr/oecc_agent ]
then
  echo "Installing OpenEdge Command Center Agent..."
  sudo chmod +rx /install/PROGRESS_OECC_AGENT_${VERSION}_LNX_64.bin
  sudo /install/PROGRESS_OECC_AGENT_${VERSION}_LNX_64.bin \
    -i silent \
    -f $DEMO/config/response_agent_${VERSION}.properties

  sudo cp /install/otagentoedb.yaml /usr/oecc_agent/conf
  sudo cp /install/otagentpasoe.yaml /usr/oecc_agent/conf

  sudo systemctl restart Progress-OpenEdge-Command-Center-Agent.service
fi
