import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import hre from "hardhat";
import sepolia from "@ethereum-attestation-service/eas-contracts/deployments/sepolia/EAS.json";
import baseSepolia from "@ethereum-attestation-service/eas-contracts/deployments/base-sepolia/EAS.json";
import arbitrumGoerli from "@ethereum-attestation-service/eas-contracts/deployments/arbitrum-goerli/EAS.json";

const DEFAULT_END_TIMESTAMP = 0;

const networkEASAddresses = {
  sepolia: sepolia.address,
  baseSepolia: baseSepolia.address,
  arbitrumGoerli: arbitrumGoerli.address,
};

const AttesterAllowlistResolverModule = buildModule("AttesterAllowlistResolverModule", (m) => {
  // Parameter for when the allowlist period should end
  const endTimestamp = m.getParameter("endTimestamp", DEFAULT_END_TIMESTAMP);
  const networkName = hre.network.name as keyof typeof networkEASAddresses;
  const easAddress = networkEASAddresses[networkName];

  // Ensure the easAddress is provided or set correctly
  if (!easAddress) {
    throw new Error("EAS address must be provided as a parameter.");
  }

  // Deployment of the AttesterAllowlistResolver contract
  const attesterAllowlistResolver = m.contract("AttesterAllowlistResolver", [easAddress, endTimestamp]);

  return { attesterAllowlistResolver };
});

export default AttesterAllowlistResolverModule;
