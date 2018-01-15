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
    petCard.buyCard(req.params.cardId, {from: req.params.address, value: req.params.price}).then(function(result) {
        if (result.logs.length > 0) {
            var eventObj = result.logs[0].args;
            res.send(JSON.stringify(eventObj));
        }
    });
});

app.get('/sellCard/:address/:cardId/:price', function(req, res) {
    petCard.sellCard(req.params.cardId, {from: req.params.address, value: req.params.price}).then(function(result) {
        if (result.logs.length > 0) {
            var eventObj = result.logs[0].args;
            res.send(JSON.stringify(eventObj));
        }
    });
});

app.get('/cancelSellCard/:address/:cardId', function(req, res) {
    petCard.cancelSellCard(req.params.cardId, {from: req.params.address}).then(function(result) {
        if (result.logs.length > 0) {
            var eventObj = result.logs[0].args;
            res.send(JSON.stringify(eventObj));
        }
    });
});

app.get('/exchangeCard/:address/:otherAddress/:cardId', function(req, res) {
    petCard.exchangeCard(req.params.cardId, req.params.otherAddress, {from: req.params.address}).then(function(result) {
        if (result.logs.length > 0) {
            var eventObj = result.logs[0].args;
            res.send(JSON.stringify(eventObj));
        }
    });
});

app.get('/getAllCardsForUser/:address', function(req, res) {
    // 因为这是for循环遍历，estimate 估计的gas会不准确，该方法慎调
    petCard.getAllCardsForUser.call({from: req.params.address, gas: 3000000}).then(function(result) {
        if (result.length >= 4) {
            var cardIds = result[0], codes = result[1], values = result[2];
            var len = result[3];
            var cards = [];
            for (var i = 0; i < len; i ++) {
                cards.push({cardId: cardIds[i], code: codes[i], value: values[i]});
            }
            res.send(JSON.stringify(cards));
        }
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
                if (rest.logs.length > 0) {
                    var eventObj = rest.logs[0].args;
                    res.send(JSON.stringify(eventObj));
                }
            });
        } else {
            res.send("random user is undefined");
        }
    });
});
