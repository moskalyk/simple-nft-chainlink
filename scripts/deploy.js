// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");


async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile 
  // manually to make sure everything is compiled
  await hre.run('compile');

  // // We get the contract to deploy
  // const OracleClient = await ethers.getContractFactory("OracleClient");
  // const oracle = await OracleClient.deploy();

  // console.log("OracleClient deployed to:", oracle.address);

  const oracleAddress = "0x84603f06d27e80f82A7aeC21a54160414C77E352"
  
  const NFTFactory = await ethers.getContractFactory("NFTFactory");
  const factory = await NFTFactory.deploy(oracleAddress);

  console.log("NFTFactory deployed to:", factory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
