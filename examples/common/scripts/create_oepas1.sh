#!/bin/bash

# Environment Variables
# DEMO: Location of demo files

# set -x
if [ "$DEMO" == "" ]
then
  echo "Environment variable 'DEMO' is not defined"
  exit 1
fi

if [ ! -d /psc/wrk/oepas1 ]
then
  echo "Creating PASOE instance (oepas1)..."
  export DLC=/psc/dlc
  export PATH=$DLC/bin:$PATH

  cd /psc/wrk
  time pasman create -v oepas1
  cp /files/openedge.properties /psc/wrk/oepas1/conf
  cp $DEMO/files/customer.p /psc/wrk/oepas1/openedge

  ./oepas1/bin/tcman.sh pasoestart -restart
fi
