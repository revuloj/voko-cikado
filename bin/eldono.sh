#!/bin/bash

# Tio estas la eldono de voko-cikado
eldono=2g

# ni komprenas preparo 
target="${1:-helpo}"

case $target in
kreo)
    echo "Kreante lokan procezujon (por docker) voko-cikado"
    #docker build --build-arg VERSION=${eldono} --build-arg VG_TAG=v${eldono} --build-arg ZIP_SUFFIX=${eldono} \
    #    -t voko-cikado .
    docker build -t voko-cikado .
    ;;
etikedo)
    echo "Provizante la aktualan staton per etikedo (git tag) v${eldono}"
    echo "kaj puŝante tiun staton al la centra deponejo"
    git tag -f v${eldono} && git push && git push --tags -f
    ;;    
helpo | *)
    echo "---------------------------------------------------------------------------"
    echo "Per la celo 'preparo' oni povas krei git-branĉon kun nova eldono por tie "
    echo "komenci programadon de novaj funkcioj, ŝanĝoj ktp. Antaŭ adaptu en la kapo de ĉi-skripto"
    echo "la variablojn 'eldono' kaj 'node_eldono' al la nova eldono."
    ;;    
esac
