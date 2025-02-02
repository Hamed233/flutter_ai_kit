# Flutter AI Kit 🤖

A comprehensive Flutter package for integrating AI services like OpenAI, Google Gemini, and HuggingFace. Features beautiful, customizable UI components for chat interfaces, image generation, and text processing.

## Demo Video 🎥

<div align="center">
  <img src="demo/demo_flutter_ai_kit.gif" alt="Flutter AI Kit Demo" width="400"/>
</div>

[![pub package](https://img.shields.io/pub/v/flutter_ai_kit.svg)](https://pub.dev/packages/flutter_ai_kit)
[![likes](https://img.shields.io/pub/likes/flutter_ai_kit?logo=dart)](https://pub.dev/packages/flutter_ai_kit/score)
[![popularity](https://img.shields.io/pub/popularity/flutter_ai_kit?logo=dart)](https://pub.dev/packages/flutter_ai_kit/score)
[![style: flutter_lints](https://img.shields.io/badge/style-flutter_lints-blue)](https://pub.dev/packages/flutter_lints)

## Features 🌟

- **Chat Interfaces**: Pre-built chat widgets for OpenAI and Google Gemini
- **Image Generation**: DALL-E integration for AI image generation
- **Text Processing**: Text processing with HuggingFace models
- **Beautiful UI**: Modern, customizable UI components
- **Easy Integration**: Simple setup with API key configuration
- **Flexible Theming**: Customize colors, shapes, and styles to match your app
- **Error Handling**: Built-in error handling and loading states
- **Type Safety**: Full type safety and null safety support

## Getting Started 🚀

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_ai_kit: ^1.0.0
```

### Basic Usage

1. Configure your AI services:

```dart
final openAIConfig = AIConfig(
  provider: AIProvider.openAI,
  apiKey: 'your-openai-api-key',
);

final geminiConfig = AIConfig(
  provider: AIProvider.gemini,
  apiKey: 'your-gemini-api-key',
);

final huggingFaceConfig = AIConfig(
  provider: AIProvider.huggingFace,
  apiKey: 'your-huggingface-api-key',
);
```

2. Use the widgets in your app:

```dart
// Chat Widget with OpenAI
AIChatWidget(
  config: openAIConfig,
  theme: AIKitTheme(), // Optional custom theme
  options: GenerationOptions(
    temperature: 0.7,
    maxTokens: 1000,
  ),
  placeholder: 'Chat with AI...',
  onMessageSent: (message) {
    print('Sent: ${message.content}');
  },
  onMessageReceived: (message) {
    print('Received: ${message.content}');
  },
)

// Image Generation Widget
ImageGenerationWidget(
  config: openAIConfig,
  theme: AIKitTheme(),
  placeholder: 'Describe an image...',
  parameters: {
    'model': 'dall-e-3',
    'size': '1024x1024',
    'quality': 'standard',
    'style': 'vivid',
  },
  onImageGenerated: (imageUrl) {
    print('Generated image: $imageUrl');
  },
)

// Text Processing Widget
TextProcessingWidget(
  config: huggingFaceConfig,
  theme: AIKitTheme(),
  systemPrompt: 'You are a helpful assistant...',
  placeholder: 'Enter text to process...',
  onProcessingComplete: (result) {
    print('Processed text: $result');
  },
)
```

## Customization 🎨

### Theming

Customize the appearance using `AIKitTheme`:

```dart
final customTheme = AIKitTheme(
  primaryColor: Colors.blue,
  backgroundColor: Colors.white,
  userMessageColor: Colors.blue,
  userMessageTextColor: Colors.white,
  assistantMessageColor: Colors.grey[100]!,
  assistantMessageTextColor: Colors.black87,
  inputBackgroundColor: Colors.grey[100]!,
  inputTextColor: Colors.black87,
  inputHintColor: Colors.black54,
  sendButtonColor: Colors.blue,
  borderRadius: BorderRadius.circular(12),
  padding: EdgeInsets.all(16),
);
```

## Examples 📱

### OpenAI Chat

```dart
AIChatWidget(
  config: AIConfig(
    provider: AIProvider.openAI,
    apiKey: 'your-api-key',
  ),
  options: GenerationOptions(
    temperature: 0.7,
    maxTokens: 1000,
    additionalOptions: {
      'model': 'gpt-4-turbo-preview',
    },
  ),
)
```

### Gemini Chat

```dart
AIChatWidget(
  config: AIConfig(
    provider: AIProvider.gemini,
    apiKey: 'your-api-key',
  ),
  options: GenerationOptions(
    temperature: 0.9,
    additionalOptions: {
      'candidate_count': 1,
    },
  ),
)
```

### Image Generation

```dart
ImageGenerationWidget(
  config: AIConfig(
    provider: AIProvider.openAI,
    apiKey: 'your-api-key',
  ),
  parameters: {
    'model': 'dall-e-3',
    'size': '1024x1024',
    'quality': 'standard',
    'style': 'vivid',
  },
)
```

### Text Processing

```dart
TextProcessingWidget(
  config: AIConfig(
    provider: AIProvider.huggingFace,
    apiKey: 'your-api-key',
  ),
  systemPrompt: '''You are a helpful assistant that helps improve text.
  Please help format, correct grammar, and improve the following text
  while maintaining its original meaning.''',
)
```

## API Documentation 📚

For detailed API documentation, visit our [API Reference](https://pub.dev/documentation/flutter_ai_kit/latest/).

## Contributing 🤝

We welcome contributions! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support ❤️

If you find this package helpful, please give it a ⭐️ on [GitHub](https://github.com/Hamed233/flutter_ai_kit)!

For bugs or feature requests, please create an [issue](https://github.com/Hamed233/flutter_ai_kit/issues).

## Changelog 📝

See [CHANGELOG.md](CHANGELOG.md) for all notable changes.
