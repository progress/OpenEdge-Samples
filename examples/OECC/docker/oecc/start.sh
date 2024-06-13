#!/bin/bash

cd /usr/oecc

trap 'exit 0' SIGTERM

export PATH=/usr/oecc/node/bin:$PATH
export NODE_PATH=/usr/oecc/console/node_modules
export NODE_ENV=production
exec node ./console/dist/server.js

# ./oeccserver start
# sleep 30
# ls -l
# tail --pid=`cat ./oeccserver.pid` -f `ls -ltr | awk '{ print $9 }' | tail -1`
