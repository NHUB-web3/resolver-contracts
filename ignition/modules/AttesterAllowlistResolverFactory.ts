import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const AttesterAllowlistResolverFactoryModule = buildModule("AttesterAllowlistResolverFactoryModule", (m) => {
  // Deploy the AttesterAllowlistResolverFactory contract
  const attesterAllowlistResolverFactory = m.contract("AttesterAllowlistResolverFactory", []);

  // Return the deployed contract instance for potential use in other modules or scripts
  return { attesterAllowlistResolverFactory };
});

export default AttesterAllowlistResolverFactoryModule;
