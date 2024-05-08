// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";

/// @title AttesterAllowlistResolver
/// @notice This contract allows an owner to manage an allowlist of attesters and optionally allows the public to add themselves within a time limit.
contract AttesterAllowlistResolver is SchemaResolver {
    address private _owner;
    mapping(address => bool) private _allowlist;
    uint256 public endTimestamp;  // 0 means no deadline

    event AddedToAllowlist(address indexed addedBy, address indexed attester);
    event RemovedFromAllowlist(address indexed removedBy, address indexed attester);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event EndTimeModified(uint256 newEndTime);
    
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the owner can perform this action");
        _;
    }

    constructor(IEAS eas, uint256 _endTimestamp) SchemaResolver(eas) {
        _owner = msg.sender;
        // Check if the _endTimestamp is not zero to set the deadline
        if (_endTimestamp != 0) {
            endTimestamp = _endTimestamp;
        }
    }

    function onAttest(Attestation calldata attestation, uint256 /*value*/) internal view override returns (bool) {
        return _allowlist[attestation.attester];
    }

    function onRevoke(Attestation calldata /*attestation*/, uint256 /*value*/) internal pure override returns (bool) {
        return true;
    }

    function addSelfToAllowlist() public {
        require(endTimestamp == 0 || block.timestamp <= endTimestamp, "Cannot add to allowlist after deadline");
        _allowlist[msg.sender] = true;
        emit AddedToAllowlist(msg.sender, msg.sender);
    }

    function addToAllowlist(address attester) public onlyOwner {
        _allowlist[attester] = true;
        emit AddedToAllowlist(msg.sender, attester);
    }

    function removeFromAllowlist(address attester) public onlyOwner {
        _allowlist[attester] = false;
        emit RemovedFromAllowlist(msg.sender, attester);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function modifyEndTime(uint256 newEndTime) public onlyOwner {
        endTimestamp = newEndTime;
    }
}
