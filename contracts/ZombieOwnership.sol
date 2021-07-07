// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZombieAttack.sol";
import "./ERC721.sol";
import "./SafeMath.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
    using SafeMath for uint256;

    mapping(uint256 => address) zombieApprovals;

    function ownerOf(uint256 _tokenId)
        external
        override
        view
        returns (address)
    {
        return zombieToOwner[_tokenId];
    }

    function balanceOf(address _owner)
        external
        override
        view
        returns (uint256)
    {
        return ownerZombieCount[_owner];
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) private {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable override {
        require(
            zombieToOwner[_tokenId] == msg.sender ||
                zombieApprovals[_tokenId] == msg.sender
        );
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId)
        external
        payable
        override
        onlyOwnerOf(_tokenId)
    {
        zombieApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}
