#!/bin/bash

function createsro() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/sro.land.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/sro.land.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-sro --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sro.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sro.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sro.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-sro.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/sro.land.com/msp/config.yaml

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-sro --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering user"
  set -x
  fabric-ca-client register --caname ca-sro --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-sro --id.name sroadmin --id.secret sroadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-sro -M ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/msp --csr.hosts peer0.sro.land.com --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sro.land.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/msp/config.yaml

  echo "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-sro -M ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls --enrollment.profile tls --csr.hosts peer0.sro.land.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/sro.land.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sro.land.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/sro.land.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/sro.land.com/tlsca/tlsca.sro.land.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/sro.land.com/ca
  cp ${PWD}/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/sro.land.com/ca/ca.sro.land.com-cert.pem

  echo "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-sro -M ${PWD}/organizations/peerOrganizations/sro.land.com/users/User1@sro.land.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sro.land.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sro.land.com/users/User1@sro.land.com/msp/config.yaml

  echo "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://sroadmin:sroadminpw@localhost:7054 --caname ca-sro -M ${PWD}/organizations/peerOrganizations/sro.land.com/users/Admin@sro.land.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/sro/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/sro.land.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/sro.land.com/users/Admin@sro.land.com/msp/config.yaml
}

function createbank() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/bank.land.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/bank.land.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-bank --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bank.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bank.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bank.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bank.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/bank.land.com/msp/config.yaml

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-bank --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering user"
  set -x
  fabric-ca-client register --caname ca-bank --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-bank --id.name bankadmin --id.secret bankadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/msp --csr.hosts peer0.bank.land.com --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.land.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/msp/config.yaml

  echo "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls --enrollment.profile tls --csr.hosts peer0.bank.land.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/bank.land.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/bank.land.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/bank.land.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/bank.land.com/tlsca/tlsca.bank.land.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/bank.land.com/ca
  cp ${PWD}/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/bank.land.com/ca/ca.bank.land.com-cert.pem

  echo "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.land.com/users/User1@bank.land.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.land.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/bank.land.com/users/User1@bank.land.com/msp/config.yaml

  echo "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://bankadmin:bankadminpw@localhost:8054 --caname ca-bank -M ${PWD}/organizations/peerOrganizations/bank.land.com/users/Admin@bank.land.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/bank/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/bank.land.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/bank.land.com/users/Admin@bank.land.com/msp/config.yaml
}

function createrevenue() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/revenue.land.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/revenue.land.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-revenue --tls.certfiles ${PWD}/organizations/fabric-ca/revenue/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-revenue.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-revenue.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-revenue.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-revenue.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/revenue.land.com/msp/config.yaml

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-revenue --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/revenue/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering user"
  set -x
  fabric-ca-client register --caname ca-revenue --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/revenue/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-revenue --id.name revenueadmin --id.secret revenueadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/revenue/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-revenue -M ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/msp --csr.hosts peer0.revenue.land.com --tls.certfiles ${PWD}/organizations/fabric-ca/revenue/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/revenue.land.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/msp/config.yaml

  echo "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-revenue -M ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls --enrollment.profile tls --csr.hosts peer0.revenue.land.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/revenue/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/revenue.land.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/revenue.land.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/revenue.land.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/revenue.land.com/tlsca/tlsca.revenue.land.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/revenue.land.com/ca
  cp ${PWD}/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/revenue.land.com/ca/ca.revenue.land.com-cert.pem

  echo "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-revenue -M ${PWD}/organizations/peerOrganizations/revenue.land.com/users/User1@revenue.land.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/revenue/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/revenue.land.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/revenue.land.com/users/User1@revenue.land.com/msp/config.yaml

  echo "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://revenueadmin:revenueadminpw@localhost:9054 --caname ca-revenue -M ${PWD}/organizations/peerOrganizations/revenue.land.com/users/Admin@revenue.land.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/revenue/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/revenue.land.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/revenue.land.com/users/Admin@revenue.land.com/msp/config.yaml
}

function createOrderer() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/land.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/land.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7059 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7059-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7059-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7059-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7059-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/land.com/msp/config.yaml

  echo "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:7059 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/msp --csr.hosts orderer.land.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/land.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/msp/config.yaml

  echo "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:7059 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/tls --enrollment.profile tls --csr.hosts orderer.land.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/msp/tlscacerts/tlsca.land.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/land.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/land.com/orderers/orderer.land.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/land.com/msp/tlscacerts/tlsca.land.com-cert.pem

  echo "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:7059 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/land.com/users/Admin@land.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/land.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/land.com/users/Admin@land.com/msp/config.yaml
}

createsro
createbank
createrevenue
createOrderer
