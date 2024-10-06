// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const CarBlock = buildModule("CarBlock", (m) => {
 

  const CarBlock = m.contract("CarBlock");

  return { CarBlock };
});

export default CarBlock;
