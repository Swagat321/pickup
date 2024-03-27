import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:pickup/contacts_page.dart";
import 'package:pickup/discoverPage.dart';
import "package:pickup/create_game.dart";
import "package:pickup/group_chat_page.dart";
import "package:pickup/services/log.dart";
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
              try{
              _index = index;
              switch (index) {
                case 0:
                  currBody = const ContactsPage();
                  break;
                case 1:
                  currBody = const DiscoverPage();
                  break;
                case 2:
                  currBody = const GroupChatPage();
                  break;
              }
              } catch (e) {
              Get.snackbar("Known error. Working on it.", "Please quit the app and open again."); //TODO: Really Need to Figure this out!!!
              Log.error("Probably GameService error: ",e);
              }
            });
          },
        ));
  }
}