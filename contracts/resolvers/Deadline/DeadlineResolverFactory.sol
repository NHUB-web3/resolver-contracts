// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import "./DeadlineResolver.sol";

contract DeadlineResolverFactory {
    mapping(address => address[]) public deployedResolvers; // deployer => resolvers

    event ResolverDeployed(address indexed owner, address indexed resolverAddress);

    function createDeadlineResolver(IEAS eas, uint256 _deadline, uint256 _minimumTimeBetweenDeadlines) public {
        DeadlineResolver newResolver = new DeadlineResolver(eas, msg.sender, _deadline, _minimumTimeBetweenDeadlines);
        deployedResolvers[msg.sender].push(address(newResolver));
        emit ResolverDeployed(msg.sender, address(newResolver));
    }

    function getDeployedResolvers(address deployer) public view returns (address[] memory) {
        return deployedResolvers[deployer];
    }
}
