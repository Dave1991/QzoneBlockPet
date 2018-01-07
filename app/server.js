var express = require('express'),
  fs = require('fs'),
  hello = require('./javascripts/HelloWorld.js'),
  Url = require('url');

var app = express();
// var hello = Hello();

app.get('/', function(req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.write("Welcome to QzoneBlockPet");
  res.end();
});

app.get('/getBalance', function(req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  hello.then(function(instance) {
    return instance.getBalance.call(); //使用call不产生transcation，这样才可以拿到返回值
  }).then(function(result) {
    res.write(result + "");
    res.end();
  });
});

app.get('/greet', function(req, res, next){
  hello.then(function(instance) {
    return instance.greet();
  }).then(function(result) {
    res.send(result);
  })
});

// 账户向合约存钱
app.get('/deposit', function(req, res, next){
  var helloIns;
  hello.then(function(instance) {
    helloIns = instance;
    // "0x69d101b4240004ed0d0c80bb1cb09c0c2f52fcde"
    return instance.deposit({from: req.query.account, value: eval(req.query.number)});
  }).then(function(result) {
    return helloIns.getBalance.call();
  }).then(function(result) {
    res.send("current balance: " + result);
  });
});

app.get('/sayHello', function(req, res, next){
  hello.then(function(instance) {
    return instance.sayHello.call(req.query.name);
  }).then(function(result) {
    res.send(result);
  })
});

app.listen(8080);
