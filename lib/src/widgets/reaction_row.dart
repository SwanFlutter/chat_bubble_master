import 'package:flutter/material.dart';
import '../theme/bubble_theme.dart';

/// Displays emoji reactions below a chat bubble.
class ReactionRow extends StatelessWidget {
  /// Map of emoji to count, e.g. {'❤️': 2, '😂': 1}.
  final Map<String, int> reactions;
  final BubbleTheme theme;

  /// Called when the user taps a reaction to toggle it.
  final void Function(String emoji)? onReactionTap;

  const ReactionRow({
    super.key,
    required this.reactions,
    required this.theme,
    this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: reactions.entries.map((entry) {
          return GestureDetector(
            onTap: () => onReactionTap?.call(entry.key),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: theme.reactionBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.replyAccentColor.withOpacity(0.4),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(entry.key,
                      style: const TextStyle(fontSize: 13)),
                  if (entry.value > 1) ...[
                    const SizedBox(width: 3),
                    Text(
                      '${entry.value}',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.timeColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
