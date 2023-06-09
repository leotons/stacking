require("hardhat-deploy")
require("hardhat-deploy-ethers")

const ethers = require("ethers")
const fa = require("@glif/filecoin-address")
const util = require("util")
const request = util.promisify(require("request"))

const DEPLOYER_PRIVATE_KEY = network.config.accounts[0]

function hexToBytes(hex) {
    for (var bytes = [], c = 0; c < hex.length; c += 2) bytes.push(parseInt(hex.substr(c, 2), 16))
    return new Uint8Array(bytes)
}

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
    }
    const res = await request(options)
    return JSON.parse(res.body).result
}

const deployer = new ethers.Wallet(DEPLOYER_PRIVATE_KEY)

module.exports = async ({ deployments }) => {
    const { deploy } = deployments

    const priorityFee = await callRpc("eth_maxPriorityFeePerGas")
    const f4Address = fa.newDelegatedEthAddress(deployer.address).toString()

    console.log("Wallet Ethereum Address:", deployer.address)
    console.log("Wallet f4Address: ", f4Address)

    await deploy("LetsFilRaiseFactory", {
        from: deployer.address,
        args: ["0x47C1Cbb1D676B4464c19C5c58deaA50bA468C69B"],
        maxPriorityFeePerGas: priorityFee,
        log: true,
    })

    async() => {
        
    }

}

module.exports.tags = ["LetsFilFactory"]

