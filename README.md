# Advanced ERC20 Token

## Overview
`AdvancedERC20` is an enhanced version of the standard ERC20 token, incorporating additional features such as minting, burning, pausing, and unpausing capabilities, along with an anti-whale mechanism to prevent large, disruptive transactions. This contract aims to provide a more controlled and flexible token management system suitable for various decentralized applications.

## Features

### Minting
- **Enabled/Disabled State**: Minting can be enabled or disabled by the contract owner, providing control over the creation of new tokens.
- **Controlled Issuance**: When enabled, new tokens can be minted and assigned to specified accounts, allowing for controlled supply expansion.

### Burning
- **Enabled/Disabled State**: Burning can be enabled or disabled by the contract owner.
- **Token Destruction**: When enabled, token holders can burn their tokens, reducing the total supply, which can be useful for mechanisms like deflationary models or rewards.

### Pausing
- **Pause/Unpause Capabilities**: The contract can be paused or unpaused by the contract owner, halting all transfers, minting, and burning actions. This feature is critical for emergency stop mechanisms or upgrades.

### Anti-Whale Mechanism
- **Maximum Transaction Amount**: The contract includes a limit on the maximum number of tokens that can be transferred in a single transaction. This feature helps prevent market manipulation and ensures stability.

## How to Use

### Deploying
- To deploy this contract, provide the `name`, `symbol`, and `maxTxAmount` during the deployment process. This sets up the token with your desired parameters.

### Interacting with the Contract
- **Mint Tokens**: If minting is enabled, the contract owner can issue new tokens to any address.
- **Burn Tokens**: If burning is enabled, token holders can destroy their tokens to reduce the total circulating supply.
- **Pause/Unpause Contract**: The owner can pause all activities in case of vulnerabilities or unforeseen issues and resume once resolved.
- **Transfer Ownership**: Ownership of the contract can be transferred to a new address, which then gains the ability to control minting, burning, and pausing functionalities.

## Installation

To interact with or deploy this contract, you need tools like [Truffle](https://www.trufflesuite.com/) or [Hardhat](https://hardhat.org/):


npm install -g truffle
truffle init
truffle migrate --network <your_network>


npm install --save-dev hardhat
npx hardhat



const { expect } = require("chai");

describe("AdvancedERC20", function() {
  it("Should return the total supply after minting", async function() {
    const [owner] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("AdvancedERC20");
    const hardhatToken = await Token.deploy("TestToken", "TT", 1000);

    const initialSupply = await hardhatToken.totalSupply();
    await hardhatToken.mint(owner.address, 500);
    expect(await hardhatToken.totalSupply()).to.equal(initialSupply.add(500));
  });
});


