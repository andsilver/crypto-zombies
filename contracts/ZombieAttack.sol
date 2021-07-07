// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZombieHelper.sol";
import "./SafeMath.sol";

contract ZombieAttack is ZombieHelper {
    using SafeMath for uint256;
    using SafeMath16 for uint16;
    using SafeMath32 for uint32;

    uint256 randNonce = 8;
    uint256 attackVictoryProbability = 70;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce = randNonce.add(1);
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetId)
        external
        onlyOwnerOf(_zombieId)
        returns (bool)
    {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint256 rand = randMod(100);

        if (rand < attackVictoryProbability) {
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
            myZombie.level = myZombie.level.add(1);
            myZombie.winCount = myZombie.winCount.add(1);
            enemyZombie.loseCount = enemyZombie.loseCount.add(1);
            return true;
        } else {
            myZombie.loseCount = myZombie.loseCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
            _triggerCooldown(myZombie);
            return false;
        }
    }
}
