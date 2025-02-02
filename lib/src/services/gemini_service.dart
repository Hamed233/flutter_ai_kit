import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_message.dart';
import '../models/ai_config.dart';
import '../models/generation_options.dart';

class GeminiService {
  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  final AIConfig config;
  final http.Client _client = http.Client();
  late final String _model;

  GeminiService({required this.config}) {
    _model = config.modelName ?? 'gemini-pro';
  }

  Future<AIMessage> generateText(
    String prompt, {
    GenerationOptions options = GenerationOptions.defaultOptions,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/models/$_model:generateContent?key=${config.apiKey}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': prompt,
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': options.temperature,
            'topP': options.topP,
            'maxOutputTokens': options.maxTokens,
          },
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate text: ${response.body}');
      }

      final data = jsonDecode(response.body);
      if (data['candidates'] == null || (data['candidates'] as List).isEmpty) {
        throw Exception('Empty response from Gemini');
      }

      final content = data['candidates'][0]['content'];
      if (content == null || content['parts'] == null || (content['parts'] as List).isEmpty) {
        throw Exception('Invalid response format from Gemini');
      }

      final text = content['parts'][0]['text'] as String;
      return AIMessage.assistant(text);
    } catch (e) {
      throw Exception('Failed to generate text: $e');
    }
  }

  Future<AIMessage> generateWithImage(
    String prompt,
    List<String> imagePaths, {
    GenerationOptions options = GenerationOptions.defaultOptions,
  }) async {
    // Note: Image processing with Gemini requires the gemini-pro-vision model
    throw UnimplementedError('Image processing is not yet implemented for Gemini service');
  }

  void dispose() {
    _client.close();
  }
}
