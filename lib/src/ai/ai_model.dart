/// Abstract class defining the interface for AI models that can process natural language commands
abstract class AIModel {
  /// Process natural language input and convert it to structured transfer data
  Future<Map<String, dynamic>> processNaturalLanguage(String input);

  /// Analyze transfer options and provide recommendations
  Future<Map<String, dynamic>> analyzeTransferOptions(
      List<Map<String, dynamic>> options);

  /// Generate user-friendly explanations for transfer operations
  Future<String> generateExplanation(Map<String, dynamic> transferDetails);
}

/// OpenAI implementation of the AIModel interface
class OpenAIModel implements AIModel {
  final String apiKey;

  OpenAIModel({required this.apiKey});

  @override
  Future<Map<String, dynamic>> processNaturalLanguage(String input) async {
    // TODO: Implement OpenAI API integration
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> analyzeTransferOptions(
      List<Map<String, dynamic>> options) async {
    // TODO: Implement OpenAI API integration
    throw UnimplementedError();
  }

  @override
  Future<String> generateExplanation(
      Map<String, dynamic> transferDetails) async {
    // TODO: Implement OpenAI API integration
    throw UnimplementedError();
  }
}

/// Claude implementation of the AIModel interface
class ClaudeModel implements AIModel {
  final String apiKey;

  ClaudeModel({required this.apiKey});

  @override
  Future<Map<String, dynamic>> processNaturalLanguage(String input) async {
    // TODO: Implement Claude API integration
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> analyzeTransferOptions(
      List<Map<String, dynamic>> options) async {
    // TODO: Implement Claude API integration
    throw UnimplementedError();
  }

  @override
  Future<String> generateExplanation(
      Map<String, dynamic> transferDetails) async {
    // TODO: Implement Claude API integration
    throw UnimplementedError();
  }
}
