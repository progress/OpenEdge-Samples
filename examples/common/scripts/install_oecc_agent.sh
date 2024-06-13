#!/bin/bash

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
  sudo chmod +rx /files/PROGRESS_OECC_AGENT_${VERSION}_LNX_64.bin
  sudo /files/PROGRESS_OECC_AGENT_${VERSION}_LNX_64.bin \
    -i silent \
    -f $DEMO/files/response_agent_${VERSION}.properties

  sudo cp /files/otagentoedb.yaml /usr/oecc_agent/conf
  sudo cp /files/otagentpasoe.yaml /usr/oecc_agent/conf

  sudo systemctl restart Progress-OpenEdge-Command-Center-Agent.service
fi
