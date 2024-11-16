# wtf

This project is powered by [MessageKit](https://messagekit.ephemerahq.com/) 


## Use Case: AI-Driven Transfers

### Demo Flow

1. **Trigger Action**: Bob enters, "Send 100 USDT to Alice."
2. **AI Interaction**: 
   - AI parses the natural language input into a structured `create_transfer` operation.
   - AI suggests optimized routes based on transaction speed and cost.
3. **User Confirmation**: Bob selects TRON-TRC20 for its low fees and speed.
4. **Execution**: WTF executes the transaction via TRONConnector, confirming success.

---

## Extensibility & Future Work

1. **WalletConnect Extension**: Extend WTF as an official WalletConnect extension to natively support natural language operations across WalletConnect-compatible wallets.
2. **Multilingual AI**: Expand support for additional languages to improve user accessibility globally.
3. **Advanced Analytics**: Integrate predictive gas fee optimization and transaction batching for enhanced performance.
4. **Cross-Chain Collaboration**: Strengthen compatibility with emerging blockchain architectures.

---

## Why WTF?

### Developer Benefits

- Simplifies integration of AI-driven natural language processing into wallets.
- Reduces complexity of handling multi-chain transactions.
- Offers a future-ready solution for expanding WalletConnect capabilities.

### User Benefits

- Provides a conversational interface for seamless transaction execution.
- Reduces decision fatigue with optimized route recommendations.
- Supports interoperability across diverse blockchain networks.

## Setup

Follow these steps to set up and run the project:

1. **Navigate to the project directory:**

```sh
cd ./wtf
```

2. **Set up your environment variables:**

```sh
KEY= # the private key of the wallet
OPEN_AI_API_KEY= # sk-proj-...
```

3. **Install dependencies:**

```sh
bun install
```

4. **Run the project:**

```sh
bun dev
```

5. Enjoy!
---
Made with ❤️ by [XMTP](https://xmtp.org)