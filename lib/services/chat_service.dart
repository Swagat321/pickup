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
  RxMap<String, List<Message>> messagesList = <String, List<Message>>{}.obs; // Observable messages list

  ChatService() {
    listenToMessages("wQ1UtQidPde8Vc2Dghml0ZpJEFE3");
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
  void listenToMessages(String userId) {
    try {
      // Fetch the user document from Firestore
      _firestore.collection('users').doc(userId).get().then((userDoc) {
        Log.info("ChatService listenToMessages() userDoc: ${userDoc.data()}");
        // Extract the list of chatIds from the user document
        List<String> chatIds = List<String>.from(userDoc.data()?['chatIds'] ?? []);
        Log.info("ChatService chatIds: $chatIds");

        // For each chatId...
        for (String chatId in chatIds) {
          // Listen for new messages in the chat
          _firestore.collection('chats').doc(chatId).collection('messages').orderBy('time', descending: true).snapshots().listen((snapshot) {
            Log.trace("Listening");
            // Convert the snapshot documents to Message objects
            List<Message> newMessages = snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList();
            //newMessages name may be confusing cuz it may not all be new messages, it's all messages in the chat.
            Log.info("newMessages: ${newMessages.map((messageObject) => messageObject.message).join(", ")}");
            // If this chatId is already in messagesList...
            if (messagesList[chatId] != null) {
              // Add the new messages to messagesList, but only if they're not already in the list
              //TODO: Maybe add a unique ID per message to use to check for duplicates and allow the same user to send the same message at the same exact time. But maybe an overkill and not needed.
              messagesList[chatId]!.addAll(newMessages.where((newMessage) => !messagesList[chatId]!.any((existingMessage) => existingMessage.time == newMessage.time && existingMessage.message == newMessage.message && existingMessage.userId == newMessage.userId)));
              Log.info("messagesList[chatId] already in the list. New messages Added: ${messagesList[chatId]?.map((messageObject) => messageObject.message).join(", ")}");
              messagesList.refresh(); // Trigger an update this way cuz internal changes don't register.
            } else {
              // If this chatId is not in messagesList, add the new messages to a new list for this chatId
              messagesList[chatId] = newMessages.reversed.toList(); 
              messagesList.refresh();// Should update because new key is added. 
              Log.info("messagesList[chatId] not in the list. All Messages Added: ${messagesList[chatId]?.map((messageObject) => messageObject.message).join(", ")}");            }
          }, onError: (e) {
  // Handle any errors that occur while listening for new messages
  Log.wtf("ChatService listenToMessages() error while listening for new messages: ", e);
  Get.snackbar("Error", "Failed to load potential new messages.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
});
        }
      });
    } catch (e) {
  // Handle any errors that occur while fetching the user document
  Log.wtf("ChatService listenToMessages() error while fetching user document: ", e);
  Get.snackbar("Error", "Failed to load group chats.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
}
  }

  void dispose() {
    _messageSubscription?.cancel(); // Cancel the subscription when the service is disposed
  }
}
