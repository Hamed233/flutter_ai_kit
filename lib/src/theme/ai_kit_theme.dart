import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AIKitTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final Color userMessageColor;
  final Color assistantMessageColor;
  final Color userMessageTextColor;
  final Color assistantMessageTextColor;
  final Color userAvatarBackgroundColor;
  final Color userAvatarIconColor;
  final Color assistantAvatarBackgroundColor;
  final Color assistantAvatarIconColor;
  final Color inputBackgroundColor;
  final Color inputTextColor;
  final Color inputHintColor;
  final Color sendButtonColor;
  final Color sendButtonDisabledColor;
  final Color codeBackgroundColor;
  final Color codeTextColor;
  final Color errorColor;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const AIKitTheme({
    this.primaryColor = const Color(0xFF2196F3),
    this.backgroundColor = Colors.white,
    this.userMessageColor = const Color(0xFF2196F3),
    this.assistantMessageColor = const Color(0xFFF5F5F5),
    this.userMessageTextColor = Colors.white,
    this.assistantMessageTextColor = Colors.black87,
    this.userAvatarBackgroundColor = const Color(0xFF2196F3),
    this.userAvatarIconColor = Colors.white,
    this.assistantAvatarBackgroundColor = const Color(0xFFF5F5F5),
    this.assistantAvatarIconColor = const Color(0xFF2196F3),
    this.inputBackgroundColor = const Color(0xFFF5F5F5),
    this.inputTextColor = Colors.black87,
    this.inputHintColor = Colors.black54,
    this.sendButtonColor = const Color(0xFF2196F3),
    this.sendButtonDisabledColor = Colors.grey,
    this.codeBackgroundColor = const Color(0xFF1E1E1E),
    this.codeTextColor = Colors.white,
    this.errorColor = Colors.red,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding = const EdgeInsets.all(16),
  });

  AIKitTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? userMessageColor,
    Color? assistantMessageColor,
    Color? userMessageTextColor,
    Color? assistantMessageTextColor,
    Color? userAvatarBackgroundColor,
    Color? userAvatarIconColor,
    Color? assistantAvatarBackgroundColor,
    Color? assistantAvatarIconColor,
    Color? inputBackgroundColor,
    Color? inputTextColor,
    Color? inputHintColor,
    Color? sendButtonColor,
    Color? sendButtonDisabledColor,
    Color? codeBackgroundColor,
    Color? codeTextColor,
    Color? errorColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) {
    return AIKitTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      userMessageColor: userMessageColor ?? this.userMessageColor,
      assistantMessageColor: assistantMessageColor ?? this.assistantMessageColor,
      userMessageTextColor: userMessageTextColor ?? this.userMessageTextColor,
      assistantMessageTextColor: assistantMessageTextColor ?? this.assistantMessageTextColor,
      userAvatarBackgroundColor: userAvatarBackgroundColor ?? this.userAvatarBackgroundColor,
      userAvatarIconColor: userAvatarIconColor ?? this.userAvatarIconColor,
      assistantAvatarBackgroundColor: assistantAvatarBackgroundColor ?? this.assistantAvatarBackgroundColor,
      assistantAvatarIconColor: assistantAvatarIconColor ?? this.assistantAvatarIconColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      inputHintColor: inputHintColor ?? this.inputHintColor,
      sendButtonColor: sendButtonColor ?? this.sendButtonColor,
      sendButtonDisabledColor: sendButtonDisabledColor ?? this.sendButtonDisabledColor,
      codeBackgroundColor: codeBackgroundColor ?? this.codeBackgroundColor,
      codeTextColor: codeTextColor ?? this.codeTextColor,
      errorColor: errorColor ?? this.errorColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }

  factory AIKitTheme.dark() {
    return const AIKitTheme(
      primaryColor: Color(0xFF64B5F6),
      backgroundColor: Color(0xFF121212),
      userMessageColor: Color(0xFF64B5F6),
      userMessageTextColor: Colors.white,
      assistantMessageColor: Color(0xFF1E1E1E),
      assistantMessageTextColor: Colors.white70,
      userAvatarBackgroundColor: Color(0xFF64B5F6),
      userAvatarIconColor: Colors.white,
      assistantAvatarBackgroundColor: Color(0xFF1E1E1E),
      assistantAvatarIconColor: Color(0xFF64B5F6),
      inputBackgroundColor: Color(0xFF1E1E1E),
      inputTextColor: Colors.white,
      inputHintColor: Colors.white54,
      sendButtonColor: Color(0xFF64B5F6),
      sendButtonDisabledColor: Colors.grey,
      codeBackgroundColor: Color(0xFF2C2C2C),
      codeTextColor: Colors.white,
      errorColor: Colors.redAccent,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      padding: EdgeInsets.all(16),
    );
  }

  // Getters for backward compatibility
  EdgeInsets get messagePadding => padding;
  BorderRadius get messageBorderRadius => borderRadius;
  TextStyle get messageTextStyle => TextStyle(
        fontSize: 16,
        height: 1.5,
        color: assistantMessageTextColor,
      );

  ButtonStyle get primaryButtonStyle => ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return sendButtonDisabledColor;
            }
            if (states.contains(MaterialState.hovered)) {
              return HSLColor.fromColor(sendButtonColor)
                  .withLightness(
                      (HSLColor.fromColor(sendButtonColor).lightness - 0.1)
                          .clamp(0.0, 1.0))
                  .toColor();
            }
            return sendButtonColor;
          },
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
      );

  ButtonStyle get buttonStyle => ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return sendButtonDisabledColor;
            }
            if (states.contains(MaterialState.hovered)) {
              return HSLColor.fromColor(sendButtonColor)
                  .withLightness(
                      (HSLColor.fromColor(sendButtonColor).lightness - 0.1)
                          .clamp(0.0, 1.0))
                  .toColor();
            }
            return sendButtonColor;
          },
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(16),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
      );

  // Card decoration for consistent styling
  BoxDecoration get cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // Input field decoration
  InputDecoration inputDecoration({String? hintText}) => InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: inputHintColor,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: inputBackgroundColor,
      );

  // Loading indicator style
  Widget get loadingIndicator => SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );

  // Markdown style sheet for consistent markdown rendering
  MarkdownStyleSheet get markdownStyleSheet => MarkdownStyleSheet(
        p: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: inputTextColor,
        ),
        h1: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.4,
          color: Colors.black87,
        ),
        h2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: Colors.black87,
        ),
        h3: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: Colors.black87,
        ),
        code: TextStyle(
          fontFamily: 'monospace',
          backgroundColor: codeBackgroundColor,
          fontSize: 14,
          height: 1.4,
          color: codeTextColor,
        ),
        codeblockPadding: const EdgeInsets.all(12),
        codeblockDecoration: BoxDecoration(
          color: codeBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        blockquote: TextStyle(
          color: const Color(0xFF4B5563),
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: const Color(0xFFE5E7EB),
              width: 4,
            ),
          ),
        ),
        blockquotePadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        listBullet: TextStyle(
          color: const Color(0xFF4B5563),
        ),
        listIndent: 24,
        strong: const TextStyle(fontWeight: FontWeight.w600),
        em: const TextStyle(fontStyle: FontStyle.italic),
      );

  // Error style for consistent error messages
  SnackBarThemeData get snackBarTheme => SnackBarThemeData(
        backgroundColor: errorColor,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      );
}
