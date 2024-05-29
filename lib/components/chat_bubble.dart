import 'dart:math';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String? imageUrl; 
  final String? fileType;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.imageUrl,
    this.fileType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (fileType == 'image' && imageUrl != null)
            Image.network(
              imageUrl!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            )
          else if (fileType == 'file' && message.isNotEmpty)
            Row(
              children: [
                Icon(Icons.attach_file),
                SizedBox(width: 8),
                Text(
                  'File: ${message.split('/').last}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: isCurrentUser ? TextAlign.end : TextAlign.start,
                ),
              ],
            )
          else
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: isCurrentUser ? TextAlign.end : TextAlign.start,
            ),
        ],
      ),
    );
  }
}
