

import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String message;
  String userId;
  String? userName;
  String chatId;
  Timestamp time;

  Message({required this.message, required this.userId, required this.chatId, required this.time, required this.userName});

  Message.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        userId = json['userId'],
        chatId = json['chatId'],
        time = json['time'] as Timestamp,
        userName = json['userName'] as String?; //Leave this as String? even though its required because previous iterations didn't have a userName field.
      
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['userId'] = userId;
    data['chatId'] = chatId;
    data['time'] = time;
    data['userName'] = userName;
    return data;
  }

}