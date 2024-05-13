// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import "@ethereum-attestation-service/eas-contracts/contracts/resolver/SchemaResolver.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title AttesterAllowlistResolver
/// @notice This contract allows an owner to manage an allowlist of attesters
contract AttesterAllowlistResolver is SchemaResolver, Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private _allowlist;

    event AddedToAllowlist(address indexed addedBy, address indexed attester);
    event RemovedFromAllowlist(
        address indexed removedBy,
        address indexed attester
    );

    constructor(IEAS eas, address initialOwner)
        SchemaResolver(eas)
        Ownable(initialOwner)
    {}

    function onAttest(
        Attestation calldata attestation,
        uint256 /*value*/
    ) internal view override returns (bool) {
        return _allowlist.contains(attestation.attester);
    }

    function onRevoke(
        Attestation calldata, /*attestation*/
        uint256 /*value*/
    ) internal pure override returns (bool) {
        return true;
    }

    function addToAllowlist(address attester) public {
        _allowlist.add(attester);
        emit AddedToAllowlist(msg.sender, attester);
    }

    function removeFromAllowlist(address attester) public {
        _allowlist.remove(attester);
        emit RemovedFromAllowlist(msg.sender, attester);
    }

    function lengthAllowlist() public view returns (uint256) {
        return _allowlist.length();
    }

    function isPresentAllowlist(address attester) public view returns (bool) {
        return _allowlist.contains(attester);
    }

    function getAllowlist() public view returns (address[] memory) {
        address[] memory allowlist = new address[](_allowlist.length());
        for (uint256 i = 0; i < _allowlist.length(); i++) {
            allowlist[i] = _allowlist.at(i);
        }
        return allowlist;
    }
}
