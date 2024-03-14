import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/services/log.dart';

class Game {
  String chatId;
  Timestamp date;
  Timestamp time;
  String location;
  int maxPlayers;
  double minRating;
  String announcement;
  String reqPermission;
  String gamePic;

  Game({
    required this.chatId,
    required this.date,
    required this.time,
    required this.location,
    required this.maxPlayers,
    required this.minRating,
    required this.announcement,
    required this.reqPermission,
    required this.gamePic,
  });

  factory Game.fromJson(Map<String, dynamic> json) { //Example of factory constructor with error handling.
    try {
      return Game(
        chatId: json['chatId'] as String,
        date: json['date'] as Timestamp,
        time: json['time'] as Timestamp,
        location: json['location'] as String,
        maxPlayers: json['maxPlayers'] as int,
        minRating: json['minRating'] as double,
        announcement: json['announcement'] as String,
        reqPermission: json['reqPermission'] as String,
        gamePic: json['gamePic'] as String,
      );
    } catch (e) {
      Log.error("Error parsing Game from JSON", e);
      throw FormatException('Invalid or missing fields in JSON: $e');
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['date'] = date;
    data['time'] = time;
    data['location'] = location;
    data['maxPlayers'] = maxPlayers;
    data['minRating'] = minRating;
    data['announcement'] = announcement;
    data['reqPermission'] = reqPermission;
    data['gamePic'] = gamePic;
    return data;
  }
}