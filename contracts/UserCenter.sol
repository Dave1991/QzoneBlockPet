pragma solidity ^0.4.17;

contract UserCenter {
    address[] public players;
    function register() public {
        players.push(msg.sender);
    }

}