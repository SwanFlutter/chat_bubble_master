import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../theme/bubble_theme.dart';

/// Displays a compact preview of the message being replied to,
/// shown inside the bubble above the main content.
class ReplyPreview extends StatelessWidget {
  final ChatMessage replyMessage;
  final BubbleTheme theme;

  const ReplyPreview({
    super.key,
    required this.replyMessage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: theme.replyBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: theme.replyAccentColor, width: 3),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            replyMessage.senderName ??
                (replyMessage.isSent ? 'You' : 'Them'),
            style: (theme.senderNameTextStyle ??
                    const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ))
                .copyWith(color: theme.replyAccentColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            replyMessage.text ?? '',
            style: (theme.replyTextStyle ??
                    const TextStyle(fontSize: 12))
                .copyWith(color: theme.replyTextColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
