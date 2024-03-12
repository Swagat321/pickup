import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/loginPage.dart';
import 'package:pickup/widgets/game_card.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int selectedIndex = 0;

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
                  CircleAvatar(
                    // Placeholder for profile image
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'John Smith',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.settings), // Settings or profile icon
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
