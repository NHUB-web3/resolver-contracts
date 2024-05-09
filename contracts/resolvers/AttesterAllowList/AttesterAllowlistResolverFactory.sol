// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import "./AttesterAllowlistResolver.sol";

contract AttesterAllowlistResolverFactory {
    mapping(address => address[]) public deployedResolvers; // deployer => resolvers

    event ResolverDeployed(address indexed owner, address indexed resolverAddress);

    function createAttesterAllowlistResolver(IEAS eas) public {
        AttesterAllowlistResolver newResolver = new AttesterAllowlistResolver(eas, msg.sender);
        deployedResolvers[msg.sender].push(address(newResolver));
        emit ResolverDeployed(msg.sender, address(newResolver));
    }

    function getDeployedResolvers(address deployer) public view returns (address[] memory) {
        return deployedResolvers[deployer];
    }
}
