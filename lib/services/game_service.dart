import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:pickup/chat_screen.dart';
import 'package:pickup/discoverPage.dart';
import 'package:pickup/models/chat.dart';
import 'package:pickup/models/game.dart';
import 'package:pickup/models/user.dart';
import 'package:pickup/services/auth_service.dart';
import 'package:pickup/services/log.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find();

  Future<String> getChatName(Game game) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('chats').doc(game.chatId).get();
      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['chatName'] as String? ??
            'New Chat';
      } else {
        throw Exception('Chat document does not exist');
      }
    } catch (e) {
      throw Exception('Failed to get chat name: $e');
    }
  }

  Future<User> getCurrentUser() async {
    //Make sure this and other service are only init or Get.put() after AuthCheck passes.
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_authService.user!.uid)
          .get();
      if (userDoc.exists) {
        return User.fromJson(userDoc.data()
            as Map<String, dynamic>); //Make sure types are castable.
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  Future<List<Game>> getGames(DateTime date) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('games')
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .get();
      Log.info("Games: ${snapshot.docs}");
      Log.info(
          "mapped Games: ${snapshot.docs.map((doc) => Game.fromJson(doc.data() as Map<String, dynamic>)).toList()}");
      return snapshot.docs
          .map((doc) => Game.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Log.error("GameService getGames() error: ", e);
      throw Exception('Failed to load games: $e');
    }
  }

Future<void> joinGame(Game game, User user) async {
  try {
    WriteBatch batch = _firestore.batch();

    DocumentReference userRef = _firestore.collection('users').doc(user.id);
    DocumentReference chatRef = _firestore.collection('chats').doc(game.chatId);
    DocumentReference gameRef = _firestore.collection('games').doc(game.chatId);

    batch.update(userRef, {
      'chatIds': FieldValue.arrayUnion([game.chatId]),
    });

    // Get the current chat document
    DocumentSnapshot chatSnapshot = await chatRef.get();
    if (!chatSnapshot.exists) throw Exception("Chat does not exist.");
    Map<String, dynamic>? chatData = chatSnapshot.data() as Map<String, dynamic>?;
    if (chatData == null) throw Exception("Chat data is null.");

    Chat chat = Chat.fromJson(chatData, game.chatId);
    if (user.ranking == null) throw Exception("User ranking is null.");

    // Get the current chatName and append the new user's name
String oldChatName = chat.chatName ?? "";
String newChatName = "$oldChatName, ${user.userName}";

    batch.update(chatRef, {
      'userIds': FieldValue.arrayUnion([user.id]),
      'chatName': newChatName,
    });
    
    double newAvgRanking = (((chat.avgRanking ?? 0) * (chat.userIds.length)) + (user.ranking ?? 0)) / ((chat.userIds.length) + 1);

    batch.update(chatRef, {
      'avgRanking': newAvgRanking,
    });

    batch.update(gameRef, {
      'avgRanking': newAvgRanking,
      'currNumPlayers': FieldValue.increment(1),
      'chatName': newChatName,
    });

    await batch.commit();

    Get.to(() => ChatScreen(chatId: game.chatId, chatName: game.chatName));
    Get.snackbar(
      "Joined",
      "You may now chat with your teammates.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  } catch (e) {
    // Handle errors appropriately
    Log.error("Error joining game: ", e);
    Get.snackbar(
      "Error",
      "Failed to join the game.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}


  Future<void> leaveGame(Game game) async {
    //TODO: Will have to fix this.
    String userId = _authService.user!.uid;

    return _firestore.collection('chats').doc(game.chatId).update({
      'users': FieldValue.arrayRemove([userId]),
    });
  }

  Future<DocumentReference<Map<String, dynamic>>> createGame(
      Map<String, dynamic> json) async {
    if (_authService.myUser == null) {
      throw Exception(
          'User not signed in'); // Or handle this scenario appropriately
    }

    String userId = _authService.myUser!.id;
    String userName = _authService.myUser!.userName;
    double? userRanking = _authService.myUser!.ranking;

    // Extract just the date component from the JSON field "date".
    DateTime selectedDate = json['date'];
    // Extract just the date component
    DateTime dateOnly =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
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
      'chatId': chatRef.id, //chatId will be the same for game doc and chat doc.
      'avgRanking': userRanking,
      'currNumPlayers': 1,
      'chatName': userName,
      // Add other fields...
      ...json,
    };

    DocumentReference gameRef = _firestore.collection('games').doc(chatRef.id); //Ensures the game has the same id as chatId.

    batch.set(gameRef, gameData);

    batch.update(_firestore.collection('users').doc(userId), {
      'chatIds': FieldValue.arrayUnion([chatRef.id])
    });

    Map<String, dynamic> chatData = {
      'userIds': [userId],
      'avgRanking': userRanking,
      'chatName': userName,
      'gamePic': json["gamePic"],
      "lastMessage": "Welcome to the chat!",
      "lastMessageTime": Timestamp.now(),
    };

    batch.set(chatRef, chatData);

    try {
      await batch.commit();
      Log.info('Game created successfully');
      Get.snackbar(
        "Success!",
        "Your PickUP time has been posted.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
      // Get.to(() => const DiscoverPage());
      return gameRef as DocumentReference<
          Map<String,
              dynamic>>; // Return the DocumentReference of the created game
    } catch (e) {
      Log.error('Failed to create game and chat:', e);
      throw Exception(
          'Failed to create game and chat: $e'); // Handle or propagate the exception
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
