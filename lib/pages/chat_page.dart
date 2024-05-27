import "dart:typed_data";
import 'dart:io';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:namer_app/components/chat_bubble.dart";
import "package:namer_app/components/my_text_field.dart";
import "package:namer_app/model/message.dart";
import "package:namer_app/services/chat/chat_service.dart";

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Encrypt the message before sending
      String encryptedMessage = Message(
        senderID: _firebaseAuth.currentUser!.uid,
        senderEmail: _firebaseAuth.currentUser!.email!,
        receiverId: widget.receiverUserID,
        message: _messageController.text,
        timestamp: Timestamp.now(),
      ).encrypt();

      await _chatService.sendMessage(widget.receiverUserID, encryptedMessage);
      _messageController.clear();

       _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
        
        ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  // Message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _firebaseAuth.currentUser!.uid;

    var alignment = (data['senderID'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    //print('Encrypted message: ${data['message']}');
    // Decrypt the message before displaying
    String decryptedMessage = Message(
      senderID: 'placeholder_sender_id',
      senderEmail: 'placeholder_sender_email',
      receiverId: 'placeholder_receiver_id',
      message: data['message'], // Pass the encrypted message here
      timestamp: Timestamp.now(), // Pass any timestamp you prefer
    ).decrypt();

    //print('Decrypted message length: ${decryptedMessage.length}');
    //print('Decrypted message content: $decryptedMessage');

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderID'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderID'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5),
            ChatBubble(message: decryptedMessage, isCurrentUser: isCurrentUser)
          ],
        ),
      ),
    );
  }
 
  // Message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Mesaj yazınız.',
              obscureText: false,
            ),
          ),
          IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward, size: 40))
        ],
      ),
    );
  }
}
