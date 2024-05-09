// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NFT Ownership Schema Resolver
 * This resolver allows attestations based on NFT ownership of a specified amount.
 */
contract NFTOwnershipResolver is SchemaResolver, Ownable {
    IERC721 public nftContract; // NFT contract
    uint256 public minNFTCount; // Minimum NFTs required to allow attestation

    event MinNFTCountUpdated(address indexed updater, uint256 newMinCount);

    constructor(IEAS eas, address initialOwner, IERC721 _nftContract, uint256 _minNFTCount) SchemaResolver(eas) Ownable(initialOwner) {
        nftContract = _nftContract;
        setMinNFTCount(_minNFTCount);
    }

    /**
     * @dev Sets the minimum number of NFTs required for attestation eligibility.
     * @param _minNFTCount the new minimum count of NFTs
     */
    function setMinNFTCount(uint256 _minNFTCount) public onlyOwner {
        require(_minNFTCount >= 1, "Minimum NFT count cannot be less than 1.");
        minNFTCount = _minNFTCount;
        emit MinNFTCountUpdated(msg.sender, _minNFTCount);
    }

    function onAttest(Attestation calldata attestation, uint256 /* value */) internal view override returns (bool) {
        // Check if the destination address owns at least the minimum required number of NFTs
        uint256 balance = nftContract.balanceOf(attestation.recipient);
        return balance >= minNFTCount;
    }

    function onRevoke(Attestation calldata /* attestation */, uint256 /* value */) internal pure override returns (bool) {
        // Logic to handle when an attestation is revoked, if necessary
        return true;
    }
}
