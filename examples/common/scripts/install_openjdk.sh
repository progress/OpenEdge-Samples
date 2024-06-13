#!/bin/bash

# set -x

if [ "$1" == "" ]
then
  echo "Usage: $0 <version>"
  echo "Example: $0 17"
  exit
fi

function show_version() {
  /usr/lib/jvm/jdk/bin/java -version 2>&1 | fgrep "OpenJDK Runtime"
}

if [ -d /usr/lib/jvm/jdk ]
then
  # show_version
  exit
fi

echo "Installing OpenJDK..."

FILES=/files
VERSION=$1
OWNER=adoptium
REPO=temurin${VERSION}-binaries
API_URL=https://api.github.com/repos/${OWNER}/${REPO}/releases

cd $FILES

LATEST_JDK=`curl -s ${API_URL}/latest | jq -r ".name"`
JDK_NAME=`cat JDK_NAME 2> /dev/null`
PACKAGE_NAME=`cat JDK_PACKAGE_NAME 2> /dev/null`

if [ "$JDK_NAME" != "$LATEST_JDK" ]
then
  URL=`curl -s ${API_URL}/tags/${LATEST_JDK} | jq -r '.assets[] | select(.content_type == "application/gzip") | select(.name | contains("jdk_x64_linux_hotspot")) | .browser_download_url'`
  PACKAGE_NAME=`basename $URL`
  wget -q $URL
  echo $LATEST_JDK > JDK_NAME
  echo $PACKAGE_NAME > JDK_PACKAGE_NAME
fi

# echo "DEBUG: " $PACKAGE_NAME
if [ ! -d /usr/lib/jvm/jdk ]
then
  sudo mkdir -p /usr/lib/jvm/jdk/
  sudo tar xzf $PACKAGE_NAME -C /usr/lib/jvm/jdk/ --strip-components=1
fi

# show_version
