import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/models/message.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/log.dart';

class ChatService extends GetxService {
  StreamSubscription? _messageSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Message> messagesList = <Message>[].obs; // Observable messages list

  void init(String chatId) {
    listenToMessages(chatId);
  }

  // Method to create a new chat and return the generated chatId
  Future<String> createChat(List<String> userIds, String groupChatName) async {
    final chatDocumentRef = await _firestore.collection('chats').add({
      'users': userIds,
      'groupChatName': groupChatName,
      'createdAt': Timestamp.now(),
    });
    return chatDocumentRef.id; // Firestore auto-generated ID for the chat document
  }

  // Method to send a message to a chat
  Future<void> sendMessage(String messageText, String chatId) async {
    final timestamp = Timestamp.now(); // Use Firestore Timestamp
    final Message message;
    // Create a message object
    try {
      message = Message(
      message: messageText,
      userId: Get.find<AuthService>().user!.uid, 
      chatId: chatId,
      time: timestamp,
    );
      await _firestore.collection('chats').doc(chatId).collection('messages').add(message.toJson());
      // send the message to the users as well.
      // Optionally, update the last message and timestamp in the chat document
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': messageText,
        'lastMessageTime': timestamp,
      });
    } catch (e) {
      // Handle any errors here
      Log.wtf("ChatService sendMessage() fail: ", e);
      Get.snackbar("Error", "Failed to send message.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Method to listen for new messages in a chat
  void listenToMessages(String chatId) {
    try{
      _messageSubscription?.cancel(); // Cancel the previous subscription if one exists

      _messageSubscription = _firestore.collection('chats').doc(chatId).collection('messages').orderBy('time', descending: true).snapshots().listen((snapshot) {
      Log.info("ChatService .listen() snapshot: ${snapshot.docs}");
      messagesList.value = snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList(); 
      //Listen to an update messagesList
    }, onError: (e) {
      Log.wtf("ChatService .listen() error: ", e);
      Get.snackbar(
        "Error",
        "Failed to receive a message.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    );
    } catch (e) {
      Log.wtf("ChatService listenToMessages() fail: ", e);
    }
  }

  void dispose() {
    _messageSubscription?.cancel(); // Cancel the subscription when the service is disposed
  }
}
