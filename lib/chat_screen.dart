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
import 'package:pickup/widgets/msg.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String chatName;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.chatName,
    // required this.chatImg, TODO
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final ChatController chatController = Get.find<ChatController>();
  // 'zQF7i3lLj6Gk4KKSS322'; // Replace with your actual chatId
  final scrollController = ScrollController();
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 250), // Set a duration for the animation
    );
  }

  @override
  void dispose() {
    animationController
        .dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    animationController
        .stop(); // Stop any ongoing animation when a new drag starts
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // Update the animation value based on the drag distance
    final double dragDistance = details.primaryDelta! /
        100.0; // Adjust the divisor to control the sensitivity
    animationController.value -= dragDistance;
  }

  void _handleDragEnd(DragEndDetails details) {
    // Animate the controller to the end when the drag ends
    animationController.animateTo(-1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget
              .chatName)), //TODO: Add more features like start PICKUP, etc.
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final messages =
                    chatController.chatService.messagesList[widget.chatId] ??
                        [];
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
                    Log.trace("Message: $message");
                    bool isSentByMe =
                        message.userId == Get.find<AuthService>().myUser!.id;
                    // 'wQ1UtQidPde8Vc2Dghml0ZpJEFE3'; // Integrate with rest of app.
                    // final User user = chatController.getUser(message //Just include username in message object.
                    //     .userId); // Assuming you have a getUser method in your ChatController
                    return GestureDetector(
                      onHorizontalDragStart: _handleDragStart,
                      onHorizontalDragUpdate: _handleDragUpdate,
                      onHorizontalDragEnd: _handleDragEnd,
                      child: Msg(
                        content: message.message,
                        time: message.time,
                        userName: message.userName ?? "Anonymous",
                        avatarUrl: "https://i.pravatar.cc/200", //TODO: Change placeholder or remove avatars or smth later?
                        isSentByMe: isSentByMe,
                        animation: animationController.view,
                      ),
                    );
                  },
                );
              } 
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      chatController.sendMessage(
                          widget.chatId); //Integrate with rest of app.
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
