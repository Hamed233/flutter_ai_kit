import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_message.dart';
import '../models/ai_config.dart';
import 'base_service.dart';

class HuggingFaceService extends BaseService {
  final String _baseUrl = 'https://api-inference.huggingface.co/models/';

  HuggingFaceService({required super.config});

  @override
  Future<AIMessage> generateText(String prompt, {Map<String, dynamic>? parameters}) async {
    try {
      final modelName = parameters?['model'] ?? 'google/flan-t5-base';
      final response = await http.post(
        Uri.parse('$_baseUrl$modelName'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${config.apiKey}',
        },
        body: jsonEncode({
          'inputs': prompt,
          'parameters': {
            'max_length': parameters?['max_length'] ?? 100,
            'temperature': parameters?['temperature'] ?? 0.7,
            'top_p': parameters?['top_p'] ?? 0.9,
            'do_sample': parameters?['do_sample'] ?? true,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String generatedText;
        
        if (data is List && data.isNotEmpty) {
          if (data[0] is Map && data[0].containsKey('generated_text')) {
            generatedText = data[0]['generated_text'];
          } else {
            generatedText = data[0].toString();
          }
        } else if (data is Map && data.containsKey('generated_text')) {
          generatedText = data['generated_text'];
        } else {
          throw Exception('Unexpected response format from HuggingFace API');
        }

        return AIMessage(
          content: generatedText,
          role: MessageRole.assistant,
          timestamp: DateTime.now(),
        );
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to generate text');
      }
    } catch (e) {
      throw Exception('Failed to generate text: $e');
    }
  }

  @override
  Future<AIMessage> generateImage(String prompt, {Map<String, dynamic>? parameters}) async {
    try {
      final modelName = parameters?['model'] ?? 'stabilityai/stable-diffusion-2';
      final response = await http.post(
        Uri.parse('$_baseUrl$modelName'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${config.apiKey}',
        },
        body: jsonEncode({
          'inputs': prompt,
          'parameters': {
            'negative_prompt': parameters?['negative_prompt'],
            'num_inference_steps': parameters?['num_inference_steps'] ?? 50,
            'guidance_scale': parameters?['guidance_scale'] ?? 7.5,
          },
        }),
      );

      if (response.statusCode == 200) {
        // HuggingFace returns the image directly as bytes
        final bytes = response.bodyBytes;
        final base64Image = base64Encode(bytes);
        final imageUrl = 'data:image/jpeg;base64,$base64Image';

        return AIMessage.image(
          prompt: prompt,
          imageUrl: imageUrl,
        );
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to generate image');
      }
    } catch (e) {
      throw Exception('Failed to generate image: $e');
    }
  }
}
