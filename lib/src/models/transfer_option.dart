/// Represents a transfer option with route details and associated parameters
class TransferOption {
  final String route;
  final double fee;
  final String estimatedTime;
  final String securityLevel;
  final String compatibility;
  final Map<String, dynamic>? additionalParams;

  TransferOption({
    required this.route,
    required this.fee,
    required this.estimatedTime,
    required this.securityLevel,
    required this.compatibility,
    this.additionalParams,
  });

  Map<String, dynamic> toJson() {
    return {
      'route': route,
      'fee': fee,
      'estimatedTime': estimatedTime,
      'securityLevel': securityLevel,
      'compatibility': compatibility,
      if (additionalParams != null) 'additionalParams': additionalParams,
    };
  }

  factory TransferOption.fromJson(Map<String, dynamic> json) {
    return TransferOption(
      route: json['route'] as String,
      fee: json['fee'] as double,
      estimatedTime: json['estimatedTime'] as String,
      securityLevel: json['securityLevel'] as String,
      compatibility: json['compatibility'] as String,
      additionalParams: json['additionalParams'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'TransferOption(route: $route, fee: $fee, estimatedTime: $estimatedTime, '
        'securityLevel: $securityLevel, compatibility: $compatibility)';
  }
}
