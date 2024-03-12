

import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String message;
  String userId;
  String chatId;
  Timestamp time;

  Message({required this.message, required this.userId, required this.chatId, required this.time,});

  Message.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        userId = json['userId'],
        chatId = json['chatId'],
        time = json['time'] as Timestamp; //Ensure this is fine.
      
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['userId'] = userId;
    data['chatId'] = chatId;
    data['time'] = time;
    return data;
  }

}