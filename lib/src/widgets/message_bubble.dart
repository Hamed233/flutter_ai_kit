import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import '../models/ai_message.dart';
import '../theme/ai_kit_theme.dart';

class MessageBubble extends StatelessWidget {
  final AIMessage message;
  final AIKitTheme theme;
  final bool useMarkdown;
  final bool isLoading;

  const MessageBubble({
    super.key,
    required this.message,
    required this.theme,
    this.useMarkdown = true,
    this.isLoading = false,
  });

  bool get isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: theme.assistantAvatarBackgroundColor,
              radius: 16,
              child: Icon(
                Icons.smart_toy,
                size: 20,
                color: theme.assistantAvatarIconColor,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.userMessageColor
                    : theme.assistantMessageColor,
                borderRadius: theme.borderRadius.copyWith(
                  topLeft: Radius.circular(isUser ? 12 : 4),
                  topRight: Radius.circular(isUser ? 4 : 12),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isLoading)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isUser
                                  ? theme.userMessageTextColor
                                  : theme.assistantMessageTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Thinking...',
                          style: TextStyle(
                            color: isUser
                                ? theme.userMessageTextColor
                                : theme.assistantMessageTextColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    )
                  else if (message.type == MessageType.image && message.imageUrl != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.content.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              message.content,
                              style: TextStyle(
                                color: isUser
                                    ? theme.userMessageTextColor
                                    : theme.assistantMessageTextColor,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: message.imageUrl!,
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: theme.errorColor,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Failed to load image',
                                    style: TextStyle(
                                      color: theme.errorColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (useMarkdown && !isUser)
                    MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: theme.assistantMessageTextColor,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        code: TextStyle(
                          color: theme.assistantMessageTextColor,
                          backgroundColor:
                              theme.assistantMessageTextColor.withOpacity(0.1),
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: theme.assistantMessageTextColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    )
                  else
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isUser
                            ? theme.userMessageTextColor
                            : theme.assistantMessageTextColor,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    timeago.format(message.timestamp),
                    style: TextStyle(
                      color: (isUser
                              ? theme.userMessageTextColor
                              : theme.assistantMessageTextColor)
                          .withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: theme.userAvatarBackgroundColor,
              radius: 16,
              child: Icon(
                Icons.person,
                size: 20,
                color: theme.userAvatarIconColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
