import '../../lib/src/models/transfer_request.dart';
import '../../lib/wtf_sdk.dart';

/// Example demonstrating multi-chain and cross-chain transfer capabilities
void main() async {
  // Initialize WTF SDK with multi-chain support
  final wtf = WTF(
    aiModel: OpenAIModel(apiKey: 'your-api-key'),
    blockchain: Blockchain(type: BlockchainType.multiChain),
  );

  // Example addresses for different chains
  const addresses = {
    BlockchainType.ethereum: '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
    BlockchainType.tron: 'TJYeasTPa6gpEEfYqH5zKS3gRJJx5uXUiN',
    BlockchainType.solana: '5D5NxYHf3vR3UPTLgXNQj5r1L4vqtgVBqKxeMQ5GJGBb',
    BlockchainType.sui:
        '0x42e8007621c038e2a84b0869d2aa960b133c282521acf2d6ce7d7f35840d1266',
  };

  // Example transfers to demonstrate multi-chain capabilities
  final transfers = [
    // Same chain transfer (Ethereum ERC20)
    {
      'from': addresses[BlockchainType.ethereum],
      'to': '0x8B3392483BA26D65E331dB86D4F430E9B3814E5e',
      'amount': 100.0,
      'token': 'USDT',
      'description': 'Ethereum USDT Transfer',
    },

    // Cross-chain transfer (Ethereum to TRON)
    {
      'from': addresses[BlockchainType.ethereum],
      'to': addresses[BlockchainType.tron],
      'amount': 50.0,
      'token': 'USDT',
      'description': 'ETH->TRON USDT Transfer',
    },

    // Multi-token transfer (Solana SOL and USDC)
    {
      'from': addresses[BlockchainType.solana],
      'to': '7JYZmXjcJvxEaJgQwKNt9YWJnofwzGWcKSCdqsWrBgxr',
      'amount': 1.0,
      'token': 'SOL',
      'description': 'Solana Native Transfer',
    },
  ];

  // Process each transfer
  for (final transfer in transfers) {
    try {
      print('\nProcessing ${transfer['description']}:');
      print('From: ${transfer['from']}');
      print('To: ${transfer['to']}');
      print('Amount: ${transfer['amount']} ${transfer['token']}');

      // Create transfer request
      final request = CreateTransferRequest(
        senderAddress: transfer['from'] as String,
        recipientAddress: transfer['to'] as String,
        amount: transfer['amount'] as double,
        tokenSymbol: transfer['token'] as String,
      );

      // Get available transfer options
      final options = await wtf.walletOperations.getTransferOptions(request);

      print('\nAvailable routes:');
      for (final option in options) {
        print('- ${option.route}');
        print('  • Fee: ${option.fee}');
        print('  • Time: ${option.estimatedTime}');
        print('  • Security: ${option.securityLevel}');
        print('  • Compatibility: ${option.compatibility}');
      }

      if (options.isEmpty) {
        print('No suitable transfer routes found');
        continue;
      }

      // Select best option (in real app, would be based on user preference or AI recommendation)
      final selectedOption = options.first;
      print('\nSelected route: ${selectedOption.route}');

      // Execute transfer
      final result = await wtf.walletOperations.executeTransfer(
        request,
        selectedOption,
      );

      // Print result
      if (result.success) {
        print('\nTransfer successful!');
        print('Transaction hash: ${result.transactionHash}');

        // Verify transfer on destination chain
        final confirmed = await wtf.walletOperations.blockchain
            .getConnector(_getBlockchainType(selectedOption.route))
            .confirmTransfer(result.transactionHash!);

        print('Transfer confirmed: $confirmed');
      } else {
        print('\nTransfer failed!');
        print('Error: ${result.errorMessage}');
        if (result.details != null) {
          print('Details: ${result.details}');
        }
      }
    } catch (e) {
      print('\nError processing transfer: $e');
    }

    print('\n' + '-' * 80); // Separator between transfers
  }
}

/// Helper function to determine blockchain type from route
BlockchainType _getBlockchainType(String route) {
  final routeLower = route.toLowerCase();
  if (routeLower.contains('tron')) return BlockchainType.tron;
  if (routeLower.contains('eth')) return BlockchainType.ethereum;
  if (routeLower.contains('sol')) return BlockchainType.solana;
  if (routeLower.contains('sui')) return BlockchainType.sui;
  if (routeLower.contains('btc')) return BlockchainType.btc;
  if (routeLower.contains('kaspa')) return BlockchainType.kaspa;
  throw ArgumentError('Unsupported route: $route');
}
