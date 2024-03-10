import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/loginPage.dart';
import 'package:pickup/widgets/game_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

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
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
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
            Container(
              height: 100, // Adjust height accordingly
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7, // Number of days in the week
                itemBuilder: (context, index) {
                  // Placeholder for calendar strip days
                  return Card(
                    child: Container(
                      width: 50, // Adjust width accordingly
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'M', // Day abbreviation
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '13', // Date
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Number of GameCard widgets
                itemBuilder: (context, index) {
                  // Placeholder for GameCard widget
                  return GameCard(
                    location: 'Location',
                    time: 'Time',
                    players: 5,
                    rating: 4.5, // Keep for now to prevent null error.
                    message: 'Message',
                  );
                },
              ),
            ),
            // Placeholder for bottom section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Action to add a pickup game
                  },
                  child: Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () {
                    // Action to open group chat
                  },
                  child: Icon(Icons.chat),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}