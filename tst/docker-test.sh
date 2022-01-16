#!/bin/bash

# lanĉi la test-procezujon
docker run -p 8082 --name cikado-test --rm -d voko-cikado:latest

# atendi, ĝis ĝi ricevis retpordon
while ! docker port cikado-test
do
  echo "$(date) - atendante retpordon"
  sleep 1
done

DPORT=$(docker port cikado-test | head -n 1)
HPORT=${DPORT/#*-> }

echo "retpordo:" $HPORT
echo "Lanĉo de la servo daŭras iomete pro enlegado de la korpuso..."

# https://superuser.com/questions/272265/getting-curl-to-output-http-status-code
while ! curl -I "http://$HPORT/" 2> /dev/null
do
  echo "$(date) - atendante malfermon de TTT-servo"
  sleep 10
done

#curl -L "http://$HPORT/"
echo "Akirante la verkoliston..."
curl -L "http://$HPORT/cikado/verkaro?kiu=chiuj"

#echo ""; echo "Forigi..."
#docker kill cikado-test