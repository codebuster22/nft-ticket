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

contract NFTTicket is ERC721 {
    // state variable
    struct Tier {
        bytes32 tierId;
        uint256 tierPrice;
        uint256 tierMaxQuantity;
        uint256 mintedSupply;
    }
    uint256 public tierCounter; // counter of how many NFT tiers exist
    mapping(uint256 => Tier) public ticketTiers;
    mapping(uint256 => bool) public isUsed;
    uint256 tokenCounter;
    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    function addNewTier(uint256 _tierPrice, uint256 _tierMaxQuantity) external {
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

    function mintTicket(uint256 _tierIdentifier, uint256 _quantity)
        external
        payable
    {
        require(
            ticketTiers[_tierIdentifier].tierId != bytes32(0),
            "TIER Doesn't Exist"
        );
        require(
            ticketTiers[_tierIdentifier].tierPrice * _quantity == msg.value,
            "Send exact funds"
        );
        require(
            ticketTiers[_tierIdentifier].mintedSupply + _quantity <=
                ticketTiers[_tierIdentifier].tierMaxQuantity,
            "Exceeds max"
        );
        ticketTiers[_tierIdentifier].mintedSupply += _quantity;
        for(uint256 i; i<_quantity;i++){
            tokenCounter++;
            _mint(msg.sender, tokenCounter);
        }
    }
}
