/// Represents the result of a transfer operation
class TransferResult {
  final bool success;
  final String? transactionHash;
  final String? errorMessage;
  final Map<String, dynamic>? details;

  TransferResult({
    required this.success,
    this.transactionHash,
    this.errorMessage,
    this.details,
  }) {
    if (success && transactionHash == null) {
      throw ArgumentError(
          'Transaction hash must be provided for successful transfers');
    }
    if (!success && errorMessage == null) {
      throw ArgumentError(
          'Error message must be provided for failed transfers');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (transactionHash != null) 'transactionHash': transactionHash,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (details != null) 'details': details,
    };
  }

  factory TransferResult.success({
    required String transactionHash,
    Map<String, dynamic>? details,
  }) {
    return TransferResult(
      success: true,
      transactionHash: transactionHash,
      details: details,
    );
  }

  factory TransferResult.failure({
    required String errorMessage,
    Map<String, dynamic>? details,
  }) {
    return TransferResult(
      success: false,
      errorMessage: errorMessage,
      details: details,
    );
  }

  factory TransferResult.fromJson(Map<String, dynamic> json) {
    return TransferResult(
      success: json['success'] as bool,
      transactionHash: json['transactionHash'] as String?,
      errorMessage: json['errorMessage'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    if (success) {
      return 'TransferResult(success: true, transactionHash: $transactionHash)';
    } else {
      return 'TransferResult(success: false, errorMessage: $errorMessage)';
    }
  }
}
