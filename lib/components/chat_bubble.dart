import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Split the message into chunks of 50 characters
    List<String> messageChunks = [];
    for (int i = 0; i < message.length; i += 50) {
      messageChunks.add(message.substring(i, min(i + 50, message.length)));
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7, // Maximum width is 70% of screen width
      ),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: messageChunks.map((chunk) {
          return Text(
            chunk,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            textAlign: isCurrentUser ? TextAlign.end : TextAlign.start,
          );
        }).toList(),
      ),
    );
  }
}
