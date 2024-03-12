import "package:flutter/material.dart";
import "package:pickup/create_game_page.dart";
import "package:pickup/gamePage.dart";
import "package:pickup/game_info_page.dart";
import "package:pickup/group_chat_page.dart";
import "package:pickup/widgets/bottom_nav_bar.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget currBody = GamePage();
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
                  currBody = GameInfoPage();
                  break;
                case 1:
                  currBody = GamePage();
                  break;
                case 2:
                  currBody = GroupChatPage();
                  break;
              }
            });
          },
        ));
  }
}