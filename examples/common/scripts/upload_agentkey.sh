#!/bin/bash
#
# Script to upload a known agent key to OpenEdge Command Center.
#

# set -x

OECC_USER_NAME=admin
OECC_USER_PASSWORD=admin

sleep 5

ID_TOKEN=`curl http://localhost:8000/api/auth/login \
     -s \
     -X POST \
     -H "Content-type: application/json" \
     -d "{ \"userName\": \"$OECC_USER_NAME\", \"password\": \"$OECC_USER_PASSWORD\" }" | jq -r '.idToken'`

jq '{ agentKey: .agentKey, agentKeyName: .agentKeyName }' /files/serverInfo.json > /tmp/payload.json

curl http://localhost:8000/api/admin/agentKeys \
     -s \
     -X POST \
     -H "Content-type: application/json" \
     -H "Authorization: Bearer $ID_TOKEN" \
     -d "`jq '{ agentKey: .agentKey, agentKeyName: .agentKeyName }' /files/serverInfo.json`"
