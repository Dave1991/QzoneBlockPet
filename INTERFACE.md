## 空间区块链宠物接口文档
### 错误码

| id | 备注 |
| --- | --- |
| 0 | 无错误 |
| 1 | 数组越界 |
| 2 | 卡片拥有者错误 |
| 3 | 卡片正在销售 | 
| 4 | 卡片没有在销售 |
| 5 | 购买卡片的金额不足 |

### 用户中心接口
- 接口前缀 : UserCenter
- 绑定用户地址

| 接口名称 | 方法 | 路由参数 |
| --- | --- | --- |
| register | GET | /:address |

| 例子 | 返回 |
| --- | --- |
| register/0xc3d9b7ea1e42b04dddf3475b464bb1abd5f8451f | {"isSuccess":true} |

- 获取所有用户地址

| 接口名称 | 方法 | 路由参数 |
| --- | --- | --- |
| showAllUsers | GET | 无 |

| 例子 | 返回 |
| --- | --- |
| showAllUsers | [{"address":"0xc3d9b7ea1e42b04dddf3475b464bb1abd5f8451f"},{"address":"0x5727b589bca4500e896ffc82e3fedf56cae7017f"}] |

### 卡片商城接口
- 生成卡片

| 接口名称 | 方法 | 路由参数 | 
| --- | --- | --- |
| createRandomCard | GET | 无 | 

| 例子 | 返回 |
| --- | --- |
| createRandomCard | {"cardId":"2","code":"0x616161666","owner":"0x5727b589bca4500e896ffc82e3fedf56cae7017f","value":"52"} |

- 获取用户所有卡片

| 接口名称 | 方法 | 路由参数 |
| --- | --- | --- | 
| getAllCardsForUser | GET | /:address | 

| 例子 | 返回 |
| --- | --- |
| getAllCardsForUser/0xc3d9b7ea1e42b04dddf3475b464bb1abd5f8451f | [{"cardId":"0","code":"0x616161666","value":"4"}]

- 销售卡片

| 接口名称 | 方法 | 路由参数 |
| --- | --- | --- |
| sellCard | GET | /:address/:cardId/:price | 

| 例子 | 返回 |
| --- | --- |
| sellCard/0xc3d9b7ea1e42b04dddf3475b464bb1abd5f8451f/0/7 | {"cardId":"2","isSuccess":true,"errorCode":"0"} |

- 取消销售卡片

| 接口名称 | 方法 | 路由参数 | 
| --- | --- | --- | 
| cancelSellCard | GET | /:address/:cardId |

| 例子 | 返回 |
| --- | --- |
| cancelSellCard/0xc3d9b7ea1e42b04dddf3475b464bb1abd5f8451f/1 | {"cardId":"1","isSuccess":false,"errorCode":"4"} |

- 购买卡片

| 接口名称 | 方法 | 路由参数 | 
| --- | --- | --- | 
| buyCard | GET | /:address/:cardId/:price |

| 例子 | 返回 |
| --- | --- |
| buyCard/0xc3d9b7ea1e42b04dddf3475b464bb1abd5f8451f/1/26 | {"cardId":"1","isSuccess":false,"errorCode":"4"} |

- 交换卡片

| 接口名称 | 方法 | 路由参数 | 备注 |
| --- | --- | --- | --- |
| exchangeCard | GET | /:address/:otherAddress/:cardId | cardId必须属于address |

| 例子 | 返回 |
| --- | --- |
| exchangeCard/0x5727b589bca4500e896ffc82e3fedf56cae7017f/0x5f80d81ef605cce5b469558c80cafe4d8adff296/2 | {"cardId":"2","newOwner":"0x5f80d81ef605cce5b469558c80cafe4d8adff296","isSucess":true,"errorCode":"0"} |
