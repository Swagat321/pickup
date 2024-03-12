import 'package:flutter/material.dart';
import 'package:pickup/widgets/group_chat_display.dart';

class GroupChatPage extends StatefulWidget {
  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chats'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active'),
            Tab(text: 'Inactive'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active chats list
          ListView(
            children: List.generate(
              3,
              (index) => GroupChatDisplay(
                title: 'GroupChat $index',
                imageUrl: 'https://via.placeholder.com/150',
                latestMessage: 'Person$index said smth',
              ),
            ),
          ),
          // Inactive chats list
          ListView(
            children: List.generate(
              3,
              (index) => GroupChatDisplay(
                title: 'GroupChat ${index + 3}',
                imageUrl: 'https://via.placeholder.com/150',
                latestMessage: 'Person${index + 3} said smth',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
