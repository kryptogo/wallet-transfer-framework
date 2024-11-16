import 'package:wtf_sdk/wtf_sdk.dart';

void main() async {
  // Initialize the WTF SDK with OpenAI for natural language processing
  final wtf = WTF(
    aiModel: OpenAIModel(apiKey: 'your-api-key'),
    blockchain: Blockchain(type: BlockchainType.multiChain),
  );

  try {
    // Process a natural language transfer command
    final request = await wtf.walletOperations.processTransferCommand(
        'Send 100 USDT to 0x742d35Cc6634C0532925a3b844Bc454e4438f44e');

    // Get available transfer options
    final options = await wtf.walletOperations.getTransferOptions(request);
    print('Available transfer options:');
    for (final option in options) {
      print('- ${option.route}: ${option.fee} fee, ${option.estimatedTime}');
    }

    if (options.isEmpty) {
      print('No transfer options available');
      return;
    }

    // Select the first option (in a real app, user would choose)
    final selectedOption = options.first;
    print('\nSelected route: ${selectedOption.route}');

    // Execute the transfer
    final result = await wtf.walletOperations.executeTransfer(
      request,
      selectedOption,
    );

    // Get AI-generated explanation of the transfer
    final explanation = await wtf.walletOperations.explainTransfer(result);

    if (result.success) {
      print('\nTransfer successful!');
      print('Transaction hash: ${result.transactionHash}');
    } else {
      print('\nTransfer failed!');
      print('Error: ${result.errorMessage}');
    }

    print('\nAI Explanation: $explanation');
  } catch (e) {
    print('Error: $e');
  }
}
