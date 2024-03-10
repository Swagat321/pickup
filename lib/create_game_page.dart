import 'package:flutter/material.dart';

class CreateGame extends StatefulWidget {
  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Create Game",
        style: TextStyle(fontSize: 48),
      ),
    );
  }
}