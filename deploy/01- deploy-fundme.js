
// module.exports = async (hre) => {}  nearly same function but different syntax 
async function deployFunciton(hre) { //this funciton will run when we call hardhat deploy 
    const{ getNamedAccounts , deployments } = hre // pulling out these 2 functions from hre 
}
module.exports.default = deployFunciton ; 

