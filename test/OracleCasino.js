const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  
  describe("Oracle Casino Hardhat Testing", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployOneYearLockFixture() {
      const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
      const ONE_GWEI = 1_000_000_000;
  
      const lockedAmount = ONE_GWEI;
      const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;
  
      // Contracts are deployed using the first signer/account by default
      const [owner, user1] = await ethers.getSigners();


      const OracleGame = await ethers.getContractFactory("OracleGame");
      const hardhatOracleGame = await OracleGame.deploy();

      const DataConsumerV3 = await ethers.getContractFactory("DataConsumerV3");
      const hardhatDataConsumerV3 = await DataConsumerV3.deploy();

      return { hardhatOracleGame, hardhatDataConsumerV3,owner,user1};
    }
  
    describe("Deployment", function () {
      it("Should set the right unlockTime", async function () {
        const { lock, unlockTime } = await loadFixture(deployOneYearLockFixture);
  
        expect(await lock.unlockTime()).to.equal(unlockTime);
      });
  
      it("Should set the right owner", async function () {
        const { lock, owner } = await loadFixture(deployOneYearLockFixture);
  
        expect(await lock.owner()).to.equal(owner.address);
      });
  
      it("Should receive and store the funds to lock", async function () {
        const { lock, lockedAmount } = await loadFixture(
          deployOneYearLockFixture
        );
  
        expect(await ethers.provider.getBalance(lock.target)).to.equal(
          lockedAmount
        );
      });
  
      it("Should fail if the unlockTime is not in the future", async function () {
        // We don't use the fixture here because we want a different deployment
        const latestTime = await time.latest();
        const Lock = await ethers.getContractFactory("Lock");
        await expect(Lock.deploy(latestTime, { value: 1 })).to.be.revertedWith(
          "Unlock time should be in the future"
        );
      });
    });

});
  