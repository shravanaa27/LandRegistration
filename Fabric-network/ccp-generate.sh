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
        ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=sro
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/sro.land.com/tlsca/tlsca.sro.land.com-cert.pem
CAPEM=organizations/peerOrganizations/sro.land.com/ca/ca.sro.land.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sro.land.com/connection-sro.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/sro.land.com/connection-sro.yaml

ORG=bank
P0PORT=8051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/bank.land.com/tlsca/tlsca.bank.land.com-cert.pem
CAPEM=organizations/peerOrganizations/bank.land.com/ca/ca.bank.land.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/bank.land.com/connection-bank.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/bank.land.com/connection-bank.yaml

ORG=revenue
P0PORT=9051
CAPORT=9054
PEERPEM=organizations/peerOrganizations/revenue.land.com/tlsca/tlsca.revenue.land.com-cert.pem
CAPEM=organizations/peerOrganizations/revenue.land.com/ca/ca.revenue.land.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/revenue.land.com/connection-revenue.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/revenue.land.com/connection-revenue.yaml
