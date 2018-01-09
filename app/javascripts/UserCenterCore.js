contract = require('truffle-contract');
provider = require('./Web3Provider.js');

const UserCenter = contract(require('../../build/contracts/UserCenter.json'));
UserCenter.setProvider(provider);


module.exports = UserCenter.deployed();