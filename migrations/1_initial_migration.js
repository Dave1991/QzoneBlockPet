var Migrations = artifacts.require("./Migrations.sol");
var HelloWorld = artifacts.require("./HelloWorld.sol");
var PetCard = artifacts.require("./PetCard.sol");
var UserCenter = artifacts.require("./UserCenter.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(HelloWorld);
  deployer.deploy(PetCard);
  deployer.deploy(UserCenter);
};
