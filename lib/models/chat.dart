
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String chatId;
  List<String> userIds;
  String gamePic;
  String chatName;
  String latestMessage;
  Timestamp latestMessageTime;
  double avgRanking;
  List<Messages> messages;

  Chat({
    required this.chatId,
    required this.userIds,
    required this.gamePic,
    required this.chatName,
    required this.latestMessage,
    required this.latestMessageTime,
    required this.avgRanking,
    required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        userIds = List.from(json['userIds']),
        gamePic = json['gamePic'],
        chatName = json['chatName'],
        latestMessage = json['latestMessage'],
        latestMessageTime = json['latestMessageTime'] as Timestamp,
        avgRanking = json['avgRanking'] as double,
        messages = List.from(json['messages']);
        

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['userIds'] = userIds;
    data['gamePic'] = gamePic;
    data['chatName'] = chatName;
    data['latestMessage'] = latestMessage;
    data['latestMessageTime'] = latestMessageTime;
    data['avgRanking'] = avgRanking;
    return data;
  }
}

class Messages {
}
