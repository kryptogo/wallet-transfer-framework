# WTF SDK Examples

This directory contains example implementations demonstrating various features of the Wallet Transfer Framework (WTF) SDK.

## Examples Overview

### 1. Basic Example (`basic/`)
Demonstrates the basic usage of the WTF SDK, including:
- SDK initialization
- Creating transfer requests
- Getting transfer options
- Executing transfers
- Handling results

```dart
// Run the basic example
dart run examples/basic/main.dart
```

### 2. AI-Driven Example (`ai_driven/`)
Shows how to use the AI capabilities of WTF SDK:
- Natural language processing for transfer commands
- AI-powered route selection
- Smart transfer explanations
- Context-aware decision making

```dart
// Run the AI-driven example
dart run examples/ai_driven/main.dart
```

### 3. Multi-Chain Example (`multi_chain/`)
Illustrates cross-chain transfer capabilities:
- Multi-chain setup and configuration
- Cross-chain transfers
- Chain-specific address validation
- Transfer route optimization
- Transaction confirmation across chains

```dart
// Run the multi-chain example
dart run examples/multi_chain/main.dart
```

## Prerequisites

Before running the examples:

1. Install dependencies:
```bash
flutter pub get
```

2. Configure your API keys:
   - Replace `'your-api-key'` in the examples with your actual OpenAI API key
   - Set up any required blockchain API keys in your environment

## Example Configuration

Each example can be configured by modifying the following parameters:
- AI model selection (OpenAI/Claude)
- Blockchain types
- Transfer amounts and addresses
- Token types

## Common Patterns

The examples demonstrate these common patterns:
1. SDK Initialization
```dart
final wtf = WTF(
  aiModel: OpenAIModel(apiKey: 'your-api-key'),
  blockchain: Blockchain(type: BlockchainType.multiChain),
);
```

2. Transfer Request Creation
```dart
final request = CreateTransferRequest(
  senderAddress: "sender-address",
  recipientAddress: "recipient-address",
  amount: 100.0,
  tokenSymbol: "USDT",
);
```

3. Getting Transfer Options
```dart
final options = await wtf.walletOperations.getTransferOptions(request);
```

4. Executing Transfers
```dart
final result = await wtf.walletOperations.executeTransfer(request, selectedOption);
```

## Error Handling

The examples include proper error handling patterns:
- Input validation
- Network error handling
- Blockchain-specific error cases
- Transaction confirmation failures

## Notes

- The examples use placeholder addresses and API keys
- Some blockchain operations are simulated
- Error handling is simplified for demonstration
- Real implementations should include proper security measures

## Contributing

Feel free to contribute additional examples by:
1. Creating a new directory under `examples/`
2. Adding your example implementation
3. Updating this README with documentation
4. Submitting a pull request

## Support

For questions about the examples:
- Check the main SDK documentation
- Open an issue on GitHub
- Contact the development team
