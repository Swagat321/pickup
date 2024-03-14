import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:pickup/controllers/chat_controller.dart';
import 'package:pickup/models/user.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/chat_service.dart';
import 'package:intl/intl.dart';
import 'package:pickup/services/log.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.find<ChatController>();
  final String chatId;
  // 'zQF7i3lLj6Gk4KKSS322'; // Replace with your actual chatId
  final scrollController = ScrollController();
  final chatName;

  ChatScreen({
    Key? key,
    required this.chatId,
    required this.chatName,
    // required this.chatImg, TODO
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(chatId)), //TODO: Add more features like start PICKUP, etc.
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final messages =
                    chatController.chatService.messagesList[chatId] ?? [];
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  //required cuz maxScrollExtent val is not known till ListView builder finishes.
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent +
                          50, //+50 looks pretty cool and +0 doesn't scroll all the way on hard restart for some reason.
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });
                return ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    bool isSentByMe = message.userId == Get.find<AuthService>().user!.uid;
                        // 'wQ1UtQidPde8Vc2Dghml0ZpJEFE3'; // Integrate with rest of app.
                    final User user = chatController.getUser(message
                        .userId); // Assuming you have a getUser method in your ChatController
                    return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Dismissible(
                        key: Key(index.toString()), // Assuming your message object has an id field
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          Log.info('Time Dismissed');
                        },
                        background: Container(
                          color: Colors.blue, // Change this color as needed
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat.jm().format(message.time
                                  .toDate()), // Assuming your message object has a timestamp field
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (!isSentByMe) ...[
                              CircleAvatar(
                                backgroundImage: NetworkImage(user
                                    .avatarUrl), // Assuming your user object has an avatarUrl field
                              ),
                              const SizedBox(width: 8),
                              Text(user
                                  .userName), // Assuming your user object has a username field
                            ],
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color:
                                    isSentByMe ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(message
                                  .message), // Assuming your message object has a content field
                            ),
                            if (isSentByMe) ...[
                              const SizedBox(width: 8),
                              Text(user
                                  .userName), // Assuming your user object has a username field
                              CircleAvatar(
                                backgroundImage: NetworkImage(user
                                    .avatarUrl), // Assuming your user object has an avatarUrl field
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      chatController
                          .sendMessage(chatId); //Integrate with rest of app.
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 24,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
