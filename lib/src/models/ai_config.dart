enum AIProvider { openAI, gemini, huggingFace }

class AIConfig {
  final String apiKey;
  final AIProvider provider;
  final String? modelName;
  final Map<String, dynamic>? additionalConfig;

  const AIConfig({
    required this.apiKey,
    required this.provider,
    this.modelName,
    this.additionalConfig,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider.toString(),
      'modelName': modelName,
      if (additionalConfig != null) ...additionalConfig!,
    };
  }

  factory AIConfig.openAI({
    required String apiKey,
    String modelName = 'gpt-3.5-turbo',
    Map<String, dynamic>? additionalConfig,
  }) {
    return AIConfig(
      apiKey: apiKey,
      provider: AIProvider.openAI,
      modelName: modelName,
      additionalConfig: additionalConfig,
    );
  }

  factory AIConfig.gemini({
    required String apiKey,
    String modelName = 'gemini-pro',
    Map<String, dynamic>? additionalConfig,
  }) {
    return AIConfig(
      apiKey: apiKey,
      provider: AIProvider.gemini,
      modelName: modelName,
      additionalConfig: additionalConfig,
    );
  }

  factory AIConfig.huggingFace({
    required String apiKey,
    String? modelName,
    Map<String, dynamic>? additionalConfig,
  }) {
    return AIConfig(
      apiKey: apiKey,
      provider: AIProvider.huggingFace,
      modelName: modelName,
      additionalConfig: additionalConfig,
    );
  }
}
