const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying EVoting contract with account:", deployer.address);

  const EVoting = await hre.ethers.getContractFactory("EVoting");
  const evoting = await EVoting.deploy("General Election 2026");

  await evoting.waitForDeployment();
  const address = await evoting.getAddress();

  console.log("EVoting deployed successfully to:", address);
  console.log("Election title:", await evoting.electionTitle());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

