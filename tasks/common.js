const util = require("util");
const request = util.promisify(require("request"));

module.exports.factoryAddress = "0x3D6ee9b24a89D427c03F937C5cA17B8DE2610db0";
module.exports.planAddress = "0x3D6ee9b24a89D427c03F937C5cA17B8DE2610db0";

module.exports.callRpc = async function(method, params) {
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