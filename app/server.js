var express = require('express'),
  fs = require('fs'),
  Url = require('url');

var app = express();
// var hello = Hello();

app.get('/', function(req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.write("Welcome to QzoneBlockPet");
  res.end();
});

app.use('/HelloWorld', require('./javascripts/HelloWorld.js'));

app.use('/UserCenter', require('./javascripts/UserCenter.js'));

app.listen(8080);
