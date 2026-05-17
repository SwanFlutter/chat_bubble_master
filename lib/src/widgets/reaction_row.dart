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

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: reactions.entries.map((entry) {
          return _ReactionChip(
            key: ValueKey(entry.key),
            emoji: entry.key,
            count: entry.value,
            theme: theme,
            onTap: () => onReactionTap?.call(entry.key),
          );
        }).toList(),
    );
  }
}

class _ReactionChip extends StatefulWidget {
  final String emoji;
  final int count;
  final BubbleTheme theme;
  final VoidCallback onTap;

  const _ReactionChip({
    super.key,
    required this.emoji,
    required this.count,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_ReactionChip> createState() => _ReactionChipState();
}

class _ReactionChipState extends State<_ReactionChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_ReactionChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      // Re-run animation if count increases
      if (widget.count > oldWidget.count) {
        _controller.forward(from: 0.5);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: widget.theme.reactionBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.theme.replyAccentColor.withOpacity(0.4),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 13)),
              if (widget.count > 1) ...[
                const SizedBox(width: 3),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    '${widget.count}',
                    key: ValueKey(widget.count),
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.theme.timeColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
