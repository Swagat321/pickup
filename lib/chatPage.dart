import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Chat",
        style: TextStyle(fontSize: 48),
      ),
    );
  }
}
