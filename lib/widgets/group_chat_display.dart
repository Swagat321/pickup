import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupChatDisplay extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String latestMsg;
  final Timestamp latestMsgTime;
  final double ranking;
  final VoidCallback onTap;

  const GroupChatDisplay({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.latestMsg,
    required this.latestMsgTime,
    required this.ranking, 
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert the Timestamp to DateTime
    final dateTime = latestMsgTime.toDate();

    // Format the DateTime to HH:MM am/pm format
    final timeString = DateFormat.jm().format(dateTime);

    // Calculate the shade of gold based on the ranking
    final colorValue = (255 - (ranking / 5) * 100).toInt();
    final backgroundColor = Color.fromRGBO(255, colorValue, 0, 1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          latestMsg,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(timeString, style: const TextStyle(color: Colors.black, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}