// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./SafeMath.sol";

contract ZombieFactory is Ownable {
    using SafeMath for uint256;

    event NewZombie(uint256 zombieId, string name, uint256 dna);
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;
    uint256 cooldown = 1 days;

    struct Zombie {
        string name;
        uint256 dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 loseCount;
    }

    Zombie[] public zombies;
    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) ownerZombieCount;

    function _createZombie(string memory _name, uint256 _dna) internal {
        require(ownerZombieCount[msg.sender] == 0);
        zombies.push(
            Zombie(_name, _dna, 1, uint32(block.timestamp + cooldown), 0, 0)
        );
        uint256 id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // start here
    function createRandomZombie(string memory _name) public {
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
