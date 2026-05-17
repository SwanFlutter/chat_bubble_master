import 'package:chat_bubble_master/chat_bubble_master.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatBubbleMasterExampleApp());
}

class ChatBubbleMasterExampleApp extends StatelessWidget {
  const ChatBubbleMasterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Bubble Master Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B141A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2C34),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const ChatDemoScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// Demo screen
// ---------------------------------------------------------------------------

class ChatDemoScreen extends StatefulWidget {
  const ChatDemoScreen({super.key});

  @override
  State<ChatDemoScreen> createState() => _ChatDemoScreenState();
}

class _ChatDemoScreenState extends State<ChatDemoScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Current clipper index (0–9)
  int _clipperIndex = 0;

  // Current theme
  BubbleTheme _theme = BubbleTheme.whatsappDark;
  String _themeName = 'WhatsApp Dark';

  // Message being replied to
  ChatMessage? _replyingTo;

  // Message being edited
  ChatMessage? _editingMessage;

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text: 'Hey! How are you doing?',
      senderName: 'Alice',
      isSent: false,
      time: '10:00',
      isRead: true,
    ),
    ChatMessage(
      id: '2',
      text: 'I\'m doing great, thanks for asking! 😊',
      isSent: true,
      time: '10:01',
      isRead: true,
    ),
    ChatMessage(
      id: '3',
      text: 'Did you check out the new Flutter update?',
      senderName: 'Alice',
      isSent: false,
      time: '10:02',
      isRead: true,
    ),
    ChatMessage(
      id: '4',
      text: 'Yes! The performance improvements are amazing.',
      isSent: true,
      time: '10:03',
      isDelivered: true,
      isRead: false,
    ),
    ChatMessage(
      id: '5',
      text: 'Totally agree. The new rendering engine is blazing fast.',
      senderName: 'Alice',
      isSent: false,
      time: '10:04',
      reactions: {'❤️': 2, '🔥': 1},
    ),
    ChatMessage(
      id: '6',
      text: 'We should build something with it!',
      isSent: true,
      time: '10:05',
      isRead: true,
      isEdited: true,
    ),
    ChatMessage(
      id: '7',
      text: 'This message has a reply preview below it.',
      senderName: 'Alice',
      isSent: false,
      time: '10:06',
      replyMessage: ChatMessage(
        id: '6',
        text: 'We should build something with it!',
        isSent: true,
        senderName: 'You',
      ),
    ),
  ];

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String get _nextId =>
      DateTime.now().millisecondsSinceEpoch.toString();

  CustomClipper<Path> _getClipper(BubbleType type) {
    switch (_clipperIndex) {
      case 0:
        return ChatBubbleClipper1(type: type);
      case 1:
        return ChatBubbleClipper2(type: type);
      case 2:
        return ChatBubbleClipper3(type: type);
      case 3:
        return ChatBubbleClipper4(type: type);
      case 4:
        return ChatBubbleClipper5(type: type);
      case 5:
        return ChatBubbleClipper6(type: type);
      case 6:
        return ChatBubbleClipper7(type: type);
      case 7:
        return ChatBubbleClipper8(type: type);
      case 8:
        return ChatBubbleClipper9(type: type);
      case 9:
      default:
        return ChatBubbleClipper10(type: type);
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (_editingMessage != null) {
        // Edit existing message
        final idx = _messages.indexWhere((m) => m.id == _editingMessage!.id);
        if (idx != -1) {
          _messages[idx] = _messages[idx].copyWith(
            text: text,
            isEdited: true,
          );
        }
        _editingMessage = null;
      } else {
        // New message
        _messages.add(ChatMessage(
          id: _nextId,
          text: text,
          isSent: true,
          time: _currentTime(),
          isDelivered: true,
          replyMessage: _replyingTo,
        ));
        _replyingTo = null;
      }
    });

    _inputController.clear();
    _scrollToBottom();
  }

  String _currentTime() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleAction(BubbleAction action, ChatMessage message) {
    switch (action) {
      case BubbleAction.reply:
        setState(() => _replyingTo = message);
        break;
      case BubbleAction.forward:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Forwarding: "${message.text}"'),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
      case BubbleAction.edit:
        setState(() {
          _editingMessage = message;
          _inputController.text = message.text ?? '';
        });
        break;
      case BubbleAction.delete:
        _confirmDelete(message);
        break;
      case BubbleAction.copy:
        // Copy is handled inside ChatBubbleMaster automatically
        break;
      case BubbleAction.react:
        break;
    }
  }

  void _handleReact(String emoji, ChatMessage message) {
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == message.id);
      if (idx == -1) return;
      final current = Map<String, int>.from(_messages[idx].reactions);
      current[emoji] = (current[emoji] ?? 0) + 1;
      _messages[idx] = _messages[idx].copyWith(reactions: current);
    });
  }

  void _handleReactionTap(String emoji, ChatMessage message) {
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == message.id);
      if (idx == -1) return;
      final current = Map<String, int>.from(_messages[idx].reactions);
      if (current.containsKey(emoji)) {
        if (current[emoji]! <= 1) {
          current.remove(emoji);
        } else {
          current[emoji] = current[emoji]! - 1;
        }
      }
      _messages[idx] = _messages[idx].copyWith(reactions: current);
    });
  }

  void _confirmDelete(ChatMessage message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1F2C34),
        title: const Text('Delete message?',
            style: TextStyle(color: Colors.white)),
        content: const Text('This action cannot be undone.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() =>
                  _messages.removeWhere((m) => m.id == message.id));
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _cycleTheme() {
    setState(() {
      switch (_themeName) {
        case 'WhatsApp Dark':
          _theme = BubbleTheme.whatsappLight;
          _themeName = 'WhatsApp Light';
          break;
        case 'WhatsApp Light':
          _theme = BubbleTheme.telegram;
          _themeName = 'Telegram';
          break;
        default:
          _theme = BubbleTheme.whatsappDark;
          _themeName = 'WhatsApp Dark';
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = _themeName != 'WhatsApp Light';
    final bgColor = isDark ? const Color(0xFF0B141A) : const Color(0xFFEBEBEB);
    final inputBg = isDark ? const Color(0xFF1F2C34) : Colors.white;
    final inputText = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chat Bubble Master',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Demo', style: TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
        actions: [
          // Theme switcher
          IconButton(
            tooltip: 'Switch theme ($_themeName)',
            icon: const Icon(Icons.palette_outlined),
            onPressed: _cycleTheme,
          ),
          // Clipper switcher
          PopupMenuButton<int>(
            tooltip: 'Switch bubble shape',
            icon: const Icon(Icons.bubble_chart_outlined),
            color: const Color(0xFF1F2C34),
            onSelected: (v) => setState(() => _clipperIndex = v),
            itemBuilder: (_) => List.generate(
              10,
              (i) => PopupMenuItem(
                value: i,
                child: Text(
                  'Shape ${i + 1}',
                  style: TextStyle(
                    color: _clipperIndex == i
                        ? const Color(0xFF00A884)
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Shape indicator
          Container(
            color: isDark
                ? const Color(0xFF1F2C34)
                : const Color(0xFFD1D7DB),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 14, color: Colors.white54),
                const SizedBox(width: 6),
                Text(
                  'Shape: Clipper ${_clipperIndex + 1}  •  Theme: $_themeName',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatBubbleMaster(
                  message: msg,
                  clipper: _getClipper(
                    msg.isSent
                        ? BubbleType.sendBubble
                        : BubbleType.receiverBubble,
                  ),
                  theme: _theme,
                  showAvatar: true,
                  showSenderName: true,
                  onAction: _handleAction,
                  onReact: _handleReact,
                  onReactionTap: (emoji) =>
                      _handleReactionTap(emoji, msg),
                  onSwipeReply: (m) =>
                      setState(() => _replyingTo = m),
                );
              },
            ),
          ),

          // Reply / Edit banner
          if (_replyingTo != null || _editingMessage != null)
            _buildInputBanner(isDark),

          // Input bar
          _buildInputBar(inputBg, inputText, isDark),
        ],
      ),
    );
  }

  Widget _buildInputBanner(bool isDark) {
    final isEdit = _editingMessage != null;
    final msg = isEdit ? _editingMessage! : _replyingTo!;
    return Container(
      color: isDark ? const Color(0xFF1F2C34) : const Color(0xFFD1D7DB),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(
            isEdit ? Icons.edit_rounded : Icons.reply_rounded,
            color: const Color(0xFF00A884),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? 'Editing message' : 'Replying to ${msg.senderName ?? (msg.isSent ? "You" : "Them")}',
                  style: const TextStyle(
                    color: Color(0xFF00A884),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  msg.text ?? '',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54, size: 18),
            onPressed: () => setState(() {
              _replyingTo = null;
              _editingMessage = null;
              _inputController.clear();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(Color bg, Color textColor, bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF1F2C34) : const Color(0xFFD1D7DB),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: TextStyle(color: textColor, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: _editingMessage != null
                            ? 'Edit message...'
                            : 'Type a message',
                        hintStyle: TextStyle(
                            color: textColor.withOpacity(0.4),
                            fontSize: 15),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Color(0xFF00A884),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _editingMessage != null
                    ? Icons.check_rounded
                    : Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
