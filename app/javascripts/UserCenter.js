contract = require('truffle-contract');
provider = require('./Web3Provider.js');
express = require("express");

// const UserCenter = contract(require('../../build/contracts/UserCenter.json'));
// UserCenter.setProvider(provider);

// var userCenter;
// UserCenter.deployed().then(function(instance) {
//     userCenter = instance;
// });
var userCenter;
require('./UserCenterCore.js').then(function(instance) {
    userCenter = instance;
});

var app = module.exports = express();

app.get('/', function(req, res) {
    res.send('Hello, this is UserCenter');
});

app.get('/register/:address', function(req, res) {
    // 这里不能用call，不然写不到合约里
    userCenter.register({from: req.params.address}).then(function(result) {
        res.send(JSON.stringify({isSuccess: true}));
    });
});

app.get('/showAllUsers', function(req, res) {
    userCenter.showAllPlayers.call().then(function(result) {
        var addresses = []
        result.forEach(element => {
            addresses.push({address: element});
        });
        res.send(JSON.stringify(addresses));
    });
});