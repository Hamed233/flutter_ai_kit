import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ai_message.dart';
import '../theme/ai_kit_theme.dart';

class ChatMessageWidget extends StatelessWidget {
  final AIMessage message;
  final AIKitTheme theme;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final materialTheme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isUser ? theme.userMessageColor : theme.assistantMessageColor,
          borderRadius: theme.messageBorderRadius,
          boxShadow: [
            BoxShadow(
              color: materialTheme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.type == MessageType.image && message.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.imageUrl!,
                  fit: BoxFit.cover,
                ),
              )
            else
              MarkdownBody(
                data: message.content,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: theme.messageTextStyle,
                  code: GoogleFonts.firaCode(
                    fontSize: theme.messageTextStyle.fontSize,
                    backgroundColor: materialTheme.colorScheme.surfaceContainerHighest,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: materialTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  blockquote: theme.messageTextStyle.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  blockquoteDecoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: materialTheme.colorScheme.primary.withOpacity(0.5),
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              message.timestamp.toString(),
              style: theme.messageTextStyle.copyWith(
                fontSize: 12,
                color: materialTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
