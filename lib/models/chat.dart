
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickup/models/message.dart';

class Chat {
  String chatId;
  List<String> userIds;
  String? gamePic;
  String chatName;
  String? lastMessage;
  Timestamp?lastMessageTime;
  double? avgRanking;
  // List<Message> messages; //The messages are not stored in the chat object, but in the chat's subcollection in Firestore.

  Chat({
    required this.chatId,
    required this.userIds,
    this.gamePic,
    required this.chatName,
    this.lastMessage,
    this.lastMessageTime, //TODO: March 15 rn. Create fields even if it is null.
    this.avgRanking,
    // required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json, this.chatId)
      : userIds = List.from(json['userIds']),
        gamePic = json['gamePic'],
        chatName = json['chatName'],
        lastMessage = json['lastMessage'],
        lastMessageTime = json['lastMessageTime'] as Timestamp?,
        avgRanking = json['avgRanking'] as double?
        // messages = (json['messages'] as List).map((item) => Message.fromJson(item)).toList()
        ;
        

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['userIds'] = userIds;
    data['gamePic'] = gamePic;
    data['chatName'] = chatName;
    data['lastMessage'] = lastMessage;
    data['lastMessageTime'] = lastMessageTime;
    data['avgRanking'] = avgRanking;
    // data['messages'] = messages;
    return data;
  }
}