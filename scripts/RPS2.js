
const RUNS = 10;

// 99127

const main = async () => {

    console.log("Some work in write function, some storage, compute output in read")

    const [owner, randomPerson, anotherRandom] = await hre.ethers.getSigners();
    const nftFactory = await hre.ethers.getContractFactory("contracts/RockPaperScissors2.sol:RPS");
    const nftContract = await nftFactory.deploy();
    await nftContract.deployed(); 

    const results = []

    for(var i = 0; i<RUNS; i++) {
        var res = await nftContract.Play(owner.address, randomPerson.address);
        results.push(res.gasLimit.toNumber());
    }

    console.log("Avg Gas Limit: ", Math.floor(results.reduce((a, b)=>a+b,0)/RUNS));

}

module.exports = {
    main
}