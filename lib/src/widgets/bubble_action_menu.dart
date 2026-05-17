import 'package:flutter/material.dart';
import '../models/chat_message.dart';

/// The set of actions available on a chat bubble via long-press menu.
enum BubbleAction {
  reply,
  copy,
  forward,
  edit,
  delete,
  react,
}

/// Configuration to show/hide individual actions in the context menu.
class BubbleActionsConfig {
  final bool showReply;
  final bool showCopy;
  final bool showForward;
  final bool showEdit;
  final bool showDelete;
  final bool showReact;

  /// Quick emoji list shown in the reaction picker.
  final List<String> quickReactions;

  const BubbleActionsConfig({
    this.showReply = true,
    this.showCopy = true,
    this.showForward = true,
    this.showEdit = true,
    this.showDelete = true,
    this.showReact = true,
    this.quickReactions = const ['❤️', '😂', '😮', '😢', '👍', '👎'],
  });
}

/// Shows a modal bottom sheet with available actions for a message.
Future<void> showBubbleActionMenu({
  required BuildContext context,
  required ChatMessage message,
  required BubbleActionsConfig config,
  required void Function(BubbleAction action, ChatMessage message) onAction,
  required void Function(String emoji, ChatMessage message) onReact,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _BubbleActionSheet(
      message: message,
      config: config,
      onAction: onAction,
      onReact: onReact,
    ),
  );
}

class _BubbleActionSheet extends StatelessWidget {
  final ChatMessage message;
  final BubbleActionsConfig config;
  final void Function(BubbleAction action, ChatMessage message) onAction;
  final void Function(String emoji, ChatMessage message) onReact;

  const _BubbleActionSheet({
    required this.message,
    required this.config,
    required this.onAction,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sheetColor = isDark ? const Color(0xFF1F2C34) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111B21);
    final iconColor = isDark ? const Color(0xFF8696A0) : const Color(0xFF667781);

    return Container(
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Quick reactions
            if (config.showReact) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: config.quickReactions.map((emoji) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onReact(emoji, message);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A3942)
                              : const Color(0xFFF0F2F5),
                          shape: BoxShape.circle,
                        ),
                        child: Text(emoji,
                            style: const TextStyle(fontSize: 22)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Divider(
                  height: 1,
                  color: iconColor.withOpacity(0.2)),
            ],

            // Action items
            ..._buildActions(context, textColor, iconColor),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(
      BuildContext context, Color textColor, Color iconColor) {
    final items = <_ActionItem>[];

    if (config.showReply) {
      items.add(_ActionItem(
        icon: Icons.reply_rounded,
        label: 'Reply',
        action: BubbleAction.reply,
      ));
    }
    if (config.showCopy && message.text != null) {
      items.add(_ActionItem(
        icon: Icons.copy_rounded,
        label: 'Copy',
        action: BubbleAction.copy,
      ));
    }
    if (config.showForward) {
      items.add(_ActionItem(
        icon: Icons.forward_rounded,
        label: 'Forward',
        action: BubbleAction.forward,
      ));
    }
    if (config.showEdit && message.isSent) {
      items.add(_ActionItem(
        icon: Icons.edit_rounded,
        label: 'Edit',
        action: BubbleAction.edit,
      ));
    }
    if (config.showDelete) {
      items.add(_ActionItem(
        icon: Icons.delete_outline_rounded,
        label: 'Delete',
        action: BubbleAction.delete,
        isDestructive: true,
      ));
    }

    return items.map((item) {
      return ListTile(
        leading: Icon(
          item.icon,
          color: item.isDestructive ? Colors.red : iconColor,
          size: 22,
        ),
        title: Text(
          item.label,
          style: TextStyle(
            color: item.isDestructive ? Colors.red : textColor,
            fontSize: 15,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          onAction(item.action, message);
        },
        dense: true,
        visualDensity: VisualDensity.compact,
      );
    }).toList();
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final BubbleAction action;
  final bool isDestructive;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.action,
    this.isDestructive = false,
  });
}
