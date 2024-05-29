import 'dart:io';

import 'package:flutter/material.dart';
import 'package:namer_app/components/chat_bubble.dart';
import 'package:namer_app/components/my_text_field.dart';
import 'package:namer_app/model/message.dart';
import 'package:namer_app/services/chat/chat_service.dart';
import 'package:namer_app/services/file_service.dart' as file_service;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  File? _selectedFile;

  void sendMessage() async {
  if (_messageController.text.isNotEmpty || _selectedFile != null) {
    String? message = _messageController.text.trim();
    String? fileUrl;
    String? fileType;
    bool isFile = false;

    if (_selectedFile != null) {
      final path = 'uploads/${DateTime.now().millisecondsSinceEpoch}_${_selectedFile!.path.split('/').last}';
      fileUrl = await _chatService.uploadFile(_selectedFile!, path);
      
      // Determine file type based on file extension
      if (_selectedFile!.path.toLowerCase().endsWith('.jpg') || _selectedFile!.path.toLowerCase().endsWith('.jpeg')) {
        fileType = 'image';
      } else {
        fileType = 'file';
      }
      
      isFile = true;
      message = fileUrl ?? ''; //Fd Set the message to the file URL if available, otherwise use an empty string
    }

    Message newMessage = Message(
      senderID: _firebaseAuth.currentUser!.uid,
      senderEmail: _firebaseAuth.currentUser!.email!,
      receiverId: widget.receiverUserID,
      message: message,
      timestamp: Timestamp.now(),
      fileUrl: fileUrl,
      fileType: fileType,
      isFile: isFile,
    );

    await _chatService.sendMessage(
      widget.receiverUserID,
      newMessage.encryptMessage(),
      fileUrl: fileUrl,
      fileType: fileType,
    );

    _messageController.clear();
    setState(() {
      _selectedFile = null;
    });

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

  void _pickImage() async {
    final file = await file_service.FileService().pickImage();
    if (file != null) {
      setState(() {
        _selectedFile = file;
      });
    }
  }

  void _pickFile() async {
    final file = await file_service.FileService().pickFile();
    if (file != null) {
      setState(() {
        _selectedFile = file;
      });
    }
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
          if (_selectedFile != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              child: _selectedFile!.path.endsWith('.jpg') || _selectedFile!.path.endsWith('.png') || _selectedFile!.path.endsWith('.jpeg')
                  ? Image.file(_selectedFile!)
                  : Text(_selectedFile!.path.split('/').last),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

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

  Widget _buildMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  bool isCurrentUser = data['senderID'] == _firebaseAuth.currentUser!.uid;

  var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

  bool isFile = data['isFile'] ?? false;

  String decryptedMessage = Message(
    senderID: data['senderID'],
    senderEmail: data['senderEmail'],
    receiverId: data['receiverID'],
    message: data['message'],
    timestamp: data['timestamp'],
    fileUrl: data['fileUrl'],
    fileType: data['fileType'],
    isFile: isFile,
  ).decrypt();

  print('Decrypted Message: $decryptedMessage'); // Debug print

  return Container(
    alignment: alignment,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(data['senderEmail']),
          const SizedBox(height: 5),
          if (isFile && data['fileType'] == 'image' && data['fileUrl'] != null)
            Image.network(
              data['fileUrl']!,
              width: 200, 
              height: 200, 
              fit: BoxFit.cover, 
            )
          else if (isFile && data['fileType'] == 'file' && data['fileUrl'] != null)
            GestureDetector(
              onTap: () {
                // Handle file download/open
              },
              child: Text(
                "File: ${data['fileUrl']!.split('/').last}",
                style: TextStyle(color: Colors.blue),
              ),
            )
          else if (!isFile)
            ChatBubble(
              message: decryptedMessage,
              isCurrentUser: isCurrentUser,
              fileType: data['fileType'],
              imageUrl: data['fileUrl'],
            ),
        ],
      ),
    ),
  );
}


  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _pickFile,
          ),
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Mesaj yazınız.',
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward, size: 40),
          ),
        ],
      ),
    );
  }
}
