import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/loginPage.dart';
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
                itemCount: 3, // Number of GameCard widgets
                itemBuilder: (context, index) {
                  // Placeholder for GameCard widget
                  return GameCard(
                    location: 'Location',
                    time: _selectedDay,
                    players: 5,
                    rating: 3.3, // Keep for now to prevent null error.
                    message: 'Message',
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
