import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'package:pointycastle/pointycastle.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  // Encrypt the message using AES encryption
  String encrypt() {
    final key = Key.fromUtf8("1245714587458888"); 
    final iv = IV.fromUtf8("e16ce888a20dadb8"); 

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc,padding: "PKCS7"));

    final encryptedMessage = encrypter.encrypt(message, iv: iv);

    return encryptedMessage.base64;
  }

  // Decrypt the message using AES decryption
  String decrypt() {
    try {
      final key = Key.fromUtf8("1245714587458888"); 
      final iv = IV.fromUtf8("e16ce888a20dadb8"); 

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc,padding: "PKCS7"));

      Encrypted enBase64 = Encrypted.from64(message);
      final decrypted = encrypter.decrypt(enBase64, iv: iv);
      return decrypted;
    } catch (e) {
      print('Error decrypting message: $e');
      return 'Error decrypting message';
    }
  }
}
