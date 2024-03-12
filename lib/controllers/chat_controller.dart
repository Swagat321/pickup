import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void onInit() {
    super.onInit();
    chatService.listenToMessages('chatId'); // Replace 'chatId' with your actual chat ID
  }

  @override
  void onClose() {
    super.onClose();
    chatService.dispose();
  }
}
