async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Data = await ethers.getContractFactory("tonsbridge");
    const data = await Data.connect(deployer).deploy();

    //BSC deployed
    await data.deployed('0x582d872a1b094fc48f5de31d3b73f2d9be47def1','0x10ed43c718714eb63d5aa57b78b54704e256024e');

    //ETH deployed
    // await data.deployed('0x76A797A59Ba2C17726896976B7B3747BfD1d220f','0x7a250d5630b4cf539739df2c5dacb4c659f2488d');

    console.log("PaymentRouter Deployed~!")
    console.log("PaymentRouter Contract address:", data.address);

  } 
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
    //npx hardhat run scripts/deploy.js --network bsc