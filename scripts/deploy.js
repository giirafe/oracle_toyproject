// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const DataConsumerV3 = await hre.ethers.getContractFactory("DataConsumerV3");
  const hardhatDataConsumerV3 = await DataConsumerV3.deploy();
  await hardhatDataConsumerV3.deployed();
  console.log("DataConsumerV3.sol deployed");

  const OracleGame = await hre.ethers.getContractFactory("OracleGame");
  const hardhatOracleGame = await OracleGame.deploy(hardhatDataConsumerV3.address);
  await hardhatOracleGame.deployed();
  console.log("OracleGame.sol deployed");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
