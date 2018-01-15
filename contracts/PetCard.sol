pragma solidity ^0.4.17;

contract PetCard {
    struct Card {
        bytes32 code; //卡片代码，决定卡片的功能
        uint256 value;
        address owner;
        bool isSelling;
        uint sellingPrice;
        uint cardId;
    }
    enum ErrorCode {ERROR_NO_ERROR, ERROR_INDEX_OUT_OF_RANGE, ERROR_WRONG_OWNER, ERROR_CARD_IS_SELLING, ERROR_CARD_IS_NOT_SELLING, ERROR_PRICE_NOT_ENOUGH}
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

    event BuyCardEvent(uint cardId, bool isSuccess, ErrorCode errorCode);
    // 从卡片商城中购买卡片
    function buyCard(uint cardId) public payable {
        address buyer = msg.sender;
        // 判断card下标是否合法，不合法时退款给买家
        if (cardId >= cards.length || cardId < 0) {
            buyer.transfer(msg.value);
            BuyCardEvent(cardId, false, ErrorCode.ERROR_INDEX_OUT_OF_RANGE);
            return;
        }
        Card storage card = cards[cardId];
        // 判断消费金额是否小于card价格
        if (msg.value < card.sellingPrice) {
            buyer.transfer(msg.value);
            BuyCardEvent(cardId, false, ErrorCode.ERROR_PRICE_NOT_ENOUGH);
            return;
        } 
        // 判断卡片是否正在销售
        if (!card.isSelling) {
            buyer.transfer(msg.value);
            BuyCardEvent(cardId, false, ErrorCode.ERROR_CARD_IS_NOT_SELLING);
            return;
        }
        // 将卡片卖的钱还给卖家
        if (this.balance >= card.sellingPrice) {
            card.owner.transfer(card.sellingPrice);
        }
        card.owner = buyer;
        card.isSelling = false;
        card.sellingPrice = 0;
        BuyCardEvent(cardId, true, ErrorCode.ERROR_NO_ERROR);
    }

    event SellCardEvent(uint cardId, bool isSuccess, ErrorCode errorCode);
    // 用户卖自己的卡片给合约
    function sellCard(uint cardId) public payable {
        address seller = msg.sender;
        // 判断卡片下标是否合法
        if (cardId >= cards.length || cardId < 0) {
            seller.transfer(msg.value);
            SellCardEvent(cardId, false, ErrorCode.ERROR_INDEX_OUT_OF_RANGE);
            return;
        }
        Card storage card = cards[cardId];
        // 判断卖家是否为卡片拥有者
        if (seller != card.owner) {
            seller.transfer(msg.value);
            SellCardEvent(cardId, false, ErrorCode.ERROR_WRONG_OWNER);
            return;
        }
        if (card.isSelling) {
            seller.transfer(msg.value);
            SellCardEvent(cardId, false, ErrorCode.ERROR_CARD_IS_SELLING);
            return;
        }
        card.isSelling = true;
        card.sellingPrice = msg.value;
        SellCardEvent(cardId, true, ErrorCode.ERROR_NO_ERROR);
    }

    event CancelSellCardEvent(uint cardId, bool isSuccess, ErrorCode errorCode);
    // 用户取消出售卡片
    function cancelSellCard(uint cardId) public {
        // 判断卡片下标是否合法
        if (cardId >= cards.length || cardId < 0) {
            CancelSellCardEvent(cardId, false, ErrorCode.ERROR_INDEX_OUT_OF_RANGE);
            return;
        }
        Card storage card = cards[cardId];
        if (card.owner != msg.sender) {
            CancelSellCardEvent(cardId, false, ErrorCode.ERROR_WRONG_OWNER);
            return;
        }
        if (!card.isSelling) {
            CancelSellCardEvent(cardId, false, ErrorCode.ERROR_CARD_IS_NOT_SELLING);
            return;
        }
        msg.sender.transfer(card.sellingPrice);
        card.isSelling = false;
        CancelSellCardEvent(cardId, true, ErrorCode.ERROR_NO_ERROR);
    }

    event ExchangeCardEvent(uint cardId, address newOwner, bool isSucess, ErrorCode errorCode);
    // 用户交换卡片
    function exchangeCard(uint cardId, address otherUser) public {
        // 判断卡片下标是否合法
        if (cardId >= cards.length || cardId < 0) {
            ExchangeCardEvent(cardId, card.owner, false, ErrorCode.ERROR_INDEX_OUT_OF_RANGE);      
            return;
        }
        Card storage card = cards[cardId];
        // 判断卡片拥有者
        if (card.owner != msg.sender) {
            ExchangeCardEvent(cardId, card.owner, false, ErrorCode.ERROR_WRONG_OWNER);
            return;
        }
        // 判断卡片是否正在出售
        if (card.isSelling) {
            ExchangeCardEvent(cardId, card.owner, false, ErrorCode.ERROR_CARD_IS_SELLING);
            return;
        }
        card.owner = otherUser;
        ExchangeCardEvent(cardId, card.owner, true, ErrorCode.ERROR_NO_ERROR);
    }

    // 获取用户所有卡片
    function getAllCardsForUser() public constant returns (uint[] cardIds, bytes32[] codes, uint[] values, uint len) {
        cardIds = new uint[](cards.length);
        codes = new bytes32[](cards.length);
        values = new uint[](cards.length);
        // codes = new string[](cards.length);
        len = 0;
        for (uint i = 0; i < cards.length; i++) {
            if (cards[i].owner == msg.sender) {
                cardIds[len] = cards[i].cardId;
                codes[len] = cards[i].code;
                values[len] = cards[i].value;
                len++;
            }
        }
    }

    event CreateNewCardEvent(uint cardId, bytes32 code, address owner, uint value);
    // 给用户掉落新卡片
    function createNewCardForUser(bytes32 code, uint value) public {
        Card memory card = Card({code: code, value: value, owner: msg.sender, isSelling: false, cardId: cards.length, sellingPrice: 0});
        cards.push(card);
        CreateNewCardEvent(card.cardId, card.code, card.owner, card.value);
    }

}