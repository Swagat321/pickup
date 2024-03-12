import 'package:flutter/material.dart';

class GroupChatDisplay extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String latestMessage;

  const GroupChatDisplay({super.key, 
    required this.title,
    required this.imageUrl,
    required this.latestMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
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
                Text(latestMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
