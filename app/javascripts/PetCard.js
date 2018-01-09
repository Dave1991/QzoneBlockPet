contract = require('truffle-contract');
provider = require('./Web3Provider.js');
express = require("express");

const PetCard = contract(require('../../build/contracts/PetCard.json'));
PetCard.setProvider(provider);
var petCard;
PetCard.deployed().then(function(instance){
    petCard = instance;
});


var userCenter;
require('./UserCenterCore.js').then(function(instance) {
    userCenter = instance;
});

var app = module.exports = express();

app.get('/', function(req, res) {
    res.send('Hello, this is PetCard');
});

app.get('/buyCard/:address/:cardId/:price', function(req, res) {
    petCard.buyCard(req.params.cardId, {from: req.params.address, value: req.params.price}).then(function(req, res) {
        res.send("success");
    });
});

app.get('/sellCard/:address/:cardId/:price', function(req, res) {
    petCard.sellCard(req.params.cardId, {from: req.params.address, value: req.params.price}).then(function(req, res) {
        res.send("success");
    });
});

app.get('/cancelSellCard/:address/:cardId', function(req, res) {
    petCard.cancelSellCard(req.params.cardId, {from: req.params.address}).then(function(req, res) {
        res.send("success");
    });
});

app.get('/exchangeCard/:address/:otherAddress/:cardId', function(req, res) {
    petCard.exchangeCard(req.params.cardId, req.params.otherAddress, {from: req.params.address}).then(function(req, res) {
        res.send("success");
    });
});

app.get('/getAllCardsForUser/:address', function(req, res) {
    petCard.getAllCardsForUser.estimateGas().then(function(esti_gas) {
        res.write(esti_gas + "\n");
        petCard.getAllCardsForUser({from: req.params.address, gas: esti_gas}).then(function() {
            res.write("success");
            res.end();
        });
    });
});

app.get('/createRandomCard', function(req, res) {
    var allUsers,
        randomUser;
    userCenter.showAllPlayers.call().then(function(result){
        allUsers = result;
        randomIdx = Math.floor(Math.random() * allUsers.length);
        randomUser = allUsers[randomIdx];
        if (randomUser != undefined) {
            var cardCode = "aaaforestlinbbb";
            var cardValue = Math.floor(Math.random() * 100 + 1);
            petCard.createNewCardForUser.estimateGas(cardCode, cardValue).then(function(esti_gas) {
                return petCard.createNewCardForUser(cardCode, cardValue, {from: randomUser, gas: esti_gas});
            }).then(function(rest) {
                res.send("success, card owner: " + randomUser);
            });
        } else {
            res.send("random user is undefined");
        }
    });
});

