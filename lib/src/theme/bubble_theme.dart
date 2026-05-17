import 'package:flutter/material.dart';

/// Defines the visual theme for chat bubbles.
class BubbleTheme {
  /// Background color for sent (outgoing) bubbles.
  final Color sentBubbleColor;

  /// Background color for received (incoming) bubbles.
  final Color receivedBubbleColor;

  /// Text color for sent bubble content.
  final Color sentTextColor;

  /// Text color for received bubble content.
  final Color receivedTextColor;

  /// Color for the time/status text.
  final Color timeColor;

  /// Color for the reply preview background.
  final Color replyBackgroundColor;

  /// Color for the reply preview left border accent.
  final Color replyAccentColor;

  /// Color for the reply preview text.
  final Color replyTextColor;

  /// Color for the sender name in group chats.
  final Color senderNameColor;

  /// Background color for the reactions row.
  final Color reactionBackgroundColor;

  /// Text style for the main message text.
  final TextStyle? messageTextStyle;

  /// Text style for the time label.
  final TextStyle? timeTextStyle;

  /// Text style for the sender name.
  final TextStyle? senderNameTextStyle;

  /// Text style for the reply preview text.
  final TextStyle? replyTextStyle;

  /// Shadow color for the bubble.
  final Color shadowColor;

  /// Elevation of the bubble shadow.
  final double elevation;

  const BubbleTheme({
    this.sentBubbleColor = const Color(0xFF005C4B),
    this.receivedBubbleColor = const Color(0xFF1F2C34),
    this.sentTextColor = Colors.white,
    this.receivedTextColor = Colors.white,
    this.timeColor = const Color(0xFF8696A0),
    this.replyBackgroundColor = const Color(0xFF182229),
    this.replyAccentColor = const Color(0xFF00A884),
    this.replyTextColor = const Color(0xFF8696A0),
    this.senderNameColor = const Color(0xFF00A884),
    this.reactionBackgroundColor = const Color(0xFF182229),
    this.messageTextStyle,
    this.timeTextStyle,
    this.senderNameTextStyle,
    this.replyTextStyle,
    this.shadowColor = Colors.black26,
    this.elevation = 1.0,
  });

  /// A light WhatsApp-like theme.
  static const BubbleTheme whatsappLight = BubbleTheme(
    sentBubbleColor: Color(0xFFD9FDD3),
    receivedBubbleColor: Colors.white,
    sentTextColor: Color(0xFF111B21),
    receivedTextColor: Color(0xFF111B21),
    timeColor: Color(0xFF667781),
    replyBackgroundColor: Color(0xFFD1F4CC),
    replyAccentColor: Color(0xFF25D366),
    replyTextColor: Color(0xFF667781),
    senderNameColor: Color(0xFF25D366),
    reactionBackgroundColor: Color(0xFFEEF0F1),
    shadowColor: Colors.black12,
    elevation: 1.0,
  );

  /// A dark WhatsApp-like theme.
  static const BubbleTheme whatsappDark = BubbleTheme(
    sentBubbleColor: Color(0xFF005C4B),
    receivedBubbleColor: Color(0xFF1F2C34),
    sentTextColor: Colors.white,
    receivedTextColor: Colors.white,
    timeColor: Color(0xFF8696A0),
    replyBackgroundColor: Color(0xFF182229),
    replyAccentColor: Color(0xFF00A884),
    replyTextColor: Color(0xFF8696A0),
    senderNameColor: Color(0xFF00A884),
    reactionBackgroundColor: Color(0xFF182229),
    shadowColor: Colors.black45,
    elevation: 1.0,
  );

  /// A Telegram-like theme.
  static const BubbleTheme telegram = BubbleTheme(
    sentBubbleColor: Color(0xFF2B5278),
    receivedBubbleColor: Color(0xFF182533),
    sentTextColor: Colors.white,
    receivedTextColor: Colors.white,
    timeColor: Color(0xFF6D8FAB),
    replyBackgroundColor: Color(0xFF1C3A52),
    replyAccentColor: Color(0xFF5AABFF),
    replyTextColor: Color(0xFF6D8FAB),
    senderNameColor: Color(0xFF5AABFF),
    reactionBackgroundColor: Color(0xFF1C3A52),
    shadowColor: Colors.black38,
    elevation: 0.5,
  );

  BubbleTheme copyWith({
    Color? sentBubbleColor,
    Color? receivedBubbleColor,
    Color? sentTextColor,
    Color? receivedTextColor,
    Color? timeColor,
    Color? replyBackgroundColor,
    Color? replyAccentColor,
    Color? replyTextColor,
    Color? senderNameColor,
    Color? reactionBackgroundColor,
    TextStyle? messageTextStyle,
    TextStyle? timeTextStyle,
    TextStyle? senderNameTextStyle,
    TextStyle? replyTextStyle,
    Color? shadowColor,
    double? elevation,
  }) {
    return BubbleTheme(
      sentBubbleColor: sentBubbleColor ?? this.sentBubbleColor,
      receivedBubbleColor: receivedBubbleColor ?? this.receivedBubbleColor,
      sentTextColor: sentTextColor ?? this.sentTextColor,
      receivedTextColor: receivedTextColor ?? this.receivedTextColor,
      timeColor: timeColor ?? this.timeColor,
      replyBackgroundColor: replyBackgroundColor ?? this.replyBackgroundColor,
      replyAccentColor: replyAccentColor ?? this.replyAccentColor,
      replyTextColor: replyTextColor ?? this.replyTextColor,
      senderNameColor: senderNameColor ?? this.senderNameColor,
      reactionBackgroundColor:
          reactionBackgroundColor ?? this.reactionBackgroundColor,
      messageTextStyle: messageTextStyle ?? this.messageTextStyle,
      timeTextStyle: timeTextStyle ?? this.timeTextStyle,
      senderNameTextStyle: senderNameTextStyle ?? this.senderNameTextStyle,
      replyTextStyle: replyTextStyle ?? this.replyTextStyle,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
    );
  }
}
