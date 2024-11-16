import '../ai/ai_model.dart';
import '../blockchain/blockchain.dart';
import '../models/transfer_request.dart';
import '../models/transfer_option.dart';
import '../models/transfer_result.dart';

/// Manages wallet operations by coordinating between AI and blockchain layers
class WalletOperations {
  final AIModel aiModel;
  final Blockchain blockchain;

  WalletOperations({
    required this.aiModel,
    required this.blockchain,
  });

  /// Process natural language transfer request
  Future<CreateTransferRequest> processTransferCommand(String command) async {
    final transferData = await aiModel.processNaturalLanguage(command);
    return CreateTransferRequest.fromJson(transferData);
  }

  /// Get available transfer options for a request
  Future<List<TransferOption>> getTransferOptions(
      CreateTransferRequest request) async {
    final options = <TransferOption>[];

    // Get options from each relevant blockchain connector
    if (blockchain.type == BlockchainType.multiChain) {
      for (final type in BlockchainType.values) {
        if (type != BlockchainType.multiChain) {
          try {
            final connector = blockchain.getConnector(type);
            final connectorOptions =
                await connector.getTransferOptions(request);
            options.addAll(connectorOptions);
          } catch (e) {
            // Skip if connector doesn't support the token or has an error
            continue;
          }
        }
      }
    } else {
      final connector = blockchain.getConnector(blockchain.type);
      options.addAll(await connector.getTransferOptions(request));
    }

    // Use AI to analyze and sort options by best value
    if (options.isNotEmpty) {
      final analysis = await aiModel.analyzeTransferOptions(
        options.map((o) => o.toJson()).toList(),
      );
      // Sort options based on AI analysis
      // TODO: Implement sorting logic based on AI recommendations
    }

    return options;
  }

  /// Execute a transfer using the selected option
  Future<TransferResult> executeTransfer(
    CreateTransferRequest request,
    TransferOption selectedOption,
  ) async {
    // Determine which blockchain to use based on the selected route
    final blockchainType = _getBlockchainTypeFromRoute(selectedOption.route);
    final connector = blockchain.getConnector(blockchainType);

    // Validate the transfer before execution
    if (!await connector.validateAddress(request.recipientAddress)) {
      return TransferResult.failure(
        errorMessage: 'Invalid recipient address for ${selectedOption.route}',
      );
    }

    final balance = await connector.getBalance(
      request.senderAddress,
      request.tokenSymbol,
    );
    if (balance < request.amount) {
      return TransferResult.failure(
        errorMessage: 'Insufficient balance',
        details: {
          'available': balance,
          'required': request.amount,
          'token': request.tokenSymbol,
        },
      );
    }

    // Execute the transfer
    final result = await connector.executeTransfer(request, selectedOption);

    // If successful, wait for confirmation
    if (result.success && result.transactionHash != null) {
      final confirmed =
          await connector.confirmTransfer(result.transactionHash!);
      if (!confirmed) {
        return TransferResult.failure(
          errorMessage: 'Transfer failed to confirm',
          details: {'transactionHash': result.transactionHash},
        );
      }
    }

    return result;
  }

  /// Get blockchain type from route string
  BlockchainType _getBlockchainTypeFromRoute(String route) {
    final routeLower = route.toLowerCase();
    if (routeLower.contains('tron')) return BlockchainType.tron;
    if (routeLower.contains('eth')) return BlockchainType.ethereum;
    if (routeLower.contains('btc')) return BlockchainType.btc;
    if (routeLower.contains('sol')) return BlockchainType.solana;
    if (routeLower.contains('sui')) return BlockchainType.sui;
    if (routeLower.contains('kaspa')) return BlockchainType.kaspa;
    throw ArgumentError('Unsupported route: $route');
  }

  /// Generate user-friendly explanation of a transfer
  Future<String> explainTransfer(TransferResult result) async {
    return aiModel.generateExplanation(result.toJson());
  }
}
