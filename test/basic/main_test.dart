import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test/test.dart';

import '../../lib/wtf_sdk.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  test('test', () async {
    // read .env file for api key
    final apiKey = dotenv.env['OPENAI_API_KEY'];

    // Initialize the WTF SDK with OpenAI for natural language processing
    final wtf = WTF(
      aiModel: OpenAIModel(apiKey: ''),
      blockchain: Blockchain(type: BlockchainType.ethereum),
    );

    expect(wtf, isNotNull);

    try {
      // final mockRequest = CreateTransferRequest.fromJson({
      //   'senderAddress': 'myAddress',
      //   'recipientAddress': '0x742d35Cc6634C0532925a3b844Bc454e4438f44e',
      //   'amount': 100.0,
      //   'tokenSymbol': 'USDT'
      // });
      // var request = mockRequest;
      String command =
          'Send 100 USDT to 0x742d35Cc6634C0532925a3b844Bc454e4438f44e';
      print('👨‍🦲 user says: $command');
      // Process a natural language transfer command
      final request =
          await wtf.walletOperations.processTransferCommand(command);
      print('🤖 AI Parsed: ${request.toJson()}');
      // Get available transfer from wallet operations
      final options = await wtf.walletOperations.getTransferOptions(request);
      // print('[system] Available transfer options: ${options.length}');
      // for (final option in options) {
      //   print('- ${option.route}: ${option.fee} fee, ${option.estimatedTime}');
      // }

      if (options.isEmpty) {
        print('No transfer options available');
        return;
      }

      // Select the first option (in a real app, user would choose)
      final selectedOption = options.first;
      print('[system] Selected route: ${selectedOption.route}');

      // Execute the transfer
      final result = await wtf.walletOperations.executeTransfer(
        request,
        selectedOption,
      );
      // Get AI-generated explanation of the transfer
      final explanation = await wtf.walletOperations.explainTransfer(result);

      if (result.success) {
        print('[system] Transaction hash: ${result.transactionHash}');
      } else {
        print('[system] Error: ${result.errorMessage}');
      }
      print('🤖 AI Says: $explanation');
    } catch (e) {
      print('[system] Error: $e');
    }
  });
}
