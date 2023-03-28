# LandRegistration
We have defined 3 organizations Sro, Revenue, Bank for Land registration.
In Network we will 4 CA images (Sro, Revenue, Bank, orderer), were each Orgizations is having single Peer0

To start the fabric CA admin
```
docker-compose -f docker/docker-compose-ca.yaml up -d
```
It will create new organizations folder were we have CA server are built folder permission is changed
```
sudo chmode -R 774  organizations/ 
```
We have script registerEnroll.sh to register and enrole the users for each organization.
```
chmod +x registerEnroll.sh

./registerEnroll.sh
```
To Generate the Gensis Block - Looks for Fabric congiuration file that needs to run 
```
export FABRIC_CFG_PATH=${PWD}
configtxgen -profile ThreeOrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block
```
Create channel for transaction is used to define the channel name.
```
export CHANNEL_NAME=landchannel
configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
```    
Building the Infrastrucrure peers and Cli 
```
docker-compose -f docker/docker-compose-3org.yaml up -d
sudo chmod -R 774 ../Chaincode/
```
Open new termainal for peer0_sro 
```
docker exec -it cli bash

export CHANNEL_NAME=landchannel
```
Create Channel run below command
```
peer channel create -o orderer.land.com:7050 -c $CHANNEL_NAME -f ./config/$CHANNEL_NAME.tx --tls --cafile $ORDERER_TLS_CA
```
Join the Peer Channel run below commands
```
peer channel join -b $CHANNEL_NAME.block
peer channel list
```
Open new termainal for peer0_revenue and run below commands
```
docker exec -it cli bash

export CHANNEL_NAME=landchannel
export CORE_PEER_LOCALMSPID=revenueMSP
export CORE_PEER_ADDRESS=peer0.revenue.land.com:9051
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/revenue.land.com/users/Admin@revenue.land.com/msp
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/ca.crt
```
To join the peer in channel
```
peer channel join -b $CHANNEL_NAME.block
peer channel list
```
Open new termainal for peer0_revenue
```
docker exec -it cli bash

export CHANNEL_NAME=landchannel
export CORE_PEER_LOCALMSPID=bankMSP
export CORE_PEER_ADDRESS=peer0.bank.land.com:8051
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/bank.land.com/users/Admin@bank.land.com/msp
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/ca.crt
```
To Join the peer in channel
```
peer channel join -b $CHANNEL_NAME.block
peer channel list
```
Anchor Peer Update
```
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate channel-artifacts/sroMSPanchors.tx -channelID ${CHANNEL_NAME} -asOrg sroMSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate channel-artifacts/revenueMSPanchors.tx -channelID ${CHANNEL_NAME} -asOrg revenueMSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate channel-artifacts/bankMSPanchors.tx -channelID ${CHANNEL_NAME} -asOrg bankMSP
```
On peer0_sro terminal 
```
peer channel update -o orderer.land.com:7050 -c ${CHANNEL_NAME} -f ./config/sroMSPanchors.tx --tls --cafile $ORDERER_TLS_CA
```
On peer0_revenue terminal
```
peer channel update -o orderer.land.com:7050 -c ${CHANNEL_NAME} -f ./config/revenueMSPanchors.tx --tls --cafile $ORDERER_TLS_CA
```
On peer0_bank terminal 
```
peer channel update -o orderer.land.com:7050 -c ${CHANNEL_NAME} -f ./config/bankMSPanchors.tx --tls --cafile $ORDERER_TLS_CA
```
**Chaincode lifecycle**

On peer0_sro terminal
```
peer lifecycle chaincode package fabland.tar.gz --path /opt/gopath/src/github.com/chaincode/fabland/javascript/ --lang node --label fabland_1
peer lifecycle chaincode install fabland.tar.gz
peer lifecycle chaincode queryinstalled
```
On peer0_revenue terminal
```
peer lifecycle chaincode install fabland.tar.gz
peer lifecycle chaincode queryinstalled
```

On peer0_bank terminal
```
peer lifecycle chaincode install fabland.tar.gz
peer lifecycle chaincode queryinstalled
```
Exporting the chain code with correct Package ID on sro terminal
```
export PACKAGE_ID=fabland_1:c7f8e485834768e9d5a20386f5cde65cde7a48979c0806509ee66e1d155d395a

peer lifecycle chaincode approveformyorg --channelID ${CHANNEL_NAME} --name fabland --version 1 --sequence 1  --package-id $PACKAGE_ID  --tls --cafile $ORDERER_TLS_CA  --waitForEvent
```
Exporting the chain code with correct Package ID on revenue terminal
```
export PACKAGE_ID=fabland_1:c7f8e485834768e9d5a20386f5cde65cde7a48979c0806509ee66e1d155d395a

peer lifecycle chaincode approveformyorg --channelID ${CHANNEL_NAME} --name fabland --version 1 --sequence 1  --package-id $PACKAGE_ID  --tls --cafile $ORDERER_TLS_CA  --waitForEvent
```
Exporting the chain code with correct Package ID on bank terminal
```
export PACKAGE_ID=fabland_1:c7f8e485834768e9d5a20386f5cde65cde7a48979c0806509ee66e1d155d395a

peer lifecycle chaincode approveformyorg --channelID ${CHANNEL_NAME} --name fabland --version 1 --sequence 1  --package-id $PACKAGE_ID  --tls --cafile $ORDERER_TLS_CA  --waitForEvent
```
To check the chaincode is approve on all the orginzaions run below command in **sro** terminal it will give a JSON format of output of **TRUE** 
```
peer lifecycle chaincode checkcommitreadiness --channelID ${CHANNEL_NAME} --name fabland --version 1 --sequence 1 --output json

peer lifecycle chaincode commit -o orderer.land.com:7050 -C ${CHANNEL_NAME} --name fabland --tls --cafile $ORDERER_TLS_CA  --peerAddresses peer0.sro.land.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/ca.crt --peerAddresses peer0.revenue.land.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/ca.crt --peerAddresses peer0.bank.land.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/ca.crt --version 1 --sequence 1

peer lifecycle chaincode querycommitted --channelID ${CHANNEL_NAME} --name fabland
```

To invoke the date into Block chain
```
peer chaincode invoke -o orderer.land.com:7050  --tls --cafile $ORDERER_TLS_CA --channelID ${CHANNEL_NAME} --name fabland --peerAddresses peer0.sro.land.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/ca.crt  --peerAddresses peer0.revenue.land.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/revenue.land.com/peers/peer0.revenue.land.com/tls/ca.crt --peerAddresses peer0.bank.land.com:8051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/bank.land.com/peers/peer0.bank.land.com/tls/ca.crt -c '{"function":"createLand", "Args":[   "Land101","Ernakulam","Angamaly","Aluva","Manjapra","001","456","1","0.5","River","John Property","Babu Property","Johny Property","Testing changes","K A Cherian","123","MONGODBID"]}'
```
To query the date on peers
```
peer chaincode query -o orderer.land.com:7050  --tls --cafile $ORDERER_TLS_CA --channelID ${CHANNEL_NAME} --name fabland --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"function":"readLand", "Args":["Land101"]}'
```
To query the Historical date on peers
```
peer chaincode query -o orderer.land.com:7050  --tls --cafile $ORDERER_TLS_CA --channelID ${CHANNEL_NAME} --name fabland --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"function":"GetAssetHistory", "Args":["Land101"]}'
```

To Query the date on the host terminal
```
docker exec -e CORE_PEER_LOCALMSPID=sroMSP -e CHANNEL_NAME=mychannel -e CORE_PEER_ADDRESS=peer0.sro.land.com:7051 -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/server.crt -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/server.key -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/ca.crt -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/sro.land.com/users/Admin@sro.land.com/msp -i cli peer chaincode query -o orderer.land.com:7050 -C ${CHANNEL_NAME} -n fabland --tls --cafile $ORDERER_TLS_CA --peerAddresses peer0.sro.land.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/sro.land.com/peers/peer0.sro.land.com/tls/ca.crt -c '{"function":"readLand", "Args":["Land101"]}'
```





