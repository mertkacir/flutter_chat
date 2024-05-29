import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/pointycastle.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String? fileUrl;
  final String? fileType;
  final bool isFile;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.fileUrl,
    this.fileType,
    this.isFile = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverId,
      'message': message,
      'timestamp': timestamp,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'isFile': isFile,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderID: map['senderID'],
      senderEmail: map['senderEmail'],
      receiverId: map['receiverID'],
      message: map['message'],
      timestamp: map['timestamp'],
      fileUrl: map['fileUrl'],
      fileType: map['fileType'],
      isFile: map['isFile'] ?? false,
    );
  }

  // Encrypt the message using AES encryption
  // Encrypt the message using AES encryption
String encryptMessage() {
  if (isFile || message.isEmpty) return message; // Skip encryption for file URLs and empty messages

  final key = Key.fromUtf8("1245714587458888");
  final iv = IV.fromUtf8("e16ce888a20dadb8");

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));

  final encryptedMessage = encrypter.encrypt(message, iv: iv);

  return encryptedMessage.base64;
}

// Decrypt the message using AES decryption
String decrypt() {
  if (!isFile && message.isNotEmpty) { // Check if it's not a file and the message is not empty
    try {
      final key = Key.fromUtf8("1245714587458888");
      final iv = IV.fromUtf8("e16ce888a20dadb8");

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));

      Encrypted enBase64 = Encrypted.from64(message);
      final decrypted = encrypter.decrypt(enBase64, iv: iv);
      return decrypted;
    } catch (e) {
      // If decryption fails, assume the message is not encrypted and return it as is
      return message;
    }
  } else {
    return message; // Return the original message if it's not encrypted or empty
  }
}
}
