import 'package:flutter/material.dart';
import 'package:flutter_ai_kit/src/models/ai_message.dart';
import 'package:flutter_ai_kit/src/widgets/message_bubble.dart';
import '../models/ai_config.dart';
import '../theme/ai_kit_theme.dart';
import '../services/openai_service.dart';

class ImageGenerationWidget extends StatefulWidget {
  final AIConfig config;
  final AIKitTheme theme;
  final OpenAIService? service;
  final String? placeholder;
  final void Function(String)? onImageGenerated;
  final Map<String, dynamic>? parameters;

  const ImageGenerationWidget({
    super.key,
    required this.config,
    this.theme = const AIKitTheme(),
    this.service,
    this.placeholder,
    this.onImageGenerated,
    this.parameters,
  });

  @override
  State<ImageGenerationWidget> createState() => _ImageGenerationWidgetState();
}

class _ImageGenerationWidgetState extends State<ImageGenerationWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<AIMessage> _messages = [];
  bool _isGenerating = false;
  late final OpenAIService _service;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? OpenAIService(config: widget.config);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Implement scrolling logic if needed
      }
    });
  }

  Future<void> _generateImage() async {
    if (_controller.text.trim().isEmpty || _isGenerating) return;

    final prompt = _controller.text.trim();
    setState(() {
      _messages.add(AIMessage.user(prompt));
      _controller.clear();
      _isGenerating = true;
    });
    _scrollToBottom();

    try {
      final response = await _service.generateImage(
        prompt,
        parameters: widget.parameters,
      );

      if (mounted) {
        setState(() {
          _messages.add(response);
          _isGenerating = false;
        });
        _scrollToBottom();
        if (response.imageUrl != null) {
          widget.onImageGenerated?.call(response.imageUrl!);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _messages.add(
            AIMessage(
              content: 'Error generating image: ${e.toString()}',
              role: MessageRole.assistant,
              timestamp: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return MessageBubble(
                message: message,
                theme: widget.theme,
              );
            },
          ),
        ),
        if (_isGenerating)
          MessageBubble(
            message: AIMessage(
              content: 'Generating image...',
              role: MessageRole.assistant,
              timestamp: DateTime.now(),
            ),
            theme: widget.theme,
          ),
        Padding(
          padding: widget.theme.padding,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: widget.placeholder ?? 'Describe an image...',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: widget.theme.borderRadius,
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _generateImage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isGenerating ? null : _generateImage,
                icon: Icon(
                  Icons.send,
                  color: _isGenerating
                      ? widget.theme.sendButtonDisabledColor
                      : widget.theme.sendButtonColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
