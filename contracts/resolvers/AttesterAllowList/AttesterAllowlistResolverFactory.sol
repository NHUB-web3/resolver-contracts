// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import "./AttesterAllowlistResolver.sol";

contract AttesterAllowlistResolverFactory {
    mapping(address => address[]) public deployedResolvers; // deployer => resolvers

    event ResolverDeployed(address indexed owner, address indexed resolverAddress);

    function createAttesterAllowlistResolver(IEAS eas, uint256 _endTimestamp) public {
        AttesterAllowlistResolver newResolver = new AttesterAllowlistResolver(eas, _endTimestamp);
        deployedResolvers[msg.sender].push(address(newResolver));
        emit ResolverDeployed(msg.sender, address(newResolver));
    }

    function getDeployedResolvers() public view returns (address[] memory) {
        return deployedResolvers;
    }
}
