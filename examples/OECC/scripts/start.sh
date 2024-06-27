#!/bin/bash
#
# Start the OpenEdge Command Center environment.
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

if ! $DLC/bin/proutil $WRKDIR/sports2020 -C probe liveness
then
  echo Starting database broker for Sports2020...
  sudo $DLC/bin/proserve $WRKDIR/sports2020 -S 20000 -n 30
fi

echo Starting PASOE instance oepas1... 
sudo $WRKDIR/oepas1/bin/tcman.sh pasoestart -restart

echo Running docker compose up -d...
cd docker
echo "docker compose up -d" | newgrp docker
cd ..

echo Restarting OpenEdge Command Center Agent...
sudo systemctl restart Progress-OpenEdge-Command-Center-Agent.service
