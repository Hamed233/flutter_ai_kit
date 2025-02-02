class GenerationOptions {
  final double temperature;
  final int maxTokens;
  final double topP;
  final double presencePenalty;
  final double frequencyPenalty;
  final Map<String, dynamic>? additionalOptions;

  const GenerationOptions({
    this.temperature = 0.7,
    this.maxTokens = 1000,
    this.topP = 1.0,
    this.presencePenalty = 0.0,
    this.frequencyPenalty = 0.0,
    this.additionalOptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'max_tokens': maxTokens,
      'top_p': topP,
      'presence_penalty': presencePenalty,
      'frequency_penalty': frequencyPenalty,
      if (additionalOptions != null) ...additionalOptions!,
    };
  }

  GenerationOptions copyWith({
    double? temperature,
    int? maxTokens,
    double? topP,
    double? presencePenalty,
    double? frequencyPenalty,
    Map<String, dynamic>? additionalOptions,
  }) {
    return GenerationOptions(
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      topP: topP ?? this.topP,
      presencePenalty: presencePenalty ?? this.presencePenalty,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      additionalOptions: additionalOptions ?? this.additionalOptions,
    );
  }

  static const GenerationOptions defaultOptions = GenerationOptions();
}
