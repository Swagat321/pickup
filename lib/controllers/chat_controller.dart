import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/models/user.dart';
import 'package:pickup/services/chat_service.dart';

class ChatController extends GetxController {
  final ChatService chatService = Get.find<ChatService>();
  final TextEditingController messageController = TextEditingController();

  void sendMessage(String chatId) {
    if (messageController.text.trim().isNotEmpty) {
      chatService.sendMessage(messageController.text.trim(), chatId);
      messageController.clear();
    }
  }

  getUser(String userId) {
    // return chatService.getUser(userId);
    // return User(
    //   avatarUrl: "https://via.placeholder.com/150",
    //   userName: "Anonymous",
    //   id: "wQ1UtQidPde8Vc2Dghml0ZpJEFE3",        
    //   phoneNumber:
    // )
    return User(
  id: 'wQ1UtQidPde8Vc2Dghml0ZpJEFE3',
  userName: 'testUserName',
  email: 'testEmail@example.com',
  phoneNumber: '1234567890',
  ranking: 4.5,
  avatarUrl: 'https://example.com/avatar.jpg',
  location: 'testLocation',
  chatIds: ['chatId1', 'chatId2'],
);
  }

  @override
  void onClose() {
    super.onClose();
    chatService.dispose();
  }




}
