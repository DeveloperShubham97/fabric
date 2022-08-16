#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/chandigarh.example.com/tlsca/tlsca.chandigarh.example.com-cert.pem
CAPEM=organizations/peerOrganizations/chandigarh.example.com/ca/ca.chandigarh.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/chandigarh.example.com/connection-chandigarh.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/chandigarh.example.com/connection-chandigarh.yaml

ORG=2
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/gujrat.example.com/tlsca/tlsca.gujrat.example.com-cert.pem
CAPEM=organizations/peerOrganizations/gujrat.example.com/ca/ca.gujrat.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/gujrat.example.com/connection-gujrat.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/gujrat.example.com/connection-gujrat.yaml
