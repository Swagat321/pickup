import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/models/game.dart';
import 'package:pickup/services/auth_service.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  Future<List<Game>> getGames(DateTime date) async {
    QuerySnapshot snapshot = await _firestore
        .collection('games')
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .get();

    return snapshot.docs.map((doc) => Game.fromJson(doc.data() as Map<String, dynamic>)).toList();
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

  Future<DocumentReference<Map<String, dynamic>>> createGame(Game game) async { //TODO:
    return _firestore.collection('games').add(game.toJson());
  }

}