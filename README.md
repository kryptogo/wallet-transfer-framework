# Wallet Transfer Framework (WTF)

This project is powered by [MessageKit](https://messagekit.ephemerahq.com/) and provides an AI-driven interface for cross-chain stablecoin transfers using XMTP protocol.

## Features

- **AI Integration**: Powered by OpenAI for natural language processing of transfer commands
- **Cross-Chain Support**: Currently supports Base and Ethereum networks
- **USDC Transfers**: Focused on USDC stablecoin transfers with optimized routing
- **Frame Integration**: Uses Base Tx Frame for transaction execution

## Quick Start Guide

### Step 1: Set up environment

```sh
# Navigate to project directory
cd ./wtf

# Set up environment variables
KEY= # the private key of the wallet
OPEN_AI_API_KEY= # sk-proj-...

# Install dependencies
bun install

# Run the project
bun dev
```

## Use Case: AI-Driven Transfers

### Demo Flow

1. **Trigger Action**: Bob enters, "Send 100 USDC to Alice."
2. **AI Interaction**: 
   - AI parses the natural language input into a structured `transfer` operation
   - AI suggests optimized routes based on transaction speed and cost
3. **User Confirmation**: Bob selects Base for its low fees and speed
4. **Execution**: WTF executes the transaction via Base Tx Frame, confirming success

## Available Commands

1. **Check Balance**:
   ```
   /balance [token] [chain]
   ```
   Example: `/balance USDC Base`

2. **Transfer Tokens**:
   ```
   /transfer [amount] [token] [recipient] [chain]
   ```
   Example: `/transfer 100 USDC 0x123... Base`

## Supported Networks

Currently supports:
- **Base**: Low fees (~$0.1), fast confirmation
- **Ethereum**: Higher fees (~$5), standard confirmation time

## Extensibility & Future Work

1. **WalletConnect Extension**: Extend WTF as an official WalletConnect extension
2. **Multilingual AI**: Expand support for additional languages
3. **Advanced Analytics**: Integrate predictive gas fee optimization
4. **Cross-Chain Collaboration**: Strengthen compatibility with emerging blockchain architectures

## Why WTF?

### Developer Benefits

- Simplifies integration of AI-driven natural language processing into wallets
- Reduces complexity of handling multi-chain transactions
- Offers a future-ready solution for expanding WalletConnect capabilities

### User Benefits

- Provides a conversational interface for seamless transaction execution
- Reduces decision fatigue with optimized route recommendations
- Supports interoperability across diverse blockchain networks

---

Made with ❤️ by [XMTP](https://xmtp.org)