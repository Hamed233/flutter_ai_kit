import 'package:flutter/material.dart';
import '../models/ai_message.dart';
import '../models/ai_config.dart';
import '../models/generation_options.dart';
import '../theme/ai_kit_theme.dart';
import '../services/openai_service.dart';
import '../services/gemini_service.dart';
import '../services/huggingface_service.dart';
import 'message_bubble.dart';

class AIChatWidget extends StatefulWidget {
  final AIConfig config;
  final GenerationOptions? options;
  final AIKitTheme? theme;
  final String? placeholder;
  final bool showTimestamp;
  final Widget Function(BuildContext, AIMessage)? messageBuilder;
  final void Function(AIMessage)? onMessageSent;
  final void Function(AIMessage)? onMessageReceived;

  const AIChatWidget({
    super.key,
    required this.config,
    this.options,
    this.theme,
    this.placeholder,
    this.showTimestamp = true,
    this.messageBuilder,
    this.onMessageSent,
    this.onMessageReceived,
  });

  @override
  State<AIChatWidget> createState() => _AIChatWidgetState();
}

class _AIChatWidgetState extends State<AIChatWidget> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<AIMessage> _messages = [];
  bool _isLoading = false;

  late final dynamic _service;
  late final AIKitTheme _theme;

  @override
  void initState() {
    super.initState();
    _theme = widget.theme ?? AIKitTheme();
    _initializeService();
  }

  void _initializeService() {
    switch (widget.config.provider) {
      case AIProvider.openAI:
        _service = OpenAIService(config: widget.config);
        break;
      case AIProvider.gemini:
        _service = GeminiService(config: widget.config);
        break;
      case AIProvider.huggingFace:
        _service = HuggingFaceService(config: widget.config);
        break;
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final message = AIMessage.user(text);
    setState(() {
      _messages.add(message);
      _isLoading = true;
    });
    _controller.clear();
    widget.onMessageSent?.call(message);
    
    // Scroll to the bottom after adding user message
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final response = await _service.generateText(
        text,
        options: widget.options ?? GenerationOptions.defaultOptions,
      );

      setState(() {
        _messages.add(response);
        _isLoading = false;
      });
      widget.onMessageReceived?.call(response);
      
      // Scroll to the bottom after receiving response
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildMessage(AIMessage message) {
    if (widget.messageBuilder != null) {
      return widget.messageBuilder!(context, message);
    }

    return MessageBubble(
      message: message,
      theme: _theme,
      useMarkdown: true,
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isLoading && index == _messages.length) {
          return MessageBubble(
            message: AIMessage(
              content: '...',
              role: MessageRole.assistant,
              timestamp: DateTime.now(),
            ),
            theme: _theme,
            useMarkdown: true,
            isLoading: true,
          );
        }
        return _buildMessage(_messages[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: _theme.backgroundColor,
            child: _messages.isEmpty && !_isLoading
                ? Center(
                    child: Text(
                      widget.placeholder ?? 'Start a conversation...',
                      style: TextStyle(
                        color: _theme.inputHintColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                : _buildMessageList(),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _theme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: widget.placeholder ?? 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: _theme.messageBorderRadius,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  style: TextStyle(
                    color: _theme.inputTextColor,
                    fontSize: 16,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isLoading ? null : _sendMessage,
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.send,
                        color: _theme.primaryColor,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _service.dispose();
    super.dispose();
  }
}
