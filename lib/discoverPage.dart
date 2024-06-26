import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickup/controllers/chat_controller.dart';
import 'package:pickup/create_game.dart';
import 'package:pickup/models/game.dart';
import 'package:pickup/models/user.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/chat_service.dart';
import 'package:pickup/services/game_service.dart';
import 'package:pickup/services/log.dart';
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
  final gameService = Get.find<GameService>();
  var _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<Game> games = [];
  // String name;

  //   @override
  //   void initState() {
  //     super.initState();
  //     name = await (widget.gameService.getCurrentUser()).userName;
  //   }

  // Rest of your code
  // }
//   List<Game> getSampleGames() {
//   Timestamp now = Timestamp.fromDate(DateTime.now());

//   return [
//     Game(
//       chatId: 'chat1',
//       date: now,
//       time: now,
//       location: 'Mills Park',
//       maxPlayers: 22,
//       minRating: 3.5,
//       announcement: 'Friendly match this weekend. Join us for fun and exercise!',
//       reqPermission: false,
//       gamePic: 'https://via.placeholder.com/150',
//       avgRanking: 4.0,
//       currNumPlayers: 10,
//     ),
//     Game(
//       chatId: 'chat2',
//       date: now,
//       time: Timestamp.fromDate(DateTime.now().add(const Duration(hours: 10, minutes: 24))),
//       location: 'Apex Nature Park',
//       maxPlayers: 22,
//       minRating: 4.0,
//       announcement: 'Looking for experienced players to join our team.',
//       reqPermission: true,
//       gamePic: 'https://via.placeholder.com/200',
//       avgRanking: 4.5,
//       currNumPlayers: 22,
//     ),
//     // Add more Game objects here if needed
//   ];
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            Dialog(
              child: CreateGame(date: _selectedDay),
            ),
            barrierDismissible: true,
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add_sharp,
          size: 55,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    // Placeholder for profile image
                    backgroundImage: NetworkImage('https://i.pravatar.cc/200'),
                  ),
                  const SizedBox(width: 8),
                  FutureBuilder<User>(
                    future: _authService.getUser(_authService.user
                        ?.uid), //Use the name of our user model because they could have changed it within app scope.
                    builder:
                        (BuildContext context, AsyncSnapshot<User> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading...");
                      } else if (snapshot.hasError) {
                        return const Text('Loading...');
                      } else {
                        return Text(
                          snapshot.data?.userName ?? 'Anonymous',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.settings),
                    onSelected: (String result) async {
                      switch (result) {
                        case 'Logout':
                          await _authService
                              .signOut(); //Very important to await being signed out.
                          Get.offAll(() =>
                              const AuthCheck()); //Removes all previous and current routes to go back to AuthCheck which should redirect to LoginPage.
                          break;
                        case 'Change UserName': //TODO: Implement change username
                          // Handle username change
                          break;
                        case 'Change Picture': //TODO: Implement change picture
                          // Handle picture change
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
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
            WeeklyDatePicker(
              //TODO: Improve design and add return to now button.
              enableWeeknumberText: false,
              selectedDay: _selectedDay, // DateTime
              changeDay: (value) {
                setState(() {
                  _selectedDay = value;
                  Log.info(_selectedDay);
                });
                // try {
                //   Get.find<GameService>()
                //       .getGames(_selectedDay)
                //       .then((newGames) {
                //     Log.info("Games for $_selectedDay: $newGames");
                //     setState(() {
                //       games = newGames;
                //     });
                //   });
                // } catch (e) {
                //   Log.error(
                //       "Failed to fetch games 1st time for $_selectedDay trying again...",
                //       e);
                //   Get.snackbar("Failed to Fetch Games", "Please quit the app and open again.");
                // }
              },
            ),
            Expanded(
              child: FutureBuilder<List<Game>>(
                future: gameService.getGames(
                    _selectedDay), // Replace with your Future<List<Game>>
                builder:
                    (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // or some other widget while waiting
                  } else if (snapshot.hasError) {
                    Log.error('Failed to fetch games:',
                        snapshot.error ?? "No error message");
                    return const Text(
                        "Couldn't fetch games at this time. Please refresh.");
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final game = snapshot.data![index];
                        // Replace with your game card widget
                        return GameCard(
                          game: game,
                          user: _authService.myUser!, //TODO: Make null safe.
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
