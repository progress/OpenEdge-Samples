#!/bin/bash
#
# Stop the OpenEdge Command Center environment.
#

export DLC=${DLC-/psc/dlc}
export WRKDIR=${WRKDIR-/psc/wrk}

if [ ! -d "$DLC" ]
then
  echo OpenEdge installation was not found.
  exit 1
fi

if [ ! -d "$WRKDIR" ]
then
  echo OpenEdge working directory was not found.
  exit 1
fi

echo Stopping PASOE instance oepas1...
sudo $WRKDIR/oepas1/bin/tcman.sh stop

echo Stopping database broker...
sudo $DLC/bin/proshut $WRKDIR/sports2020 -by

echo Stopping containers ... 
cd ~/OpenEdge-Samples/examples/OECC/docker
echo "docker compose down" | newgrp docker
