import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickup/services/log.dart';

class Game {
  String chatId;
  Timestamp? date;
  Timestamp? time;
  String? location;
  int maxPlayers;
  double? minRating;
  String? announcement;
  bool reqPermission;
  String? gamePic;
  double? avgRanking;
  int currNumPlayers;
  String chatName; //Make this the names of all users in the chat until they edit it.

  Game({
    required this.chatId,
    this.date,
    this.time,
    this.location,
    this.maxPlayers = 22,
    this.minRating,
    this.announcement,
    this.reqPermission = false,
    this.gamePic,
    this.avgRanking,
    this.currNumPlayers = 1,
    required this.chatName,
  });

  factory Game.fromJson(Map<String, dynamic> json) { //Example of factory constructor with error handling.
    try {
      return Game(
        chatId: json['chatId'] as String,
        date: json['date'] as Timestamp?,
        time: json['time'] as Timestamp?,
        location: json['location'] as String?,
        maxPlayers: json['maxPlayers'] as int? ?? 22,
        minRating: json['minRating'] as double?,
        announcement: json['announcement'] as String?,
        reqPermission: json['reqPermission'] as bool? ?? false,
        gamePic: json['gamePic'] as String?, 
        avgRanking: json['avgRanking'] as double?,
        currNumPlayers: json['currNumPlayers'] as int? ?? 1,
        chatName: json['chatName'] as String,

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
    data['avgRanking'] = avgRanking;
    data['currNumPlayers'] = currNumPlayers;
    data['chatName'] = chatName;
    return data;
  }
}