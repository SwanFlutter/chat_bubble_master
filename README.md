# Chat Bubble Master

A highly customizable Flutter chat bubble package with **10 bubble shapes**, full action support (reply, forward, copy, edit, delete), emoji reactions, read receipts, avatar display, swipe-to-reply, and complete theming.

---

## Features

| Feature | Description |
|---|---|
| 🫧 10 Bubble Shapes | Choose from 10 different clipper styles |
| ↩️ Reply | Swipe or long-press to reply with a preview |
| ↗️ Forward | Forward messages via the action menu |
| 📋 Copy | Copy message text to clipboard |
| ✏️ Edit | Edit sent messages (shows "edited" label) |
| 🗑️ Delete | Delete messages with confirmation |
| 😀 Reactions | Emoji reactions with counts, tap to toggle |
| 👤 Avatar | Circular avatar with initials fallback |
| ✅ Read Receipts | Sent / Delivered / Read status icons |
| 🎨 Themes | Built-in WhatsApp Dark, WhatsApp Light, Telegram themes |
| 🔄 Swipe to Reply | Swipe bubble left/right for quick reply |

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  chat_bubble_master:
    path: ../  # or your pub.dev version
```

---

## Quick Start

```dart
import 'package:chat_bubble_master/chat_bubble_master.dart';

ChatBubbleMaster(
  message: ChatMessage(
    id: '1',
    text: 'Hello World!',
    isSent: true,
    time: '10:30',
    isRead: true,
  ),
  clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
  theme: BubbleTheme.whatsappDark,
)
```

---

## ChatMessage Model

```dart
ChatMessage(
  id: 'unique_id',           // required
  text: 'Message text',
  senderName: 'Alice',       // shown in group chats
  avatarUrl: 'https://...',  // or null for initials
  time: '10:30',
  isSent: true,              // true = right side, false = left side
  isRead: true,
  isDelivered: true,
  isEdited: false,
  reactions: {'❤️': 2, '😂': 1},
  replyMessage: ChatMessage(...), // nested reply
)
```

---

## Bubble Shapes

Switch between 10 shapes by changing the clipper:

```dart
// Shape 1 – classic nip at top
ChatBubbleClipper1(type: BubbleType.sendBubble)

// Shape 2 – nip at bottom
ChatBubbleClipper2(type: BubbleType.receiverBubble)

// Shape 3 – curved nip
ChatBubbleClipper3(type: BubbleType.sendBubble)

// Shape 4 – rectangular with side nip
ChatBubbleClipper4(type: BubbleType.sendBubble)

// Shape 5 – rounded with corner cut
ChatBubbleClipper5(type: BubbleType.sendBubble)

// Shape 6 – curved bottom nip
ChatBubbleClipper6(type: BubbleType.sendBubble)

// Shape 7 – diagonal corners
ChatBubbleClipper7(type: BubbleType.sendBubble)

// Shape 8 – ear-style nip
ChatBubbleClipper8(type: BubbleType.sendBubble)

// Shape 9 – bezier nip
ChatBubbleClipper9(type: BubbleType.sendBubble)

// Shape 10 – top nip
ChatBubbleClipper10(type: BubbleType.sendBubble)
```

All clippers accept optional parameters:

```dart
ChatBubbleClipper1(
  type: BubbleType.sendBubble,
  radius: 10,       // corner radius
  nipHeight: 10,    // nip height
  nipWidth: 15,     // nip width
  nipRadius: 3,     // nip curve radius
)
```

---

## Theming

### Built-in Themes

```dart
// WhatsApp dark (default)
theme: BubbleTheme.whatsappDark

// WhatsApp light
theme: BubbleTheme.whatsappLight

// Telegram dark
theme: BubbleTheme.telegram
```

### Custom Theme

```dart
theme: BubbleTheme(
  sentBubbleColor: Colors.teal.shade700,
  receivedBubbleColor: Colors.grey.shade800,
  sentTextColor: Colors.white,
  receivedTextColor: Colors.white,
  timeColor: Colors.white38,
  replyAccentColor: Colors.tealAccent,
  replyBackgroundColor: Colors.teal.shade900,
  replyTextColor: Colors.white54,
  senderNameColor: Colors.tealAccent,
  reactionBackgroundColor: Colors.grey.shade900,
  shadowColor: Colors.black45,
  elevation: 2.0,
  messageTextStyle: TextStyle(fontSize: 15),
)
```

---

## Actions (Long-Press Menu)

```dart
ChatBubbleMaster(
  message: message,
  clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
  actionsConfig: BubbleActionsConfig(
    showReply: true,
    showCopy: true,
    showForward: true,
    showEdit: true,       // only shown for sent messages
    showDelete: true,
    showReact: true,
    quickReactions: ['❤️', '😂', '😮', '😢', '👍', '👎'],
  ),
  onAction: (action, message) {
    switch (action) {
      case BubbleAction.reply:
        setState(() => _replyingTo = message);
        break;
      case BubbleAction.forward:
        // handle forward
        break;
      case BubbleAction.edit:
        // open edit input
        break;
      case BubbleAction.delete:
        // remove message
        break;
      case BubbleAction.copy:
        // handled automatically (copies to clipboard)
        break;
      case BubbleAction.react:
        break;
    }
  },
  onReact: (emoji, message) {
    // add reaction to message
  },
)
```

---

## Reply

Pass a `replyMessage` inside `ChatMessage` to show a reply preview:

```dart
ChatMessage(
  id: '5',
  text: 'Yes, exactly!',
  isSent: true,
  time: '10:35',
  replyMessage: ChatMessage(
    id: '3',
    text: 'Did you see the update?',
    senderName: 'Alice',
    isSent: false,
  ),
)
```

---

## Swipe to Reply

```dart
ChatBubbleMaster(
  message: message,
  clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
  onSwipeReply: (message) {
    setState(() => _replyingTo = message);
  },
)
```

---

## Avatar

```dart
ChatBubbleMaster(
  message: message,
  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
  showAvatar: true,       // shows avatar on the left for received
  showSenderName: true,   // shows name above bubble
)
```

Avatar falls back to colored initials if `avatarUrl` is null.

---

## Reactions

```dart
ChatBubbleMaster(
  message: ChatMessage(
    id: '1',
    text: 'Great idea!',
    isSent: false,
    reactions: {'❤️': 3, '😂': 1},
  ),
  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
  onReactionTap: (emoji) {
    // toggle/remove reaction
  },
)
```

---

## Full Example

See [`example/lib/main.dart`](example/lib/main.dart) for a complete working demo featuring:

- All 10 bubble shapes switchable at runtime
- All 3 built-in themes switchable at runtime
- Send, reply, edit, delete, forward, copy, react
- Swipe-to-reply gesture
- Avatar with initials fallback
- Read receipts

---

## API Reference

### `ChatBubbleMaster`

| Property | Type | Default | Description |
|---|---|---|---|
| `message` | `ChatMessage` | required | Message data |
| `clipper` | `CustomClipper<Path>?` | null | Bubble shape clipper |
| `child` | `Widget?` | null | Custom content (overrides text) |
| `theme` | `BubbleTheme` | `whatsappDark` | Visual theme |
| `margin` | `EdgeInsetsGeometry?` | `v:2 h:8` | Outer margin |
| `padding` | `EdgeInsetsGeometry?` | `all:10` | Inner padding |
| `elevation` | `double?` | from theme | Shadow elevation |
| `bubbleColor` | `Color?` | from theme | Override bubble color |
| `maxWidthFraction` | `double` | `0.75` | Max width as screen fraction |
| `showAvatar` | `bool` | `false` | Show sender avatar |
| `showSenderName` | `bool` | `false` | Show sender name |
| `actionsConfig` | `BubbleActionsConfig` | all enabled | Action menu config |
| `onAction` | `Function?` | null | Action menu callback |
| `onReact` | `Function?` | null | Reaction picker callback |
| `onReactionTap` | `Function?` | null | Reaction chip tap callback |
| `onSwipeReply` | `Function?` | null | Swipe-to-reply callback |

---

## License

MIT
