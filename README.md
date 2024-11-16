# Wallet Transfer Framework (WTF)

The **Wallet Transfer Framework (WTF)** is a **Flutter SDK** built on the foundation of **Universal Transfer Operations (UTO)**. It simplifies blockchain payments and transfers by integrating **AI-driven natural language processing** with **cross-chain abstraction**, enabling developers to build intelligent, user-friendly wallets and applications. WTF aims to extend and complement **WalletConnect** by adding AI-driven natural language interfaces for enhanced wallet functionality.

---

## Universal Transfer Operations (UTO): The Foundation of WTF

The **Universal Transfer Operations (UTO)** define a standard interface for executing payment and transfer operations on any blockchain. UTO abstracts wallet interactions into a set of **basic operations**, enabling:

1. **Cross-Chain Interoperability**: A unified abstraction layer compatible with all blockchain architectures.
2. **AI-Driven Workflow**: Transforms natural language inputs into deterministic wallet operations for execution.
3. **Developer Efficiency**: Simplifies wallet implementation and testing for diverse blockchain systems.

### UTO Operations

The following **basic operations** are defined by UTO and form the core of WTF's wallet interaction logic:

| Operation              | Description                                                     |
| ---------------------- | --------------------------------------------------------------- |
| `create_transfer`      | Initializes a transfer request with required parameters.        |
| `validate_transfer`    | Validates the transfer details (e.g., balances, compatibility). |
| `get_transfer_options` | Provides route options (e.g., chains, tokens, fees, speed).     |
| `execute_transfer`     | Executes the transfer using the chosen route and parameters.    |
| `confirm_transfer`     | Confirms the transfer was successfully completed.               |

---

## Features

- **AI Integration**: Works with Claude, OpenAI, and custom models to process natural language commands for transfers.
- **Abstracted Transfer Operations**: Unified API to handle transfers across diverse blockchain ecosystems.
- **Cross-Chain Compatibility**: Supports Sui, BTC, Solana, Kaspa, EVM-based blockchains, and TRON.
- **Plug-and-Play AI**: Enhances existing WalletConnect sessions with natural language capabilities, requiring minimal integration effort.

---

## Installation

To add WTF to your Flutter project, include the following dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  wtf_sdk: ^1.0.0
```

Run `flutter pub get` to install the package.

---

## Quick Start Guide

### Step 1: Initialize the Framework

```dart
import 'package:wtf_sdk/wtf_sdk.dart';

void main() {
  final wtf = WTF(
    aiModel: OpenAIModel(apiKey: 'your-api-key'),
    blockchain: Blockchain.multiChain, // Enables multi-chain compatibility
  );

  runApp(MyApp(wtf: wtf));
}
```

### Step 2: Create a Transfer Request

```dart
final transferRequest = CreateTransferRequest(
  senderAddress: "0xSenderAddress",
  recipientAddress: "0xRecipientAddress",
  amount: 100.0,
  tokenSymbol: "USDT",
);
```

### Step 3: Get Transfer Options

```dart
final transferOptions = await wtf.walletOperations.getTransferOptions(transferRequest);

for (final option in transferOptions) {
  print("Route: ${option.route}, Fee: ${option.fee}, Estimated Time: ${option.estimatedTime}, Security: ${option.securityLevel}");
}
```

**Example Output**:
```json
[
  {
    "route": "TRON-TRC20",
    "fee": 0.2,
    "estimatedTime": "2 seconds",
    "securityLevel": "High",
    "compatibility": "Full"
  },
  {
    "route": "Ethereum-ERC20",
    "fee": 5.0,
    "estimatedTime": "30 seconds",
    "securityLevel": "High",
    "compatibility": "Partial"
  }
]
```

### Step 4: Execute the Transfer

```dart
final selectedOption = transferOptions.first; // Choose the best option
final result = await wtf.walletOperations.broadcastTransfer(selectedOption);

if (result.success) {
  print("Transaction successful: ${result.transactionHash}");
} else {
  print("Transaction failed: ${result.errorMessage}");
}
```

---

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

---

## Contributing

Contributions are welcome! Please follow the [Contributing Guidelines](https://www.notion.so/kryptogo/CONTRIBUTING.md) and ensure all pull requests pass the CI pipeline.

---

## License

This project is licensed under the MIT License. See the [LICENSE](https://www.notion.so/kryptogo/LICENSE) file for details.


# How to run basic test

### 1. Add .env file to the root of the project
```
OPENAI_API_KEY=your_openai_api_key
CLAUDE_API_KEY=your_anthropic_api_key
```

### 2. Run the test
```bash
flutter pub get
flutter test test/basic/main_test.dart
```
