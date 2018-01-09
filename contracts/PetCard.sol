pragma solidity ^0.4.17;

contract PetCard {
    struct Card {
        string code; //卡片代码，决定卡片的功能
        uint256 value;
        address owner;
        bool isSelling;
        uint cardId;
    }
    Card[] cards;
    address CEO;
    function PetCard() public payable {
        CEO = msg.sender;
    }

    // 匿名函数，当外部调用找不到时调用该函数
	event FallbackTrigged(bytes data);
	function() public payable {
		FallbackTrigged(msg.data);
	}

    // 从卡片商城中购买卡片
    function buyCard(uint cardId) public payable returns (bool) {
        address buyer = msg.sender;
        // 判断card下标是否合法，不合法时退款给买家
        if (cardId >= cards.length || cardId < 0) {
            buyer.transfer(msg.value);
            return false;       
        }
        Card storage card = cards[cardId];
        // 判断消费金额是否小于card价格
        if (msg.value < card.value) {
            buyer.transfer(msg.value);
            return false;
        } 
        // 判断卡片是否正在销售
        if (!card.isSelling) {
            buyer.transfer(msg.value);
            return false;
        }
        // 将卡片卖的钱还给卖家
        if (this.balance >= card.value) {
            card.owner.transfer(card.value);
        }
        card.owner = buyer;
        card.isSelling = false;
        return true;
    }

    // 用户卖自己的卡片给合约
    function sellCard(uint cardId) public payable returns (bool) {
        address seller = msg.sender;
        // 判断卡片下标是否合法
        if (cardId >= cards.length || cardId < 0) {
            seller.transfer(msg.value);
            return false;       
        }
        Card storage card = cards[cardId];
        // 判断卖家是否为卡片拥有者
        if (seller != card.owner) {
            seller.transfer(msg.value);
            return false;
        }
        if (card.isSelling) {
            seller.transfer(msg.value);
            return false;
        }
        card.isSelling = true;
        card.value = msg.value;
        return true;
    }

    // 用户取消出售卡片
    function cancelSellCard(uint cardId) public payable returns (bool) {
        // 判断卡片下标是否合法
        if (cardId >= cards.length || cardId < 0) {
            return false;       
        }
        Card storage card = cards[cardId];
        if (card.owner != msg.sender) {
            return false;
        }
        if (!card.isSelling) {
            return false;
        }
        msg.sender.transfer(card.value);
        card.isSelling = false;
        return true;
    }

    // 用户交换卡片
    function exchangeCard(uint cardId, address otherUser) public returns (bool) {
        // 判断卡片下标是否合法
        if (cardId >= cards.length || cardId < 0) {
            return false;       
        }
        Card storage card = cards[cardId];
        // 判断卡片拥有者
        if (card.owner != msg.sender) {
            return false;
        }
        // 判断卡片是否正在出售
        if (card.isSelling) {
            return false;
        }
        card.owner = otherUser;
        return true;
    }

    // 获取用户所有卡片
    function getAllCardsForUser() public returns (Card[]) {
        Card[] storage userCards;
        for (uint i = 0; i < cards.length; i++) {
            Card card = cards[i];
            if (card.owner == msg.sender) {
                userCards.push(card);
            }
        }
        return userCards;
    }

    // 给用户掉落新卡片
    function createNewCardForUser(string code, uint value) public returns (Card card) {
        card = Card({code: code, value: value, owner: msg.sender, isSelling: false, cardId: cards.length});
        cards.push(card);
    }

}