#!/bin/bash

docker_image="${1:-voko-cikado:latest}"

# lanĉi la test-procezujon
docker run -p 8082 --name cikado-test --rm -d ${docker_image}

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

# momente ni nur testas, ĉu la retpetoj estas sukcesaj. Uzante 'jq'
# ni povus ankaŭ pli detale rigardi ĉu la enhavo estas kiel atendita...

echo ""; echo "Akirante la verkoliston..."
curl -fLI "http://$HPORT/cikado/verkaro?kiu=chiuj"

echo ""; echo "Simpla serĉo pri 'hundo'..."
curl -fLI "http://$HPORT/cikado/cikado?sercho=hundo&kie=klasikaj"

echo ""; echo "Serĉante je regulesprimo..."
curl -fLI "http://$HPORT/cikado/cikado?sercho=\bhun[dt]o&kie=klasikaj"

echo ""; echo "Petante kuntekston de frazo per nombro..."
curl -fLI "http://$HPORT/cikado/kunteksto?frazo=35967&n=1"

echo ""; echo "Forigi..."
docker kill cikado-test