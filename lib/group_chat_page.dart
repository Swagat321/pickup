import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:pickup/chat_screen.dart';
import 'package:pickup/models/chat.dart';
import 'package:pickup/widgets/group_chat_display.dart';
import 'package:pickup/services/chat_service.dart'; // Import your ChatService

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({super.key});

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ChatService _chatService = Get.find(); // Use the same initialization.

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chats'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Inactive'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active chats list
          FutureBuilder(
            future: _chatService.getActiveChats(), // Fetch active chats from your ChatService
            builder: (context, AsyncSnapshot<List<Chat>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var chats = snapshot.data;
                return ListView.builder(
                  itemCount: chats?.length ?? 0,
                  itemBuilder: (context, index) {
                    return GroupChatDisplay(
                      imageUrl: chats![index].gamePic,
                      title: chats[index].chatName,
                      latestMsg: chats[index].lastMessage,
                      latestMsgTime: chats[index].lastMessageTime,
                      ranking: chats[index].avgRanking?? 0.0,
                      onTap: () {
                        Get.to(() => ChatScreen(
                              chatId: chats[index].chatId,
                              chatName: chats[index].chatName,
                            )
                    );
                  },
                );
              });
            }
  }),
          // Inactive chats list
          FutureBuilder(
            future: _chatService.getInactiveChats(), // Fetch inactive chats from your ChatService
            builder: (context, AsyncSnapshot<List<Chat>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var chats = snapshot.data;
                return ListView.builder(
                  itemCount: chats?.length ?? 0,
                  itemBuilder: (context, index) {
                    return GroupChatDisplay(
                      imageUrl: chats![index].gamePic,
                      title: chats[index].chatName,
                      latestMsg: chats[index].lastMessage,
                      latestMsgTime: chats[index].lastMessageTime,
                      ranking: chats[index].avgRanking?? 0.0,
                      onTap: () {
                        Get.to(() => ChatScreen(
                              chatId: chats[index].chatId,
                              chatName: chats[index].chatName,
                            )
                    );
                  },
                );
              });
            }},
          ),
        ],
      ),
    );
  }
}