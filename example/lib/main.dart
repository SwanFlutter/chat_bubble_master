import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatExampleScreen(),
    ),
  );
}

class ChatExampleScreen extends StatefulWidget {
  const ChatExampleScreen({super.key});

  @override
  State<ChatExampleScreen> createState() => _ChatExampleScreenState();
}

class _ChatExampleScreenState extends State<ChatExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
