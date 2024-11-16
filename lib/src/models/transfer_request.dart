/// Represents a transfer request with all necessary parameters
class CreateTransferRequest {
  final String senderAddress;
  final String recipientAddress;
  final double amount;
  final String tokenSymbol;
  final Map<String, dynamic>? additionalData;

  CreateTransferRequest({
    required this.senderAddress,
    required this.recipientAddress,
    required this.amount,
    required this.tokenSymbol,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderAddress': senderAddress,
      'recipientAddress': recipientAddress,
      'amount': amount,
      'tokenSymbol': tokenSymbol,
      if (additionalData != null) 'additionalData': additionalData,
    };
  }

  factory CreateTransferRequest.fromJson(Map<String, dynamic> json) {
    return CreateTransferRequest(
      senderAddress: json['senderAddress'] as String,
      recipientAddress: json['recipientAddress'] as String,
      amount: json['amount'] as double,
      tokenSymbol: json['tokenSymbol'] as String,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }
}
