/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

"use strict";

const fs = require("fs");
const path = require("path");
//change fabric network folder name if required
const fabricNetworkFolder = "Fabric-network0403";

exports.buildCCPSro = () => {
  // load the common connection configuration file
  const ccpPath = path.resolve(
    __dirname,
    "..",
    "..",
    fabricNetworkFolder,
    "Fabric-network",
    "organizations",
    "peerOrganizations",
    "sro.land.com",
    "connection-sro.json"
  );

  const fileExists = fs.existsSync(ccpPath);
  if (!fileExists) {
    throw new Error(`no such file or directory: ${ccpPath}`);
  }
  const contents = fs.readFileSync(ccpPath, "utf8");

  // build a JSON object from the file contents
  const ccp = JSON.parse(contents);

  console.log(`Loaded the network configuration located at ${ccpPath}`);
  return ccp;
};

exports.buildCCPRevenue = () => {
  // load the common connection configuration file
  const ccpPath = path.resolve(
    __dirname,
    "..",
    "..",
    fabricNetworkFolder,
    "Fabric-network",
    "organizations",
    "peerOrganizations",
    "revenue.land.com",
    "connection-revenue.json"
  );
  const fileExists = fs.existsSync(ccpPath);
  if (!fileExists) {
    throw new Error(`no such file or directory: ${ccpPath}`);
  }
  const contents = fs.readFileSync(ccpPath, "utf8");

  // build a JSON object from the file contents
  const ccp = JSON.parse(contents);

  console.log(`Loaded the network configuration located at ${ccpPath}`);
  return ccp;
};

exports.buildCCPBank = () => {
  // load the common connection configuration file
  const ccpPath = path.resolve(
    __dirname,
    "..",
    "..",
    fabricNetworkFolder,
    "Fabric-network",
    "organizations",
    "peerOrganizations",
    "bank.land.com",
    "connection-bank.json"
  );
  const fileExists = fs.existsSync(ccpPath);
  if (!fileExists) {
    throw new Error(`no such file or directory: ${ccpPath}`);
  }
  const contents = fs.readFileSync(ccpPath, "utf8");

  // build a JSON object from the file contents
  const ccp = JSON.parse(contents);

  console.log(`Loaded the network configuration located at ${ccpPath}`);
  return ccp;
};

exports.buildWallet = async (Wallets, walletPath) => {
  console.log(Wallets);
  // Create a new  wallet : Note that wallet is for managing identities.
  let wallet;
  console.log("it reached here 1");
  if (walletPath) {
    console.log("it reached here 2");
    wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Built a file system wallet at ${walletPath}`);
  } else {
    console.log("it reached here 3");
    wallet = await Wallets.newInMemoryWallet();
    console.log("Built an in memory wallet");
  }
  console.log(wallet);
  return wallet;
};

exports.prettyJSONString = (inputString) => {
  if (inputString) {
    return JSON.stringify(JSON.parse(inputString), null, 2);
  } else {
    return inputString;
  }
};
