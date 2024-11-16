import 'package:wtf_sdk/wtf_sdk.dart';

void main() async {
  // Initialize the WTF SDK with OpenAI for natural language processing
  final wtf = WTF(
    aiModel: OpenAIModel(apiKey: 'your-api-key'),
    blockchain: Blockchain(type: BlockchainType.multiChain),
  );

  // Example natural language commands
  final commands = [
    'Send 50 USDT to Alice using the fastest route',
    'Transfer 1 ETH to 0x742d35Cc6634C0532925a3b844Bc454e4438f44e with lowest fees',
    'Pay Bob 100 USDC using the most secure method',
  ];

  for (final command in commands) {
    try {
      print('\nProcessing command: "$command"');

      // Process the natural language command
      final request =
          await wtf.walletOperations.processTransferCommand(command);
      print('\nParsed request:');
      print('- From: ${request.senderAddress}');
      print('- To: ${request.recipientAddress}');
      print('- Amount: ${request.amount} ${request.tokenSymbol}');

      // Get transfer options
      final options = await wtf.walletOperations.getTransferOptions(request);
      print('\nAvailable routes:');
      for (final option in options) {
        print('- ${option.route}');
        print('  • Fee: ${option.fee}');
        print('  • Time: ${option.estimatedTime}');
        print('  • Security: ${option.securityLevel}');
      }

      if (options.isEmpty) {
        print('No suitable transfer routes found');
        continue;
      }

      // Select the best option based on the command context
      final selectedOption =
          options.first; // In real app, AI would choose best option
      print('\nSelected route: ${selectedOption.route}');

      // Execute the transfer
      final result = await wtf.walletOperations.executeTransfer(
        request,
        selectedOption,
      );

      // Get AI explanation of the transfer
      final explanation = await wtf.walletOperations.explainTransfer(result);

      print('\nTransfer Status: ${result.success ? 'Success' : 'Failed'}');
      if (result.success) {
        print('Transaction Hash: ${result.transactionHash}');
      } else {
        print('Error: ${result.errorMessage}');
      }

      print('\nAI Explanation: $explanation');
    } catch (e) {
      print('\nError processing command "$command": $e');
    }

    print('\n' + '-' * 80); // Separator between commands
  }
}
