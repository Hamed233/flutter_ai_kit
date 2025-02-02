import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_message.dart';
import '../models/ai_config.dart';
import '../models/generation_options.dart';

class OpenAIService {
  static const _baseUrl = 'https://api.openai.com/v1';
  final AIConfig config;
  final http.Client _client = http.Client();

  OpenAIService({required this.config});

  Future<AIMessage> generateText(
    String prompt, {
    GenerationOptions options = GenerationOptions.defaultOptions,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': config.modelName ?? 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': options.temperature,
          'max_tokens': options.maxTokens,
          'top_p': options.topP,
          'presence_penalty': options.presencePenalty,
          'frequency_penalty': options.frequencyPenalty,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate text: ${response.body}');
      }

      final data = jsonDecode(response.body);
      if (data['choices'] == null || (data['choices'] as List).isEmpty) {
        throw Exception('Empty response from OpenAI');
      }

      final content = data['choices'][0]['message']['content'] as String;
      return AIMessage.assistant(content);
    } catch (e) {
      throw Exception('Failed to generate text: $e');
    }
  }

  Future<AIMessage> generateImage(String prompt, {Map<String, dynamic>? parameters}) async {
    try {
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${config.apiKey}',
        },
        body: jsonEncode({
          'prompt': prompt,
          'model': parameters?['model'] ?? 'dall-e-3',
          'n': parameters?['n'] ?? 1,
          'size': parameters?['size'] ?? '1024x1024',
          'quality': parameters?['quality'] ?? 'standard',
          'style': parameters?['style'] ?? 'vivid',
          'response_format': 'url',
        }),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data['data'] != null && data['data'].isNotEmpty) {
            final imageUrl = data['data'][0]['url'];
            if (imageUrl != null && imageUrl.isNotEmpty) {
              return AIMessage.image(
                prompt: prompt,
                imageUrl: imageUrl,
              );
            }
          }
          throw Exception('Invalid response format from OpenAI');
        } catch (e) {
          throw Exception('Failed to parse OpenAI response: $e');
        }
      } else {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['error']?['message'] ?? 'Failed to generate image');
        } catch (e) {
          throw Exception('Failed to generate image: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      throw Exception('Failed to generate image: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
