## 区块链宠物demo
### 目录结构
- app : 网页服务器
- build : 合约编译生成目录，不要手动修改
- contracts : 合约目录
- migrations : truffle部署配置文件，新的合约需要部署需要修改里面的配置文件
- test : 合约的测试文件
- truffle.js : 区块链网络配置文件，目前配的是testrpc默认测试环境

### 依赖
使用npm install xxx安装
- node.js : 在官网下载二进制安装包，或者用brew/apt-get安装
- web3.js : 使用npm安装，以太坊提供的js接口以rpc方式访问区块链数据和合约
- truffle : 第三方开源的DApp打包工具
- express : node.js服务器开发框架
- ethereum-testrpc : 以太坊提供的区块链测试环境

### 运行方式
1. $ testrpc
启动区块链测试环境
2. $ truffle compile 
编译智能合约
3. $ truffle migrate --reset
部署所有智能合约
4. $ cd app
5. $ npm start
启动服务器
6. 浏览器访问localhost:8080，目前提供的接口详见app/server.js中声明