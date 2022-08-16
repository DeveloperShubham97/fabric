#!/bin/bash

function createchandigarh() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/chandigarh.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/chandigarh.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-chandigarh --tls.certfiles ${PWD}/organizations/fabric-ca/chandigarh/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-chandigarh.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-chandigarh.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-chandigarh.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-chandigarh.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/chandigarh.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-chandigarh --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/chandigarh/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-chandigarh --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/chandigarh/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-chandigarh --id.name chandigarhadmin --id.secret chandigarhadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/chandigarh/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-chandigarh -M ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/msp --csr.hosts peer0.chandigarh.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/chandigarh/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/chandigarh.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-chandigarh -M ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/tls --enrollment.profile tls --csr.hosts peer0.chandigarh.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/chandigarh/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/chandigarh.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/chandigarh.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/chandigarh.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/chandigarh.example.com/tlsca/tlsca.chandigarh.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/chandigarh.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/chandigarh.example.com/peers/peer0.chandigarh.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/chandigarh.example.com/ca/ca.chandigarh.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-chandigarh -M ${PWD}/organizations/peerOrganizations/chandigarh.example.com/users/User1@chandigarh.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/chandigarh/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/chandigarh.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/chandigarh.example.com/users/User1@chandigarh.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://chandigarhadmin:chandigarhadminpw@localhost:7054 --caname ca-chandigarh -M ${PWD}/organizations/peerOrganizations/chandigarh.example.com/users/Admin@chandigarh.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/chandigarh/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/chandigarh.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/chandigarh.example.com/users/Admin@chandigarh.example.com/msp/config.yaml
}

function createGujrat() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/gujrat.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/gujrat.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-gujrat --tls.certfiles ${PWD}/organizations/fabric-ca/gujrat/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gujrat.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gujrat.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gujrat.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gujrat.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/gujrat.example.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-gujrat --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/gujrat/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-gujrat --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/gujrat/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-gujrat --id.name gujratadmin --id.secret gujratadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/gujrat/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-gujrat -M ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/msp --csr.hosts peer0.gujrat.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/gujrat/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gujrat.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-gujrat -M ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/tls --enrollment.profile tls --csr.hosts peer0.gujrat.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/gujrat/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/gujrat.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/gujrat.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/gujrat.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/gujrat.example.com/tlsca/tlsca.gujrat.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/gujrat.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/gujrat.example.com/peers/peer0.gujrat.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/gujrat.example.com/ca/ca.gujrat.example.com-cert.pem

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-gujrat -M ${PWD}/organizations/peerOrganizations/gujrat.example.com/users/User1@gujrat.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/gujrat/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gujrat.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/gujrat.example.com/users/User1@gujrat.example.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://gujratadmin:gujratadminpw@localhost:8054 --caname ca-gujrat -M ${PWD}/organizations/peerOrganizations/gujrat.example.com/users/Admin@gujrat.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/gujrat/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gujrat.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/gujrat.example.com/users/Admin@gujrat.example.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}
