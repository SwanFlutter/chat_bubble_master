library;

import 'package:flutter/material.dart';


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
export 'src/tools/bubble_type.dart';

/// The main chat bubble widget
class ChatBubbleMaster extends StatelessWidget {
  final CustomClipper? clipper;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backGroundColor;
  final Color? shadowColor;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final String? time;
  final bool isSent;
  final bool isRead;

  const ChatBubbleMaster({
    super.key,
    this.clipper,
    this.child,
    this.margin,
    this.elevation,
    this.backGroundColor,
    this.shadowColor,
    this.alignment,
    this.padding,
    this.time,
    this.isSent = false,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.topLeft,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: PhysicalShape(
        clipper: clipper! as CustomClipper<Path>,
        elevation: elevation ?? 2,
        color: backGroundColor ?? Colors.blue,
        shadowColor: shadowColor ?? Colors.grey.shade200,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              child ?? const SizedBox.shrink(),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (time != null)
                    Text(
                      time!,
                      style: TextStyle(
                        fontSize: 10,
                        color: (backGroundColor?.computeLuminance() ?? 0) > 0.5
                            ? Colors.black54
                            : Colors.white70,
                      ),
                    ),
                  if (isSent) ...[
                    const SizedBox(width: 4),
                    Icon(
                      isRead ? Icons.done_all : Icons.done,
                      size: 14,
                      color: isRead ? Colors.blue : Colors.grey,
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

