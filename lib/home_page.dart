import "package:flutter/material.dart";
import 'package:pickup/discoverPage.dart';
import "package:pickup/game_info_page.dart";
import "package:pickup/group_chat_page.dart";
import "package:pickup/widgets/bottom_nav_bar.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget currBody = const DiscoverPage();
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currBody,
        bottomNavigationBar: BottomNavBar(
          index: _index,
          onChange: (index) {
            setState(() {
              _index = index;
              switch (index) {
                case 0:
                  currBody = const GameInfoPage();
                  break;
                case 1:
                  currBody = const DiscoverPage();
                  break;
                case 2:
                  currBody = const GroupChatPage();
                  break;
              }
            });
          },
        ));
  }
}