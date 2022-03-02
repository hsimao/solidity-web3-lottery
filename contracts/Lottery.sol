// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Lottery {
  address payable[] public players;
  address public manager;

  constructor() {
    manager = msg.sender;
  }

  function enter() public payable {
    require(msg.value > .01 ether);
    players.push(payable(msg.sender));
  }

  function random() private view returns (uint256) {
    return
      uint256(
        keccak256(
          abi.encodePacked(block.difficulty, block.timestamp, players.length)
        )
      );
  }

  // 隨機選出一位 player, 並將當前合約中的所有 balance 轉移給該 player
  function pickWinner() public payable onlyManager {
    uint256 index = random() % players.length;
    players[index].transfer(address(this).balance);

    // 重置 players
    players = new address payable[](0);
  }

  // 只有 manager 能調用
  modifier onlyManager() {
    require(msg.sender == manager);
    _;
  }

  function getPlayers() public view returns (address payable[] memory) {
    return players;
  }
}
