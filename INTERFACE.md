## 空间区块链宠物接口文档
### 用户中心
- 接口前缀 : UserCenter
- 绑定用户地址

| 接口名称 | 方法 | 路由参数 | 例子 |
| --- | --- | --- | --- |
| register | GET | /:address | register/0xc3d9b7ea1e42b04dddf3475b464bb1abd5f8451f |


- 获取所有用户地址

| 接口名称 | 方法 | 路由参数 | 例子 |
| --- | --- | --- | --- |
| showAllUsers | GET | 无 | showAllUsers |

### 卡片商城
- 生成卡片

| 接口名称 | 方法 | 路由参数 | 例子 |
| --- | --- | --- | --- |
| createRandomCard | GET | 无 | createRandomCard |

- 获取用户所有卡片

| 接口名称 | 方法 | 路由参数 | 例子 |
| --- | --- | --- | --- |
| getAllCardsForUser | GET | /:address | getAllCardsForUser/0xc3d9b7ea1e42b04dddf3475b464bb1abd5f8451f |

- 销售卡片

| 接口名称 | 方法 | 路由参数 | 例子 |
| --- | --- | --- | --- |
| sellCard | GET | /:address/:cardId/:price | sellCard/0xc3d9b7ea1e42b04dddf3475b464bb1abd5f8451f/0/7 |

- 取消销售卡片

| 接口名称 | 方法 | 路由参数 | 例子 |
| --- | --- | --- | --- |
| cancelSellCard | GET | 

- 购买卡片
- 交换卡片