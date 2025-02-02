import 'package:flutter/material.dart';
import 'package:flutter_ai_kit/flutter_ai_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AI Kit Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AIConfig? _openAIConfig;
  AIConfig? _geminiConfig;
  AIConfig? _huggingFaceConfig;
  bool _isLoading = true;

  AIKitTheme _theme = const AIKitTheme();

  final _generationOptions = const GenerationOptions(
    temperature: 0.7,
    maxTokens: 1000,
    topP: 1.0,
    presencePenalty: 0.0,
    frequencyPenalty: 0.0,
  );

  @override
  void initState() {
    super.initState();
    _loadApiKeys();
  }

  Future<void> _loadApiKeys() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();

      final openaiKey = prefs.getString('openai_key');
      final geminiKey = prefs.getString('gemini_key');
      final huggingfaceKey = prefs.getString('huggingface_key');

      setState(() {
        // Only set configs if keys are valid (not null, not empty, and don't contain error messages)
        if (openaiKey != null &&
            openaiKey.isNotEmpty &&
            !openaiKey.contains('Exception') &&
            !openaiKey.startsWith('your-')) {
          _openAIConfig = AIConfig.openAI(
            apiKey: openaiKey,
            modelName: 'gpt-3.5-turbo',
          );
        } else {
          _openAIConfig = null;
        }

        if (geminiKey != null &&
            geminiKey.isNotEmpty &&
            !geminiKey.contains('Exception') &&
            !geminiKey.startsWith('your-')) {
          _geminiConfig = AIConfig.gemini(
            apiKey: geminiKey,
            modelName: 'gemini-pro',
          );
        } else {
          _geminiConfig = null;
        }

        if (huggingfaceKey != null &&
            huggingfaceKey.isNotEmpty &&
            !huggingfaceKey.contains('Exception') &&
            !huggingfaceKey.startsWith('your-')) {
          _huggingFaceConfig = AIConfig.huggingFace(
            apiKey: huggingfaceKey,
            modelName: 'mistral',
          );
        } else {
          _huggingFaceConfig = null;
        }
      });
    } catch (e) {
      print('Error loading API keys: $e');
      setState(() {
        _openAIConfig = null;
        _geminiConfig = null;
        _huggingFaceConfig = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveApiKey(String key, String value) async {
    if (value.isEmpty ||
        value.contains('Exception') ||
        value.startsWith('your-')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid API key'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      await _loadApiKeys();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${key.split('_')[0].toUpperCase()} API key saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error saving API key: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save API key'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showApiKeyDialog(String provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set $provider API Key'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter your $provider API key',
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _saveApiKey('${provider.toLowerCase()}_key', controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingApiKeyMessage(String provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No $provider API key found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showApiKeyDialog(provider),
            child: Text('Set $provider API Key'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    _theme = const AIKitTheme();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter AI Kit Demo'),
          actions: [
            PopupMenuButton<String>(
              onSelected: _showApiKeyDialog,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'openai',
                  child: Text('Set OpenAI Key'),
                ),
                const PopupMenuItem(
                  value: 'gemini',
                  child: Text('Set Gemini Key'),
                ),
                const PopupMenuItem(
                  value: 'huggingface',
                  child: Text('Set HuggingFace Key'),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            padding: EdgeInsets.zero,
            tabs: [
              Tab(text: 'OpenAI Chat'),
              Tab(text: 'Gemini Chat'),
              Tab(text: 'Image Gen'),
              Tab(text: 'Text Process'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // OpenAI Chat Tab
            _openAIConfig == null
                ? _buildMissingApiKeyMessage('OpenAI')
                : AIChatWidget(
                    config: _openAIConfig!,
                    theme: _theme,
                    options: _generationOptions,
                    placeholder: 'Chat with OpenAI...',
                    onMessageSent: (message) {
                      print('OpenAI - Sent: ${message.content}');
                    },
                    onMessageReceived: (message) {
                      print('OpenAI - Received: ${message.content}');
                    },
                  ),

            // Gemini Chat Tab
            _geminiConfig == null
                ? _buildMissingApiKeyMessage('Gemini')
                : AIChatWidget(
                    config: _geminiConfig!,
                    theme: _theme,
                    options: _generationOptions.copyWith(
                      temperature: 0.9,
                      additionalOptions: {
                        'candidate_count': 1,
                      },
                    ),
                    placeholder: 'Chat with Gemini...',
                    onMessageSent: (message) {
                      print('Gemini - Sent: ${message.content}');
                    },
                    onMessageReceived: (message) {
                      print('Gemini - Received: ${message.content}');
                    },
                  ),

            // Image Generation Tab
            _openAIConfig == null
                ? _buildMissingApiKeyMessage('OpenAI')
                : Column(
                    children: [
                      Expanded(
                        child: ImageGenerationWidget(
                          config: _openAIConfig!,
                          theme: _theme,
                          placeholder:
                              'Describe the image you want to generate...',
                          parameters: {
                            'size': '1024x1024',
                            'n': 1,
                            'model': 'dall-e-3',
                            'quality': 'standard',
                            'style': 'vivid',
                          },
                          onImageGenerated: (imageUrl) {
                            print('Generated image: $imageUrl');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Image generated successfully!'),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Using OpenAI DALL-E for image generation',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),

            // Text Processing Tab
            _huggingFaceConfig == null
                ? _buildMissingApiKeyMessage('HuggingFace')
                : Column(
                    children: [
                      Expanded(
                        child: TextProcessingWidget(
                          config: _huggingFaceConfig!,
                          theme: _theme,
                          options: _generationOptions,
                          systemPrompt:
                              '''You are a helpful assistant that helps improve text. Please help format, correct grammar, and improve the following text while maintaining its original meaning.''',
                          placeholder: 'Enter text to process...',
                          useMarkdown: true,
                          onProcessingComplete: (result) {
                            print('Processed text: $result');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Using HuggingFace for text processing',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
