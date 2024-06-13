#!/bin/bash

echo -n "Testing OEPAS1 instance... "
RECORDS=`curl -s http://localhost:8810/web/customer.p | jq '.dsCustomer.ttCustomer | length'`
if [ "$RECORDS" == "22" ]
then
  echo PASSED
else
  echo FAILED
fi

echo "Waiting 30 seconds to ensure data collect from Prometheus... "
sleep 30

echo -n "Testing Prometheus endpoint at OTLP Collector... "
if curl -s http://localhost:9464/metrics > /tmp/$$.tmp
then
  echo PASSED
else
  echo FAILED
fi

echo -n "Testing response from Prometheus endpoint at OTLP Collector... "
LINES=`wc -l /tmp/$$.tmp | awk '{ print $1 }'`
if [ "$LINES" -gt 0 ]
then
  echo PASSED
else
  echo FAILED
fi

echo -n "Check for DB_ entries... "
LINES=`fgrep DB_ /tmp/$$.tmp | wc -l | awk '{ print $1 }'`
if [ "$LINES" -gt 0 ]
then
  echo PASSED
else
  echo FAILED
fi

echo -n "Check for PASOE_ entries... "
LINES=`fgrep PASOE_ /tmp/$$.tmp | wc -l | awk '{ print $1 }'`
if [ "$LINES" -gt 0 ]
then
  echo PASSED
else
  echo FAILED
fi

echo -n "Testing Prometheus metrics... "
LINES=`curl -s http://localhost:9090/metrics | wc -l | awk '{ print $1 }'`
if [ "$LINES" -gt 0 ]
then
  echo PASSED
else
  echo FAILED
fi

echo -n "Testing Grafana metrics... "
LINES=`curl -s http://localhost:3000/metrics | wc -l | awk '{ print $1 }'`
if [ "$LINES" -gt 0 ]
then
  echo PASSED
else
  echo FAILED
fi

rm /tmp/$$.tmp
