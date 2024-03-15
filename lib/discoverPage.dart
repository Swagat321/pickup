import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/models/game.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/widgets/auth_check.dart';
import 'package:pickup/widgets/game_card.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  int selectedIndex = 0;
  final _authService = Get.find<AuthService>();
  var _selectedDay = DateTime.now();

  List<Game> getSampleGames() {
  Timestamp now = Timestamp.fromDate(DateTime.now());

  return [
    Game(
      chatId: 'chat1',
      date: now,
      time: now,
      location: 'Central Park',
      maxPlayers: 22,
      minRating: 3.5,
      announcement: 'Friendly match this weekend. Join us for fun and exercise!',
      reqPermission: false,
      gamePic: 'https://via.placeholder.com/150',
      avgRanking: 4.0,
      currNumPlayers: 10,
    ),
    Game(
      chatId: 'chat2',
      date: now,
      time: now,
      location: 'Madison Square',
      maxPlayers: 22,
      minRating: 4.0,
      announcement: 'Looking for experienced players to join our team.',
      reqPermission: true,
      gamePic: 'https://via.placeholder.com/200',
      avgRanking: 4.5,
      currNumPlayers: 22,
    ),
    // Add more Game objects here if needed
  ];
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    // Placeholder for profile image
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _authService.user?.displayName ?? 'Anonymous',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.settings),
                    onSelected: (String result) {
                      switch (result) {
                        case 'Logout':
                          _authService.signOut();
                          Get.offAll(() => AuthCheck()); //Removes all previous and current routes to go back to AuthCheck which should redirect to LoginPage.
                          break;
                        case 'Change UserName': //TODO: Implement change username
                          // Handle username change
                          break;
                        case 'Change Picture': //TODO: Implement change picture
                          // Handle picture change
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Logout',
                        child: Text('Logout'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Change UserName',
                        child: Text('Change UserName'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Change Picture',
                        child: Text('Change Picture'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            WeeklyDatePicker( //TODO: Improve design and add return to now button.
              enableWeeknumberText: false,
              selectedDay: _selectedDay, // DateTime
              changeDay: (value) => setState(() {
                _selectedDay = value;
              }),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2, // Number of GameCard widgets
                itemBuilder: (context, index) {
                  // Placeholder for GameCard widget
                  return GameCard(
                    game: getSampleGames()[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
