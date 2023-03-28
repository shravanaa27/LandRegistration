// const { profile } = require('./profile')
const { Wallets, Gateway } = require("fabric-network");
const path = require("path");
const fs = require("fs");
const FabricCAServices = require("fabric-ca-client");
const {
  buildCAClient,
  registerAndEnrollUser,
  enrollAdmin,
} = require("./CAUtil");
const {
  buildWallet,
  buildCCPSro,
  buildCCPRevenue,
  buildCCPBank,
} = require("./AppUtil");

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
  "sro.land.com",
  "wallet"
);
const walletPathRevenue = path.resolve(
  __dirname,
  "..",
  "..",
  fabricNetworkFolder,
  "Fabric-network",
  "organizations",
  "peerOrganizations",
  "revenue.land.com",
  "wallet"
);
const walletPathBank = path.resolve(
  __dirname,
  "..",
  "..",
  fabricNetworkFolder,
  "Fabric-network",
  "organizations",
  "peerOrganizations",
  "bank.land.com",
  "wallet"
);

const mspSro = "sroMSP";
const mspRevenue = "revenueMSP";
const mspBank = "bankMSP";

class clientApplication {
  //sro-submit
  async generateAndSubmitTxn(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
    ...args
  ) {
    console.log("client js createLand");
    console.log(...args);
    let gateway = new Gateway();
    try {
      // this.Profile = profile[role.toLowerCase()]
      // const ccpPath = path.resolve(this.Profile["CP"])
      // const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf-8'))

      // build an in memory object with the network configuration (also known as a connection profile)
      const ccp = buildCCPSro();

      // build an instance of the fabric ca services client based on
      // the information in the network configuration
      const caClient = buildCAClient(FabricCAServices, ccp, "ca.sro.land.com");

      // let wallet = await Wallets.newFileSystemWallet(this.Profile["Wallet"])

      // setup the wallet to hold the credentials of the application user
      const wallet = await buildWallet(Wallets, walletPathSro);

      // in a real application this would be done on an administrative flow, and only once
      await enrollAdmin(caClient, wallet, mspSro);

      await gateway.connect(ccp, {
        wallet,
        identity: identityLabel,
        discovery: { enabled: true, asLocalhost: true },
      });

      let channel = await gateway.getNetwork(channelName);
      console.log(chaincodeName);
      console.log(contractName);
      let contract = await channel.getContract(chaincodeName); //contractName

      let result = await contract.submitTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }

  //sro-Querying
  async generateAndEvaluateTxn(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
    ...args
  ) {
    let gateway = new Gateway();
    try {
      // this.Profile = profile[role.toLowerCase()]
      // const ccpPath = path.resolve(this.Profile["CP"])
      // const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf-8'))
      // let wallet = await Wallets.newFileSystemWallet(this.Profile["Wallet"])

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
      let contract = await channel.getContract(chaincodeName, contractName);
      let result = await contract.evaluateTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }

  //sro-delete
  async generateAndDeleteTxn(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
    ...args
  ) {
    let gateway = new Gateway();
    try {
      // this.Profile = profile[role.toLowerCase()]
      // const ccpPath = path.resolve(this.Profile["CP"])
      // const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf-8'))
      // let wallet = await Wallets.newFileSystemWallet(this.Profile["Wallet"])

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
      let contract = await channel.getContract(chaincodeName, contractName);
      console.log(`generateAndDeleteTxn contractName`, contractName);
      console.log(`generateAndDeleteTxn chaincodeName`, chaincodeName);
      let result = await contract.submitTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }

  //sro-update
  async generateAndUpdateTxn(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
    ...args
  ) {
    console.log(`in clientjs args`);
    console.log(...args);

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
      let contract = await channel.getContract(chaincodeName, contractName);

      let result = await contract.submitTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }

  //sro-transfer
  async generateAndTransferTxn(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
    ...args
  ) {
    console.log(`in clientjs args`);
    console.log(...args);

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
      let contract = await channel.getContract(chaincodeName, contractName);

      let result = await contract.submitTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }

  //sro-Querying from transaction ledger
  async queryHistory(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
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
      let channel = await gateway.getNetwork(channelName);
      let contract = await channel.getContract(chaincodeName, contractName);
      let result = await contract.evaluateTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }

  //Revenue : Querying from transaction ledger
  async revenueQueryHistory(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
    ...args
  ) {
    let gateway = new Gateway();
    try {
      const ccp = buildCCPRevenue();
      const caClient = buildCAClient(
        FabricCAServices,
        ccp,
        "ca.revenue.land.com"
      );
      const wallet = await buildWallet(Wallets, walletPathRevenue);
      await enrollAdmin(caClient, wallet, mspRevenue);

      await gateway.connect(ccp, {
        wallet,
        identity: identityLabel,
        discovery: { enabled: true, asLocalhost: true },
      });
      let channel = await gateway.getNetwork(channelName);
      let contract = await channel.getContract(chaincodeName, contractName);
      let result = await contract.evaluateTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }

  //revenue-mutate
  async generateAndMutateTxn(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
    ...args
  ) {
    console.log(`in clientjs args`);
    console.log(
      role,
      identityLabel,
      channelName,
      chaincodeName,
      contractName,
      txnName,
      ...args
    );

    let gateway = new Gateway();
    try {
      const ccp = buildCCPRevenue();
      const caClient = buildCAClient(
        FabricCAServices,
        ccp,
        "ca.revenue.land.com"
      );
      const wallet = await buildWallet(Wallets, walletPathRevenue);
      await enrollAdmin(caClient, wallet, mspRevenue);

      await gateway.connect(ccp, {
        wallet,
        identity: identityLabel,
        discovery: { enabled: true, asLocalhost: true },
      });
      let channel = await gateway.getNetwork(channelName);
      let contract = await channel.getContract(chaincodeName, contractName);

      let result = await contract.submitTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }

  //bank : Querying from transaction ledger
  async bankQueryHistory(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
    ...args
  ) {
    let gateway = new Gateway();
    try {
      const ccp = buildCCPBank();
      const caClient = buildCAClient(FabricCAServices, ccp, "ca.bank.land.com");
      const wallet = await buildWallet(Wallets, walletPathBank);
      await enrollAdmin(caClient, wallet, mspBank);

      await gateway.connect(ccp, {
        wallet,
        identity: identityLabel,
        discovery: { enabled: true, asLocalhost: true },
      });
      let channel = await gateway.getNetwork(channelName);
      let contract = await channel.getContract(chaincodeName, contractName);
      let result = await contract.evaluateTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }

  //bank-mortgage
  async generateAndMortgageTxn(
    role,
    identityLabel,
    channelName,
    chaincodeName,
    contractName,
    txnName,
    ...args
  ) {
    console.log(`in clientjs args`);
    console.log(
      role,
      identityLabel,
      channelName,
      chaincodeName,
      contractName,
      txnName,
      ...args
    );

    let gateway = new Gateway();
    try {
      const ccp = buildCCPBank();
      const caClient = buildCAClient(FabricCAServices, ccp, "ca.bank.land.com");
      const wallet = await buildWallet(Wallets, walletPathBank);
      await enrollAdmin(caClient, wallet, mspBank);

      await gateway.connect(ccp, {
        wallet,
        identity: identityLabel,
        discovery: { enabled: true, asLocalhost: true },
      });
      let channel = await gateway.getNetwork(channelName);
      let contract = await channel.getContract(chaincodeName, contractName);

      let result = await contract.submitTransaction(txnName, ...args);
      console.log(result);
      return result;
    } catch (error) {
      console.log("Error occured", error);
      throw new Error(error);
    } finally {
      console.log("Disconnect from the gateway.");
      gateway.disconnect();
    }
  }
}

module.exports = {
  clientApplication,
};
