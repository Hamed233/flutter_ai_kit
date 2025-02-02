import 'package:flutter/material.dart';
import '../models/ai_message.dart';
import '../models/ai_config.dart';
import '../models/generation_options.dart';
import '../theme/ai_kit_theme.dart';
import 'message_bubble.dart';
import '../services/huggingface_service.dart';

class TextProcessingWidget extends StatefulWidget {
  final AIConfig config;
  final AIKitTheme theme;
  final GenerationOptions options;
  final String? systemPrompt;
  final String? placeholder;
  final bool useMarkdown;
  final Function(String)? onProcessingComplete;

  const TextProcessingWidget({
    super.key,
    required this.config,
    this.theme = const AIKitTheme(),
    this.options = GenerationOptions.defaultOptions,
    this.systemPrompt,
    this.placeholder,
    this.useMarkdown = true,
    this.onProcessingComplete,
  });

  @override
  State<TextProcessingWidget> createState() => _TextProcessingWidgetState();
}

class _TextProcessingWidgetState extends State<TextProcessingWidget> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<AIMessage> _messages = [];
  bool _isProcessing = false;
  late final HuggingFaceService _service;

  @override
  void initState() {
    super.initState();
    _service = HuggingFaceService(config: widget.config);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _service.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _processText() async {
    if (_controller.text.trim().isEmpty || _isProcessing) return;

    final userMessage = AIMessage.user(_controller.text.trim());
    setState(() {
      _messages.add(userMessage);
      _controller.clear();
      _isProcessing = true;
    });
    _scrollToBottom();

    try {
      final response = await _service.generateText(
        userMessage.content,
        parameters: {
          'max_length': widget.options.maxTokens,
          'temperature': widget.options.temperature,
          'top_p': widget.options.topP,
          'presence_penalty': widget.options.presencePenalty,
          'frequency_penalty': widget.options.frequencyPenalty,
          ...?widget.options.additionalOptions,
        },
      );
      setState(() {
        _messages.add(response);
        _isProcessing = false;
      });
      _scrollToBottom();
      widget.onProcessingComplete?.call(response.content);
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _messages.add(
          AIMessage(
            content: 'Error: ${e.toString()}',
            role: MessageRole.assistant,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    }
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: widget.theme.padding,
      itemCount: _messages.length + (_isProcessing ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isProcessing && index == _messages.length) {
          return MessageBubble(
            message: AIMessage(
              content: '...',
              role: MessageRole.assistant,
              timestamp: DateTime.now(),
            ),
            theme: widget.theme,
            useMarkdown: widget.useMarkdown,
            isLoading: true,
          );
        }
        return MessageBubble(
          message: _messages[index],
          theme: widget.theme,
          useMarkdown: widget.useMarkdown,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.systemPrompt != null)
          Padding(
            padding: widget.theme.padding,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.theme.assistantMessageColor.withOpacity(0.5),
                borderRadius: widget.theme.borderRadius,
              ),
              child: Text(
                widget.systemPrompt!,
                style: TextStyle(
                  color: widget.theme.assistantMessageTextColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        Expanded(
          child: Container(
            color: widget.theme.backgroundColor,
            child: _messages.isEmpty && !_isProcessing
                ? Center(
                    child: Text(
                      'Enter text to process',
                      style: TextStyle(
                        color: widget.theme.inputHintColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                : _buildMessageList(),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: widget.theme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: widget.theme.padding,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: widget.theme.inputDecoration(
                    hintText: widget.placeholder ?? 'Enter text to process...',
                  ),
                  style: TextStyle(
                    color: widget.theme.inputTextColor,
                    fontSize: 16,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onSubmitted: (_) => _processText(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isProcessing ? null : _processText,
                style: widget.theme.buttonStyle,
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
