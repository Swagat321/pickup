import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:pickup/models/game.dart';
import 'package:pickup/models/user.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/log.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find();
  
  Future<String> getChatName(Game game) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('chats').doc(game.chatId).get();
      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['chatName'] as String? ?? 'New Chat';
      } else {
        throw Exception('Chat document does not exist');
      }
    } catch (e) {
      throw Exception('Failed to get chat name: $e');
    }
  }

  Future<User> getCurrentUser() async { //Make sure this and other service are only init or Get.put() after AuthCheck passes. 
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_authService.user!.uid).get();
      if (userDoc.exists) {
        return User.fromJson(userDoc.data() as Map<String, dynamic>); //Make sure types are castable.
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  Future<List<Game>> getGames(DateTime date) async {
    try{
    QuerySnapshot snapshot = await _firestore
        .collection('games')
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .get();
    Log.info("Games: ${snapshot.docs}");
    Log.info("mapped Games: ${snapshot.docs.map((doc) => Game.fromJson(doc.data() as Map<String, dynamic>)).toList()}");
    return snapshot.docs.map((doc) => Game.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      Log.error("GameService getGames() error: ", e);
      throw Exception('Failed to load games: $e');
    }
  }

  Future<void> joinGame(Game game) async { //TODO: Will have to fix this.
    String userId = _authService.user!.uid;

    return _firestore
        .collection('chats')
        .doc(game.chatId)
        .update({
          'users': FieldValue.arrayUnion([userId]),
        });
  }

  Future<void> leaveGame(Game game) async { //TODO: Will have to fix this.
    String userId = _authService.user!.uid;

    return _firestore
        .collection('chats')
        .doc(game.chatId)
        .update({
          'users': FieldValue.arrayRemove([userId]),
        });
  }

Future<DocumentReference<Map<String, dynamic>>> createGame(Map<String, dynamic> json) async {
  if (_authService.myUser == null) {
    throw Exception('User not signed in'); // Or handle this scenario appropriately
  }

  String userId = _authService.myUser!.id;
  String userName = _authService.myUser!.userName;
  double? userRanking = _authService.myUser!.ranking;

  // Extract just the date component from the JSON field "date".
  DateTime selectedDate = json['date'];
  // Extract just the date component
  DateTime dateOnly = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  // Convert to Timestamp
  Timestamp dateTimestamp = Timestamp.fromDate(dateOnly);
  //Put it back into json["date"]
  json['date'] = dateTimestamp;

  //Combine both for time:
  DateTime selectedTime = json['time'];
  DateTime combinedDateTime = DateTime(
  selectedDate.year,
  selectedDate.month,
  selectedDate.day,
  selectedTime.hour,
  selectedTime.minute,
);
  Timestamp timeTimestamp = Timestamp.fromDate(combinedDateTime);
  json['time'] = timeTimestamp;

  WriteBatch batch = _firestore.batch();

  DocumentReference chatRef = _firestore.collection('chats').doc();

  // Assume json already contains necessary fields for a game
  Map<String, dynamic> gameData = {
    'chatId': chatRef.id,
    'avgRanking': userRanking,
    'currNumPlayers': 1,
    'chatName': userName,
    // Add other fields...
    ...json,
  };

  DocumentReference gameRef = _firestore.collection('games').doc();

  batch.set(gameRef, gameData);

  batch.update(_firestore.collection('users').doc(userId), {
    'chatIds': FieldValue.arrayUnion([chatRef.id])
  });

  Map<String, dynamic> chatData = {
    'userIds': [userId],
    'avgRanking': userRanking,
    'chatName': userName,
    'gamePic': json["gamePic"], // Assuming json["gamePic"] is valid
    "latestMessage": "Welcome to the chat!",
    "latestMessageTime": Timestamp.now(),
  };

  batch.set(chatRef, chatData);

  try {
    await batch.commit();
    return gameRef as DocumentReference<Map<String, dynamic>>; // Return the DocumentReference of the created game
  } catch (e) {
    Log.error('Failed to create game and chat:', e);
    throw Exception('Failed to create game and chat: $e'); // Handle or propagate the exception
  }
}

}
  // String chatId; *****
  // Timestamp? date;
  // Timestamp? time;
  // String? location;
  // int maxPlayers;
  // double? minRating;
  // String? announcement;
  // bool reqPermission;
  // String? gamePic;
  // double? avgRanking; ***
  // int currNumPlayers; ***
  // String chatName; ***