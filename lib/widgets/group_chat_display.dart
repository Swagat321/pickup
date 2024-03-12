import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChatDisplay extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String latestMessage;

  GroupChatDisplay({
    required this.title,
    required this.imageUrl,
    required this.latestMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(latestMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
