#!/bin/bash
#
# Start the OpenEdge Command Center environment.
#

if ! /psc/dlc/bin/proutil /psc/wrk/sports2020 -C probe liveness
then
  echo Starting database broker for Sports2020...
  sudo DLC=/psc/dlc /psc/dlc/bin/proserve /psc/wrk/sports2020 -S 20000 -n 30
fi

echo Starting PASOE instance oepas1... 
sudo DLC=/psc/dlc /psc/wrk/oepas1/bin/tcman.sh pasoestart -restart

echo Running docker compose up -d...
cd docker
echo "docker compose up -d" | newgrp docker
cd ..

echo Restarting OpenEdge Command Center Agent...
sudo systemctl restart Progress-OpenEdge-Command-Center-Agent.service
