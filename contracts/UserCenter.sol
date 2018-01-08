pragma solidity ^0.4.17;

contract UserCenter {
    address[] public players;
    function register() public returns (uint) {
        return players.push(msg.sender);
    }
    function showAllPlayers() public returns (address[]) {
        return players;
    }
}