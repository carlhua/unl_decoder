#!/bin/bash
COUNT=0
while IFS='' read -r MANIFEST || [[ -n "$MANIFEST" ]]; do
    COUNT=$((COUNT + 1))
    MANIFEST=$MANIFEST node parse-manifest.js &> foo.txt
    ID=$(cat foo.txt | grep PublicKey | awk '{print substr($2,2,length($2)-3)}')
    SEQUENCE=$(cat foo.txt | grep Sequence | awk '{print substr($2,0,length($2)-1)}')
    rm foo.txt
    wget -qO bar.txt https://data.ripple.com/v2/network/validators/$ID
    DOMAIN=$(cat bar.txt | jq '. | .domain' | awk '{print substr($0,2,length($0)-2)}')
    rm bar.txt
    if [ -z $DOMAIN ]; then
        DOMAIN="*** UNKNOWN ***"
    fi
    echo -e "($COUNT)\t$ID\t(sequence #$SEQUENCE)\t\t$DOMAIN"
done < "$1"