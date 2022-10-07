// SPDX-License-Identifier: MIT
// Description: A ticketing infrastructure powered with NFTs
// to provide transparent, open and trustless system of
// minting tickets

// Features
// 1. The system should not store private data of
//      ticket publicly
// 2. The System should be able to create different
//      type of tickets which can be sold at different prices
// 3. The system will have more than one manager with
//      specific roles
// 4. The system should be gas optimised
// 5. The system should store funds securely and
//      implement pull payment

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTTicket is ERC721, Ownable {
    // state variable
    // user defined data type to store information about a tier
    struct Tier {
        bytes32 tierId;
        uint256 tierPrice;
        uint256 tierMaxQuantity;
        uint256 mintedSupply;
    }
    uint256 public tierCounter; // counter of how many NFT tiers exist
    mapping(uint256 => Tier) public ticketTiers; // maps tier identifier to tier data
    mapping(uint256 => bool) public isUsed; // tracks if the nft is reedemed or not
    uint256 private _tokenCounter;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    function addNewTier
    (uint256 _tierPrice, uint256 _tierMaxQuantity) 
    external {
        bytes32 tierId = keccak256(
            abi.encode(msg.data, block.timestamp, tierCounter)
        );
        uint256 tierIdentifier = tierCounter;
        tierCounter++;
        Tier memory tier = Tier({
            tierId: tierId,
            tierPrice: _tierPrice,
            tierMaxQuantity: _tierMaxQuantity,
            mintedSupply: 0
        });
        ticketTiers[tierIdentifier] = tier;
    }

    function mintTicket
    (uint256 _tierIdentifier, uint256 _quantity)
        external
        payable
    {
        Tier memory tier = ticketTiers[_tierIdentifier];
        require(tier.tierId != bytes32(0), "TIER Doesn't Exist");
        require(tier.tierPrice * _quantity == msg.value, 
        "Send exact funds");
        require(
            tier.mintedSupply + _quantity <= tier.tierMaxQuantity,
            "Exceeds max"
        );
        _mintTickets(msg.sender, _tierIdentifier, _quantity);
    }

    function permissionedMint(
        address _receiver,
        uint256 _tier,
        uint256 _quantity
    ) external onlyOwner {
        _mintTickets(_receiver, _tier, _quantity);
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function _mintTickets(
        address _receiver,
        uint256 _tierIdentifier,
        uint256 _quantity
    ) private {
        ticketTiers[_tierIdentifier].mintedSupply += _quantity;
        for (uint256 i; i < _quantity; i++) {
            _tokenCounter++;
            _mint(_receiver, _tokenCounter);
        }
    }

    function totalSupply() external view returns (uint256) {
        return _tokenCounter;
    }

    function getTierDetails(uint256 _tierId)
        external
        view
        returns (uint256, uint256)
    {
        Tier memory tier = ticketTiers[_tierId];
        return (tier.tierPrice, tier.tierMaxQuantity);
    }
}
