#!/bin/bash

# set -x
if [ "$1" == "" ]
then
  echo "Usage: $0 <version>"
  echo "Example: $0 12.6"
  exit
fi

function show_version() {
  cat /psc/dlc/version
}

if [ -d /psc/dlc ]
then
# show_version
  exit
fi

echo "Installing OpenEdge..."

FILES=/files
VERSION=$1

cd $FILES

OPENEDGE_PACKAGE=`ls PROGRESS_OE_${VERSION}*.tar.gz 2> /dev/null | sort | tail -1`

if [ "$OPENEDGE_PACKAGE" == "" ]
then
  echo "OpenEdge media was not found at $FILES."
  echo "Exiting."
  exit 1
fi

mkdir -p /tmp/openedge
tar xzf $FILES/$OPENEDGE_PACKAGE -C /tmp/openedge
cd /tmp
time sudo ./openedge/proinst -b /files/response_${VERSION}.ini -l /tmp/install.log
rm -rf /tmp/openedge
cd /

# show_version
