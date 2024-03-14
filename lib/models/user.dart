import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String userName;
  String email;
  String phoneNumber;
  String ranking;
  String avatarUrl;
  String location;
  List<String> chatIds;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.ranking,
    required this.avatarUrl,
    required this.location,
    required this.chatIds,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userName = json['userName'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        ranking = json['ranking'],
        avatarUrl = json['avatarUrl'],
        location = json['location'],
        chatIds = List.from(json['chatIds']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['ranking'] = ranking;
    data['avatarUrl'] = avatarUrl;
    data['location'] = location;
    data['chatIds'] = chatIds;
    return data;
  }
}
