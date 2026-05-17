/// Model representing a single chat message.
class ChatMessage {
  /// Unique identifier for the message.
  final String id;

  /// The text content of the message.
  final String? text;

  /// The sender's name (used for group chats or receiver display).
  final String? senderName;

  /// URL or asset path for the sender's avatar image.
  final String? avatarUrl;

  /// Timestamp string to display (e.g. "10:30 AM").
  final String? time;

  /// Whether this message was sent by the current user.
  final bool isSent;

  /// Whether the message has been read by the recipient.
  final bool isRead;

  /// Whether the message has been delivered.
  final bool isDelivered;

  /// The message being replied to, if any.
  final ChatMessage? replyMessage;

  /// Whether this message has been edited.
  final bool isEdited;

  /// Emoji reactions on this message, e.g. {'❤️': 3, '😂': 1}.
  final Map<String, int> reactions;

  const ChatMessage({
    required this.id,
    this.text,
    this.senderName,
    this.avatarUrl,
    this.time,
    this.isSent = false,
    this.isRead = false,
    this.isDelivered = false,
    this.replyMessage,
    this.isEdited = false,
    this.reactions = const {},
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    String? senderName,
    String? avatarUrl,
    String? time,
    bool? isSent,
    bool? isRead,
    bool? isDelivered,
    ChatMessage? replyMessage,
    bool? isEdited,
    Map<String, int>? reactions,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      senderName: senderName ?? this.senderName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      time: time ?? this.time,
      isSent: isSent ?? this.isSent,
      isRead: isRead ?? this.isRead,
      isDelivered: isDelivered ?? this.isDelivered,
      replyMessage: replyMessage ?? this.replyMessage,
      isEdited: isEdited ?? this.isEdited,
      reactions: reactions ?? this.reactions,
    );
  }
}
