#!/bin/bash
#
# Script to create PASOE instance oepas1 for the corresponding demo.
#

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
  cd /psc/wrk
  time sudo DLC=/psc/dlc /psc/dlc/bin/pasman create -v oepas1
  sudo cp /files/openedge.properties /psc/wrk/oepas1/conf
  sudo cp $DEMO/files/customer.p /psc/wrk/oepas1/openedge

  sudo ./oepas1/bin/tcman.sh pasoestart -restart
fi
