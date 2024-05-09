// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./NFTOwnershipResolver.sol";

contract NFTOwnershipResolverFactory {
    mapping(address => address[]) public deployedResolvers; // deployer => resolvers

    event ResolverDeployed(address indexed owner, address indexed resolverAddress);

    function createNFTOwnershipResolver(IEAS eas, IERC721 _nftContract, uint256 _minNFTCount) public {
        NFTOwnershipResolver newResolver = new NFTOwnershipResolver(eas, msg.sender, _nftContract, _minNFTCount);
        deployedResolvers[msg.sender].push(address(newResolver));
        emit ResolverDeployed(msg.sender, address(newResolver));
    }

    function getDeployedResolvers(address deployer) public view returns (address[] memory) {
        return deployedResolvers[deployer];
    }
}