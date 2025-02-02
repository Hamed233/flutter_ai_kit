import 'package:http/http.dart' as http;
import '../models/ai_message.dart';
import '../models/ai_config.dart';

abstract class BaseService {
  final AIConfig config;
  final http.Client _client = http.Client();

  BaseService({required this.config});

  Future<AIMessage> generateText(String prompt, {Map<String, dynamic>? parameters}) async {
    throw UnimplementedError('generateText() has not been implemented.');
  }

  Future<AIMessage> generateImage(String prompt, {Map<String, dynamic>? parameters}) async {
    throw UnimplementedError('generateImage() has not been implemented.');
  }

  void dispose() {
    _client.close();
  }
}

class ModelConfig {
  final String modelId;
  final int maxContextLength;
  final int defaultMaxNewTokens;
  final Map<String, dynamic> defaultParameters;
  final List<String> supportedTasks;

  const ModelConfig({
    required this.modelId,
    required this.maxContextLength,
    required this.defaultMaxNewTokens,
    this.defaultParameters = const {},
    this.supportedTasks = const ['text-generation'],
  });

  // Calculate safe max tokens based on input length
  int calculateMaxNewTokens(String prompt) {
    // Estimate prompt tokens (rough estimate: 4 chars per token)
    final estimatedPromptTokens = (prompt.length / 4).ceil();
    // Leave some buffer for the response
    return (maxContextLength - estimatedPromptTokens - 50).clamp(1, defaultMaxNewTokens);
  }

  // Merge default parameters with user parameters
  Map<String, dynamic> mergeParameters(Map<String, dynamic>? userParameters) {
    final merged = Map<String, dynamic>.from(defaultParameters);
    if (userParameters != null) {
      merged.addAll(userParameters);
    }
    return merged;
  }
}

// Retry mechanism for API calls
mixin RetryMixin on BaseService {
  Future<T> retryOperation<T>({
    required Future<T> Function() operation,
    required bool Function(dynamic error) shouldRetry,
    required Duration Function(dynamic error) getRetryDelay,
    int maxRetries = 5,
  }) async {
    int attempts = 0;
    while (true) {
      try {
        return await operation();
      } catch (error) {
        attempts++;
        if (attempts >= maxRetries || !shouldRetry(error)) {
          rethrow;
        }
        final delay = getRetryDelay(error);
        await Future.delayed(delay);
      }
    }
  }
}
