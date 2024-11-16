import 'ai/ai_model.dart';
import 'blockchain/blockchain.dart';
import 'operations/wallet_operations.dart';

/// Main WTF SDK class that provides access to wallet operations
class WTF {
  final AIModel aiModel;
  final Blockchain blockchain;
  late final WalletOperations walletOperations;

  /// Creates a new instance of the WTF SDK
  ///
  /// [aiModel] - The AI model implementation to use for natural language processing
  /// [blockchain] - The blockchain implementation to use for transfers
  WTF({
    required this.aiModel,
    required this.blockchain,
  }) {
    walletOperations = WalletOperations(
      aiModel: aiModel,
      blockchain: blockchain,
    );
  }

  /// Get the current version of the WTF SDK
  String get version => '1.0.0';

  /// Check if the SDK is properly initialized
  bool get isInitialized => true;

  /// Get supported blockchain types
  List<BlockchainType> get supportedBlockchains => BlockchainType.values;

  /// Validate if an address is valid for a specific blockchain
  Future<bool> validateAddress(
      String address, BlockchainType blockchain) async {
    final connector = this.blockchain.getConnector(blockchain);
    return connector.validateAddress(address);
  }

  /// Get the balance of a specific token for an address
  Future<double> getBalance(
    String address,
    String tokenSymbol,
    BlockchainType blockchain,
  ) async {
    final connector = this.blockchain.getConnector(blockchain);
    return connector.getBalance(address, tokenSymbol);
  }
}
