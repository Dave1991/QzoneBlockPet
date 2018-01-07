Web3 = require('web3');
contract = require('truffle-contract');

const provider = new Web3.providers.HttpProvider("http://localhost:8545");
const web3 = new Web3(provider);

const HelloWorld = contract(require('../../build/contracts/HelloWorld.json'));
HelloWorld.setProvider(provider);
HelloWorld.defaults({
	from: "0x69d101b4240004ed0d0c80bb1cb09c0c2f52fcde"
});

var helloWorld = HelloWorld.deployed();
// var helloWorld = HelloWorld.at("0x69d101b4240004ed0d0c80bb1cb09c0c2f52fcde");

module.exports = helloWorld;
