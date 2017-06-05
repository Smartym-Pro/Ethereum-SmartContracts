var LikeCoin = artifacts.require("./LikeCoin.sol");
var StandardToken = artifacts.require("tokens/contracts/StandardToken.sol");

module.exports = function (deployer) {
    deployer.deploy(StandardToken);
    deployer.link(StandardToken, LikeCoin);
    deployer.deploy(LikeCoin);
};
