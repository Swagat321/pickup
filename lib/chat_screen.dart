

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:pickup/controllers/chat_controller.dart';
import 'package:pickup/services/chat_service.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.find<ChatController>();
  ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('iMessage')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: chatController.chatService.messagesList.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final message = chatController.chatService.messagesList[index];
                    bool isSentByMe = message.userId == 'wQ1UtQidPde8Vc2Dghml0ZpJEFE3'; // Integrate with rest of app.
                    return Align(
                      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isSentByMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(message.message),
                      ),
                    );
                  },
                ),
              ),
            ),
Container(
  padding: const EdgeInsets.all(8),
  color: Colors.white,
  child: Row(
    children: [
      Expanded(
        child: TextField(
          controller: chatController.messageController,
          decoration: InputDecoration(
            hintText: 'PickUp',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: () {
          chatController.sendMessage('zQF7i3lLj6Gk4KKSS322'); //Integrate with rest of app.
        },
        child: const CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 24,
          child: Icon(Icons.send, color: Colors.white),
        ),
      ),
    ],
  ),
)
,
          ],
        ),
      ),
    );
  }
}