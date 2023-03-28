// const { profile } = require('./profile')
const { Wallets, Gateway } = require("fabric-network");
const path = require("path");
const fs = require("fs");
const FabricCAServices = require("fabric-ca-client");
const { buildWallet, buildCCPSro } = require("../client/AppUtil");
const {
  buildCAClient,
  registerAndEnrollUser,
  enrollAdmin,
} = require("../client/CAUtil");
//change fabric network folder name if required
const fabricNetworkFolder = "Fabric-network0403";
const walletPathSro = path.resolve(
  __dirname,
  "..",
  "..",
  fabricNetworkFolder,
  "Fabric-network",
  "organizations",
  "peerOrganizations",
  "sro.land.com"
);

const mspSro = "sroMSP";

class EventListener {
  async blockEventListener(role, identityLabel, channelName, chaincodeName) {
    let gateway = new Gateway();

    try {
      const ccp = buildCCPSro();

      const caClient = buildCAClient(FabricCAServices, ccp, "ca.sro.land.com");
      const wallet = await buildWallet(Wallets, walletPathSro);
      await enrollAdmin(caClient, wallet, mspSro);
      await gateway.connect(ccp, {
        wallet,
        identity: identityLabel,
        discovery: { enabled: true, asLocalhost: true },
      });
      let channel = await gateway.getNetwork(channelName);
      let contract = await channel.getContract(chaincodeName); //contractName
      console.log(channel);
      console.log(contract);

      await channel.addBlockListener(async (event) => {
        console.log("Block details: ", event);
        console.log("Block number: ", event.blockNumber.toString());
      });
    } catch (error) {
      console.log(`Error: ${error}`);
      console.log(error.stack);
    }
  }

  async contractEventListener(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    eventName
  ) {
    let gateway = new Gateway();

    try {
      const ccp = buildCCPSro();

      const caClient = buildCAClient(FabricCAServices, ccp, "ca.sro.land.com");
      const wallet = await buildWallet(Wallets, walletPathSro);
      await enrollAdmin(caClient, wallet, mspSro);
      await gateway.connect(ccp, {
        wallet,
        identity: identityLabel,
        discovery: { enabled: true, asLocalhost: true },
      });
      let channel = await gateway.getNetwork(channelName);
      let contract = await channel.getContract(chaincodeName, contractName); //contractName
      console.log(channel);
      console.log(contract);

      await contract.addContractListener(async (event) => {
        if (event.eventName === eventName) {
          console.log(`Event: ${event.payload.toString()}`);
        }
      });
    } catch (error) {
      console.log(`Error: ${error}`);

      console.log(error.stack);
    }
  }

  async txnEventListener(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    transactionName,
    ...args
  ) {
    let gateway = new Gateway();

    try {
      const ccp = buildCCPSro();

      const caClient = buildCAClient(FabricCAServices, ccp, "ca.sro.land.com");
      const wallet = await buildWallet(Wallets, walletPathSro);
      await enrollAdmin(caClient, wallet, mspSro);
      await gateway.connect(ccp, {
        wallet,
        identity: identityLabel,
        discovery: { enabled: true, asLocalhost: true },
      });
      let network = await gateway.getNetwork(channelName);
      let contract = await channel.getContract(chaincodeName, contractName); //contractName

      let transaction = contract.createTransaction(transactionName);

      let peers = network.channel.getEndorsers();

      let transactionId = transaction.getTransactionId();

      await network.addCommitListener(
        (error, event) => {
          if (error) {
            console.log("Error: ", error);
          } else {
            console.log("TransactionId: ", event.transactionId);
            console.log("Transaction Status: ", event.status);
          }
        },
        peers,
        transactionId
      );

      await transaction.submit(...args);
    } catch (error) {
      console.log(`Error: ${error}`);
      console.log(error.stack);
    } finally {
      console.log("Disconnect from Fabric gateway.");
      gateway.disconnect();
    }
  }
}

module.exports = {
  EventListener,
};
