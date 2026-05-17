import 'package:flutter/material.dart';

/// Displays a circular avatar for the message sender.
/// Falls back to initials if no image URL is provided.
class BubbleAvatar extends StatelessWidget {
  /// URL or asset path for the avatar image.
  final String? avatarUrl;

  /// Sender name used to generate initials fallback.
  final String? senderName;

  /// Diameter of the avatar circle.
  final double size;

  /// Background color for the initials fallback.
  final Color? backgroundColor;

  const BubbleAvatar({
    super.key,
    this.avatarUrl,
    this.senderName,
    this.size = 32,
    this.backgroundColor,
  });

  String get _initials {
    if (senderName == null || senderName!.isEmpty) return '?';
    final parts = senderName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Color get _bgColor {
    if (backgroundColor != null) return backgroundColor!;
    // Generate a consistent color from the name
    if (senderName == null) return Colors.grey;
    final colors = [
      Colors.teal,
      Colors.indigo,
      Colors.deepOrange,
      Colors.purple,
      Colors.green,
      Colors.blue,
      Colors.pink,
    ];
    final index = senderName.hashCode.abs() % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: _bgColor,
        backgroundImage:
            avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null
            ? Text(
                _initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.38,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}
