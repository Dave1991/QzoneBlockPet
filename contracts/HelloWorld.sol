pragma solidity ^0.4.17;
import "./strings.sol";

contract HelloWorld {
	address public owner;
	using strings for *;
	// 构造函数
	function HelloWorld() payable {
		owner = msg.sender;
	}

	// 匿名函数，当外部调用找不到时调用该函数
	event fallbackTrigged(bytes data);
	function() payable {
		fallbackTrigged(msg.data);
	}

	// 发送以太币到该合约，单位wei
	event sendEvent(address to, uint value, bool result);
    function sendEther(uint256 number) public returns (bool result) {
    	// 向owner发送ether
        result = owner.send(number);
        sendEvent(owner, number, result);
    }

    function deposit() payable {

    }

    // 获取合约余额，单位wei
    function getBalance() public returns (uint balance) {
    	balance = this.balance;
    }

	function greet() public pure returns (string) {
		return "Hello QzoneBlockPet";
	}

	function sayHello(string name) public returns (string) {
		return "Hello, ".toSlice().concat(name.toSlice());
	}

	function ownerBalance() public returns (uint) {
		return owner.balance;
	}

	function ownerAddress() public returns (address) {
		return owner;
	}

}