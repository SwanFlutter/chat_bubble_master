/// Chat Bubble Master
///
/// A highly customizable Flutter chat bubble package with support for:
/// - 10 different bubble shapes (clippers)
/// - Reply, Forward, Copy, Edit, Delete actions
/// - Emoji reactions
/// - Read receipts and delivery status
/// - Avatar display
/// - Fully themeable via [BubbleTheme]
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/models/chat_message.dart';
import 'src/theme/bubble_theme.dart';
import 'src/widgets/bubble_action_menu.dart';
import 'src/widgets/bubble_avatar.dart';
import 'src/widgets/reaction_row.dart';
import 'src/widgets/reply_preview.dart';

export 'src/clippers/chat_bubble_clipper_1.dart';
export 'src/clippers/chat_bubble_clipper_10.dart';
export 'src/clippers/chat_bubble_clipper_2.dart';
export 'src/clippers/chat_bubble_clipper_3.dart';
export 'src/clippers/chat_bubble_clipper_4.dart';
export 'src/clippers/chat_bubble_clipper_5.dart';
export 'src/clippers/chat_bubble_clipper_6.dart';
export 'src/clippers/chat_bubble_clipper_7.dart';
export 'src/clippers/chat_bubble_clipper_8.dart';
export 'src/clippers/chat_bubble_clipper_9.dart';
export 'src/models/chat_message.dart';
export 'src/theme/bubble_theme.dart';
export 'src/tools/bubble_type.dart';
export 'src/widgets/bubble_action_menu.dart';
export 'src/widgets/bubble_avatar.dart';
export 'src/widgets/reaction_row.dart';
export 'src/widgets/reply_preview.dart';

/// The main chat bubble widget.
///
/// Wraps a message in a shaped bubble with optional reply preview,
/// reactions, avatar, status icons, and a long-press action menu.
///
/// Example:
/// ```dart
/// ChatBubbleMaster(
///   message: ChatMessage(
///     id: '1',
///     text: 'Hello!',
///     isSent: true,
///     time: '10:30',
///     isRead: true,
///   ),
///   clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
/// )
/// ```
class ChatBubbleMaster extends StatelessWidget {
  /// The message data to display.
  final ChatMessage message;

  /// The clipper that defines the bubble shape.
  /// If null, a plain rounded rectangle is used.
  final CustomClipper<Path>? clipper;

  /// Custom child widget. If provided, overrides [message.text] rendering.
  final Widget? child;

  /// Outer margin around the bubble row.
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the bubble.
  final EdgeInsetsGeometry? padding;

  /// Shadow elevation.
  final double? elevation;

  /// Override bubble background color (ignores theme).
  final Color? bubbleColor;

  /// Override shadow color (ignores theme).
  final Color? shadowColor;

  /// Visual theme for colors and text styles.
  final BubbleTheme theme;

  /// Maximum width of the bubble as a fraction of screen width (0.0–1.0).
  final double maxWidthFraction;

  /// Whether to show the sender's avatar (useful for received messages).
  final bool showAvatar;

  /// Whether to show the sender's name above the bubble (for group chats).
  final bool showSenderName;

  /// Configuration for which actions appear in the long-press menu.
  final BubbleActionsConfig actionsConfig;

  /// Called when the user selects an action from the context menu.
  final void Function(BubbleAction action, ChatMessage message)? onAction;

  /// Called when the user taps a reaction or picks one from the menu.
  final void Function(String emoji, ChatMessage message)? onReact;

  /// Called when a reaction chip is tapped (to toggle/remove).
  final void Function(String emoji)? onReactionTap;

  /// Called when the user swipes the bubble (for quick reply).
  final void Function(ChatMessage message)? onSwipeReply;

  const ChatBubbleMaster({
    super.key,
    required this.message,
    this.clipper,
    this.child,
    this.margin,
    this.padding,
    this.elevation,
    this.bubbleColor,
    this.shadowColor,
    this.theme = BubbleTheme.whatsappDark,
    this.maxWidthFraction = 0.75,
    this.showAvatar = false,
    this.showSenderName = false,
    this.actionsConfig = const BubbleActionsConfig(),
    this.onAction,
    this.onReact,
    this.onReactionTap,
    this.onSwipeReply,
  });

  bool get _isSent => message.isSent;

  Color get _bubbleColor {
    if (bubbleColor != null) return bubbleColor!;
    return _isSent ? theme.sentBubbleColor : theme.receivedBubbleColor;
  }

  Color get _textColor =>
      _isSent ? theme.sentTextColor : theme.receivedTextColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * maxWidthFraction;

    Widget bubbleContent = _buildBubble(context, maxWidth);

    // Wrap with swipe-to-reply gesture
    if (onSwipeReply != null) {
      bubbleContent = _SwipeToReply(
        isSent: _isSent,
        onSwipe: () => onSwipeReply!(message),
        child: bubbleContent,
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        crossAxisAlignment: _isSent
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: _isSent
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar for received messages
              if (!_isSent && showAvatar) ...[
                BubbleAvatar(
                  avatarUrl: message.avatarUrl,
                  senderName: message.senderName,
                  size: 32,
                ),
                const SizedBox(width: 6),
              ],

              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: bubbleContent,
              ),

              // Spacer for sent messages (no avatar)
              if (_isSent && showAvatar) const SizedBox(width: 38),
            ],
          ),

          // Reactions below the bubble
          if (message.reactions.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                left: (!_isSent && showAvatar) ? 38 : 8,
                right: 8,
                top: 2,
              ),
              child: ReactionRow(
                reactions: message.reactions,
                theme: theme,
                onReactionTap: onReactionTap,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBubble(BuildContext context, double maxWidth) {
    final bubbleBody = GestureDetector(
      onLongPress: () {
        if (onAction != null || onReact != null) {
          showBubbleActionMenu(
            context: context,
            message: message,
            config: actionsConfig,
            onAction: (action, msg) {
              if (action == BubbleAction.copy && msg.text != null) {
                Clipboard.setData(ClipboardData(text: msg.text!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message copied'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
              onAction?.call(action, msg);
            },
            onReact: (emoji, msg) => onReact?.call(emoji, msg),
          );
        }
      },
      child: _buildShape(context),
    );

    return bubbleBody;
  }

  Widget _buildShape(BuildContext context) {
    // Calculate adaptive padding based on bubble type and clipper
    // Received messages need more left padding to avoid nip overlap
    final adaptivePadding =
        padding ??
        EdgeInsets.fromLTRB(
          _isSent ? 12 : 16, // More left padding for received messages
          10,
          12, // Right padding
          10,
        );

    final innerContent = Padding(
      padding: adaptivePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender name (group chats)
          if (showSenderName && !_isSent && message.senderName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                message.senderName!,
                style:
                    (theme.senderNameTextStyle ??
                            const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ))
                        .copyWith(color: theme.senderNameColor),
              ),
            ),

          // Reply preview
          if (message.replyMessage != null)
            ReplyPreview(replyMessage: message.replyMessage!, theme: theme),

          // Main content
          child ??
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  message.text ?? '',
                  style:
                      (theme.messageTextStyle ?? const TextStyle(fontSize: 15))
                          .copyWith(color: _textColor),
                ),
              ),

          const SizedBox(height: 3),

          // Time + status row
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (message.isEdited)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    'edited',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.timeColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              if (message.time != null)
                Text(
                  message.time!,
                  style: (theme.timeTextStyle ?? const TextStyle(fontSize: 10))
                      .copyWith(color: theme.timeColor),
                ),
              if (_isSent) ...[const SizedBox(width: 4), _buildStatusIcon()],
            ],
          ),
        ],
      ),
    );

    if (clipper == null) {
      // Fallback: plain rounded rectangle
      return Material(
        color: _bubbleColor,
        elevation: elevation ?? theme.elevation,
        shadowColor: shadowColor ?? theme.shadowColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: _isSent
              ? const Radius.circular(12)
              : const Radius.circular(2),
          bottomRight: _isSent
              ? const Radius.circular(2)
              : const Radius.circular(12),
        ),
        child: innerContent,
      );
    }

    return PhysicalShape(
      clipper: clipper!,
      elevation: elevation ?? theme.elevation,
      color: _bubbleColor,
      shadowColor: shadowColor ?? theme.shadowColor,
      child: innerContent,
    );
  }

  Widget _buildStatusIcon() {
    if (message.isRead) {
      return Icon(
        Icons.done_all_rounded,
        size: 14,
        color: theme.replyAccentColor,
      );
    } else if (message.isDelivered) {
      return Icon(Icons.done_all_rounded, size: 14, color: theme.timeColor);
    } else {
      return Icon(Icons.done_rounded, size: 14, color: theme.timeColor);
    }
  }
}

// ---------------------------------------------------------------------------
// Swipe-to-reply gesture wrapper
// ---------------------------------------------------------------------------

class _SwipeToReply extends StatefulWidget {
  final bool isSent;
  final VoidCallback onSwipe;
  final Widget child;

  const _SwipeToReply({
    required this.isSent,
    required this.onSwipe,
    required this.child,
  });

  @override
  State<_SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<_SwipeToReply>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> offsetAnim;
  double _dragOffset = 0;
  static const double _threshold = 60;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    offsetAnim = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    // Sent bubbles swipe right→left, received swipe left→right
    final delta = widget.isSent ? -details.delta.dx : details.delta.dx;
    if (delta > 0) {
      setState(() {
        _dragOffset = (_dragOffset + delta).clamp(0, _threshold * 1.2);
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails _) {
    if (_dragOffset >= _threshold) {
      widget.onSwipe();
    }
    offsetAnim = Tween<double>(
      begin: _dragOffset,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0).then((_) {
      setState(() => _dragOffset = 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final slideX = widget.isSent ? -_dragOffset : _dragOffset;
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Reply icon hint
          if (_dragOffset > 10)
            Positioned(
              left: widget.isSent ? null : -36,
              right: widget.isSent ? -36 : null,
              top: 0,
              bottom: 0,
              child: Center(
                child: Opacity(
                  opacity: (_dragOffset / _threshold).clamp(0, 1),
                  child: const Icon(
                    Icons.reply_rounded,
                    color: Colors.white54,
                    size: 22,
                  ),
                ),
              ),
            ),
          Transform.translate(offset: Offset(slideX, 0), child: widget.child),
        ],
      ),
    );
  }
}
