var LikeCoin = artifacts.require("./LikeCoin.sol");

contract('LikeCoin', function (accounts) {
    it("should put 100000 LikeCoin in the first account", function () {
        return LikeCoin.deployed().then(function (instance) {
            return instance.balanceOf.call(accounts[0]);
        }).then(function (balance) {
            assert.equal(balance.valueOf(), 100000, "100000 wasn't in the first account");
        });
    });
    it("should put 1 LikeCoin to account that liked content with valid id", function () {
        var contactInstance;
        var account = accounts[1];
        var initialBalance;

        return LikeCoin.deployed().then(function (instance) {
            contactInstance = instance;
            return contactInstance.balanceOf.call(account);
        }).then(function (balance) {
            initialBalance = balance;
            contactInstance.like(
                1,
                account,
                {from: accounts[0]}
            );
        }).then(function (balance) {
            return contactInstance.balanceOf.call(account);
        }).then(function (balance) {
            assert.equal(balance.toNumber() - initialBalance.toNumber(), 1, "account should receive 1 LikeCoin for like of content");
        });
    });
    it("should put 2 LikeCoins to account that shared content with valid id", function () {
        var contactInstance;
        var account = accounts[2];
        var initialBalance;

        return LikeCoin.deployed().then(function (instance) {
            contactInstance = instance;
            return contactInstance.balanceOf.call(account);
        }).then(function (balance) {
            initialBalance = balance;
            contactInstance.share(
                2,
                account,
                {from: accounts[0]}
            );
        }).then(function () {
            return contactInstance.balanceOf.call(account);
        }).then(function (balance) {
            assert.equal(balance.toNumber() - initialBalance.toNumber(), 2, "account should receive 1 LikeCoin for like of content");
        });
    });
    it("should convert 10 LikeCoins to 1 ether", function () {
        var contactInstance;
        var account = accounts[3];
        var ethInitialBalance;
        var coinsValue = 10;

        return LikeCoin.deployed().then(function (instance) {
            contactInstance = instance;
            return web3.eth.getBalance(account);
        }).then(function (balance) {
            ethInitialBalance = balance;
            contactInstance.transfer(account, coinsValue);
        }).then(function () {
            contactInstance.transferEtherForCoins(account, coinsValue)
        }).then(function () {
            return web3.eth.getBalance(account);
        }).then(function (balance) {
            assert.notEqual(ethInitialBalance.toString(), balance.toString());
        });
    });

});
