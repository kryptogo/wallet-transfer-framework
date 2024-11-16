# Wallet Translation Framework (WTF)
The **Wallet Translation Framework (WTF)** is an innovative AI-driven platform that simplifies cryptocurrency transactions through natural language processing (NLP). By combining AI with Universal Transfer Operations (UTO) and seamless integration into blockchain wallets, WTF redefines how users interact with blockchain technology.
## Purpose of WTF

The primary goal of WTF is to provide a natural, user-friendly interface for managing blockchain-based transactions. The framework combines AI-driven processing with cross-chain stablecoin transfer capabilities to reduce complexity and increase accessibility for end-users and developers.

### High-Level Architecture

```
+-------------------+       +--------------------+       +-------------------+
| User Interface    |       | AI Parsing Engine |       | Wallet Operations |
| (Flutter App)     |       | (WTF SDK)         |       | (Custom Impl.)    |
+-------------------+       +--------------------+       +-------------------+
        |                           |                          |
        | Natural Language Input    |                          |
        +-------------------------> |                          |
        |                           |                          |
        |                           | +---------------------+  |
        |                           | |      AI Model       |  |
        |                           | +---------------------+  |
        |                           |        |                 |
        |                           | Parses Input             |
        |                           +----------------------->  |
        |                           |                          |
        |                           | Converts to UTO          |
        |                           +----------------------->  |
        |                           |                          |
        |                           | Wallet Operation Call    |
        +----------------------------------------------------> |
        |                           |                          |
        |        Result             |                          |
        +<--------------------------+                          |
        |                                                      |
        +----------------------------------------------------> |
```

## Why Combine WTF with LLM?

1. **Enhanced Usability**:
   - Leverages AI-powered natural language processing (NLP) to convert casual language into actionable commands.
   - Example: "Send 100 USDC to Alice" → `/transfer 100 USDC alice.eth Base`

2. **Cross-Chain Interoperability**:
   - Supports Base and Ethereum networks, enabling seamless transfers of stablecoins like USDC.
   - Unified abstraction for multi-chain operations.

3. **Optimized Execution**:
   - AI models provide intelligent suggestions for transaction routing, balancing speed, cost, and efficiency.

4. **Developer Efficiency**:
   - Reduces the complexity of integrating multi-chain functionalities into wallet applications.

## Importance of Universal Transfer Operations (UTO)

UTO establishes a standardized interface for executing blockchain payment and transfer operations. This abstraction enhances cross-chain interoperability and simplifies integration across diverse blockchain systems.

### Key Features:
- **Cross-Chain Abstraction**: A unified layer compatible with multiple blockchain architectures.
- **AI-Driven Workflow**: Transforms natural language inputs into structured wallet operations.
- **Plug-and-Play Integration**: Simplifies wallet implementation for developers.

### UTO Core Operations:
| Operation            | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `create_transfer`     | Initializes a transfer request.                                             |
| `validate_transfer`   | Verifies transfer details like balances and compatibility.                  |
| `get_transfer_options`| Provides route options based on chains, tokens, and fees.                  |
| `execute_transfer`    | Executes the transfer using the chosen route.                              |
| `confirm_transfer`    | Confirms the successful completion of the transfer.                        |

## Implementations of WTF

WTF is implemented through two main approaches: **Flutter** and **XMTP**.

### 1. Flutter Implementation

#### Overview:
The Flutter implementation of WTF leverages the SDK to enable seamless integration into mobile applications, allowing developers to build intuitive interfaces for blockchain transactions. It implements the Universal Transfer Operations (UTO) standard for consistent cross-chain functionality.

```
+-------------------+       +----------------------+       +-------------------+
| Flutter UI        |       | WTF SDK              |       | WalletOperations  |
| - User Input      |       | - AI Processing      |       | Interface         |
| - Status Display  |       | - Command Parser     |       |                   |
+-------------------+       +----------------------+       +-------------------+
        |                           |                              |
        | "Send 100 USDC"           |                              |
        +-------------------------> |                              |
        |                           |                              |
        |                           | 1. createTransfer            |
        |                           +----------------------------> |
        |                           |                              |
        |                           | 2. validateTransfer          |
        |                           +----------------------------> |
        |                           |                              |
        |                           | 3. getTransferOptions        |
        |                           +----------------------------> |
        |                           |                              |
        |                           | 4. executeTransfer           |
        |                           +----------------------------> |
        |                           |                              |
        |                           | 5. confirmTransfer           |
        |                           +----------------------------> |
        |                           |                              
        |     Status Updates        |                              
        | <-------------------------+                             
```

#### Key Features:
- **Modular Design**: 
  - Developers only need to implement essential UTO interfaces
  - Standardized implementation patterns for blockchain operations
  - Clean separation between UI, business logic, and blockchain operations

- **Rapid Scalability**: 
  - Supports Base and Ethereum networks out of the box
  - Extensible architecture for adding new chains
  - Unified interface for multi-chain operations

- **Seamless AI Integration**: 
  - Natural language processing for command interpretation
  - Intelligent routing based on gas fees and network conditions
  - Flexible prompt system for command processing

#### Workflow:
1. **Interface Definition**:
   - Implements core UTO operations through standardized interfaces
   - Provides type-safe request/response models
   - Handles cross-chain compatibility

2. **Implementation in Flutter**:
   - Developers implement WalletOperations interface
   - Support for both synchronous and asynchronous operations
   - Built-in error handling and validation

3. **AI Integration**:
   - Converts natural language to structured commands
   - Validates input parameters and chain compatibility
   - Provides intelligent suggestions for optimal routes

4. **Execution and Feedback**:
   - Real-time transaction status updates
   - Detailed error reporting
   - Transaction confirmation handling

#### Core Interface:
```dart
abstract class WalletOperations {
  // Initialize transfer request with validation
  Future<TransactionResult> createTransfer(CreateTransferRequest request);
  
  // Execute the validated transfer
  Future<TransactionResult> executeTransfer(TransferExecutionRequest request);
  
  // Get available transfer routes with fees
  Future<List<TransferOption>> getTransferOptions(CreateTransferRequest request);
  
  // Confirm transaction completion
  Future<ConfirmationResult> confirmTransfer(String transactionHash);
}
```

#### Testing:
Basic test setup requires:

1. Environment configuration:
```
OPENAI_API_KEY=your_openai_api_key
```

2. Running tests:
```bash
flutter pub get
flutter test test/basic/main_test.dart
```

### 2. XMTP and MessageKit Implementation

#### Overview:
This implementation uses the XMTP protocol for decentralized messaging combined with MessageKit to enable cross-chain stablecoin transfers via AI. The system processes natural language commands through a sophisticated prompt system and executes transfers via TxPay and KryptoGO integration.

```
+-------------------+       +----------------------+       +-------------------+
| XMTP Client       |       | WTF SDK              |       | Wallet Operations |
| - MessageKit UI   |       | - AI Processing      |       | - TxPay           |
| - Command Input   |       | - Command Parser     |       | - KryptoGO        |
+-------------------+       +----------------------+       +-------------------+
        |                           |                              |
        | "Send 100 USDC to Alice"  |                              |
        +-------------------------> |                              |
        |                           |                              |
        |                           | 1. Parse Natural Language    |
        |                           | +--------------------+       |
        |                           | | AI Prompt System   |       |
        |                           | | - Command Analysis |       |
        |                           | - Parameter Extract  |       |
        |                           | +--------------------+       |
        |                           |                              |
        |                           | 2. Validate Parameters       |
        |                           | - Address Format             |
        |                           | - ENS Resolution             |
        |                           | - Token Compatibility        |
        |                           |                              |
        |                           | 3. Route Selection           |
        |                           +----------------------------> |
        |                           |                              |
        |                           | 4. Fee Estimation            |
        |                           +----------------------------> |
        |                           |                              |
        |                           | 5. Execute Transfer          |
        |                           +----------------------------> |
        |                           |                              
        |     Transaction URL       |                              
        | <-------------------------+                              
        |                           |                              
        |     Status & Fees         |                              
        | <-------------------------+                              
        |                           |                              
        |     Alternative Routes    |                              
        | <-------------------------+                              
```

#### Key Features:
- **AI-Driven Messaging**:
  - Utilizes NLP for processing transfer commands in decentralized messaging
  - Implements a comprehensive prompt system for command interpretation
  - Supports both direct commands and natural language inputs
  
- **Cross-Chain Support**:
  - Facilitates USDC transfers on Ethereum (0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)
  - Supports Base network (0x833589fcd6edb6e08f4c7c32d4f71b54bda02913)
  - Smart routing based on gas fees and confirmation times
  
- **User-Friendly Interface**:
  - Supports ENS domain resolution for human-readable addresses
  - Provides detailed transaction feedback including fees and confirmation times
  - Handles both balance checks and transfers through unified commands

#### Supported Commands:
1. Balance Check:
   ```
   /balance [token] [chain]
   Example: /balance USDC Base
   ```

2. Transfer:
   ```
   /transfer [amount] [token] [recipientAddress] [chain]
   Example: /transfer 100 USDC alice.eth Base
   ```

#### Technical Implementation:
1. **Message Processing**:
   - Implements XMTP's MessageKit for handling user inputs
   - Uses structured handler pattern for command processing
   - Supports both direct commands and AI-interpreted natural language

2. **Transaction Execution**:
   - Integrates with TxPay for transaction execution
   - Supports multiple chain configurations
   - Implements automatic fee estimation and route optimization

3. **Error Handling**:
   - Validates chain support and token compatibility
   - Verifies address formats and ENS resolution
   - Provides clear error messages for failed operations

#### Example Workflow:
1. **User Input**:
   - User sends a message: "Send 100 USDC to Alice"
   
2. **AI Processing**:
   - System processes input through AI prompt system
   - Converts natural language to structured command
   - Validates parameters and chain support
   
3. **Transaction Execution**:
   - Generates transaction URL with appropriate parameters
   - Routes transaction through optimal chain based on fees
   - Executes transfer via TxPay or KryptoGO integration
   
4. **Response Handling**:
   - Provides transaction details and confirmation URL
   - Shows estimated fees and processing time
   - Offers alternative routes if available


### Development Setup

Requirements:
- **Node.js**: Version 20 or higher.
- **TypeScript**: For type safety.
- **Bun**: As a package manager.
- **ESM Modules**: For modular architecture.

How to Get Started:
1. Clone the repository.
2. Install dependencies using Bun:
   ```bash
   bun install
   ```
3. Run the project:
   ```bash
   bun start
   ```

## Extensibility and Future Directions

WTF is designed with extensibility in mind, making it adaptable for future blockchain and AI advancements.

### Future Work:
1. **WalletConnect Integration**:
   - Extend WTF as an official WalletConnect extension.
2. **Multilingual AI**:
   - Support additional languages for a global audience.
3. **Predictive Analytics**:
   - Incorporate gas fee optimization and transaction forecasting.
4. **Expanded Blockchain Support**:
   - Strengthen compatibility with emerging blockchain architectures.
   - Currently supports: **Base**, **Arbitrum**

## License

This project is licensed under the MIT License. See the [LICENSE](https://www.notion.so/kryptogo/LICENSE) file for details.

## Made with ❤️ by
[MessageKit](https://messagekit.ephemerahq.com), [XMTP](https://xmtp.org), and [Converse](https://converse.xyz/dm/wtfagent.converse.xyz).