const {task} = require("hardhat/config");
const util = require("util");
const request = util.promisify(require("request"));
const { planAddress } = require( "./constant");

async function callRpc(method, params) {
    var options = {
      method: "POST",
      url: "https://api.hyperspace.node.glif.io/rpc/v1",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        jsonrpc: "2.0",
        method: method,
        params: params,
        id: 1,
      }),
    };
    const res = await request(options);
    return JSON.parse(res.body).result;
}


task("payOPSSecurityFund", "pay OPS security fund")
  .setAction(async (taskArgs, {network, ethers}) => {
    const accounts = await ethers.getSigners()
    const signer = accounts[0]

    const factory = await ethers.getContractFactory("LetsFilRaisePlan", signer);
    const contract = new ethers.Contract(planAddress, factory.interface, signer)

    const priorityFee = await callRpc("eth_maxPriorityFeePerGas", [])
 
    let tx = await contract.payOpsSecurityFund({
        // maxPriorityFeePerGas: ethers.utils.parseUnits("50", "gwei"),
        // maxFeePerGas: ethers.utils.parseUnits("50", "gwei"),
        gasLimit: 10000000000,
        maxPriorityFeePerGas: priorityFee,
        value: ethers.utils.parseEther('1.0'),
    });

    await tx.wait();
    console.log(tx)
    
})
  

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {}
