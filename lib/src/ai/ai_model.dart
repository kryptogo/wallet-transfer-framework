import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/transfer_request.dart';
import '../models/transfer_result.dart';

/// Abstract class defining the interface for AI models that can process natural language commands
abstract class AIModel {
  /// Process natural language input and convert it to structured transfer data
  Future<Map<String, dynamic>> processNaturalLanguage(String input);

  /// Generate user-friendly explanations for transfer operations
  Future<String> generateExplanation(TransferResult transferDetails);
}

/// OpenAI implementation of the AIModel interface
class OpenAIModel implements AIModel {
  final String apiKey;
  final String model;
  final _dio = Dio();

  OpenAIModel({required this.apiKey, this.model = 'gpt-4o-2024-08-06'}) {
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
    _dio.options.baseUrl = 'https://api.openai.com/v1';
  }

  @override
  Future<Map<String, dynamic>> processNaturalLanguage(String input) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': [
            {'role': 'user', 'content': input}
          ],
          'functions': [
            {
              'name': 'create_transfer',
              'description': 'Create a transfer request',
              'parameters': {
                'type': 'object',
                'properties': {
                  'senderAddress': {
                    'type': 'string',
                    'description': 'Sender wallet address'
                  },
                  'recipientAddress': {
                    'type': 'string',
                    'description': 'Recipient wallet address'
                  },
                  'amount': {
                    'type': 'number',
                    'description': 'Transfer amount'
                  },
                  'tokenSymbol': {
                    'type': 'string',
                    'description': 'Token symbol, e.g. ETH, USDT'
                  }
                },
                'required': [
                  'senderAddress',
                  'recipientAddress',
                  'amount',
                  'tokenSymbol'
                ]
              }
            }
          ],
          'function_call': {'name': 'create_transfer'}
        },
      );

      final functionCall =
          response.data['choices'][0]['message']['function_call'];
      final arguments = json.decode(functionCall['arguments']);

      return CreateTransferRequest(
        senderAddress: arguments['senderAddress'],
        recipientAddress: arguments['recipientAddress'],
        amount: arguments['amount'].toDouble(),
        tokenSymbol: arguments['tokenSymbol'],
      ).toJson();
    } catch (e) {
      throw Exception('Failed to process natural language: $e');
    }
  }

  @override
  Future<String> generateExplanation(TransferResult transferDetails) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a transaction assistant. Summarize this transaction in one simple sentence. Format: [sender short address] sent [amount] [token] to [recipient short address]'
            },
            {
              'role': 'user',
              'content': '''
${transferDetails.details?['senderAddress']} sent ${transferDetails.details?['amount']} ${transferDetails.details?['tokenSymbol']} to ${transferDetails.details?['recipientAddress']}
Status: ${transferDetails.details?['status']}
${transferDetails.details?['error'] ?? ''}
'''
            }
          ],
        },
      );

      return response.data['choices'][0]['message']['content'];
    } catch (e) {
      throw Exception('Failed to generate explanation: $e');
    }
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
  Future<String> generateExplanation(TransferResult transferDetails) async {
    return 'Explanation';
  }
}
