#!/bin/bash

echo Stopping PASOE instance oepas1...
sudo DLC=/psc/dlc /psc/wrk/oepas1/bin/tcman.sh stop

echo Stopping database broker...
sudo DLC=/psc/dlc /psc/dlc/bin/proshut /psc/wrk/sports2020 -by

echo Stopping containers ... 
cd ~/OpenEdge-Samples/examples/OECC/docker
echo "docker-compose down" | newgrp docker

