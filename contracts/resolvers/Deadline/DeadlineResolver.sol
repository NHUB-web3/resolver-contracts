// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Time Checker Schema Resolver
 * This resolver allows operations until a certain deadline, which can only be set by the owner and must extend the current one without updating past deadlines.
 */
contract DeadlineResolver is SchemaResolver, Ownable {
    uint256 public deadline;
    uint256 public minimumTimeBetweenDeadlines;

    event updateDeadline(address indexed updatedBy, uint256 indexed newDeadline);
    event MinimumDeadlineUpdated(address indexed updatedBy, uint256 newMinimumTime);

    constructor(IEAS eas, address initialOwner, uint256 _deadline, uint256 _minimumTimeBetweenDeadlines) SchemaResolver(eas) Ownable(initialOwner) {
        minimumTimeBetweenDeadlines = _minimumTimeBetweenDeadlines; // Set the initial minimum time between deadlines
        deadline = _deadline;
    }

    function setDeadline(uint256 newDeadline) public onlyOwner {
        require(block.timestamp < deadline, "Cannot update deadline if the current deadline is already past.");
        require(newDeadline >= deadline + minimumTimeBetweenDeadlines, "New deadline must be at least the minimum time ahead of the current deadline.");
        deadline = newDeadline;
        emit updateDeadline(msg.sender, newDeadline);
    }

    function setMinimumTimeBetweenDeadlines(uint256 _minimumTimeBetweenDeadlines) public onlyOwner {
        require(_minimumTimeBetweenDeadlines > minimumTimeBetweenDeadlines, "New minimum time must be greater than the current minimum time.");
        minimumTimeBetweenDeadlines = _minimumTimeBetweenDeadlines;
        emit MinimumDeadlineUpdated(msg.sender, _minimumTimeBetweenDeadlines);
    }

    function onAttest(Attestation calldata /*attestation*/, uint256 /*value*/) internal view override returns (bool) {
        return block.timestamp < deadline;
    }

    function onRevoke(Attestation calldata /*attestation*/, uint256 /*value*/) internal view override returns (bool) {
        return block.timestamp < deadline;
    }
}
