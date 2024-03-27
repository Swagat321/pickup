//Example page that displays text in the center that it recevies in the parameter:
import 'package:flutter/material.dart';
class ExamplePage extends StatelessWidget {
  final String text;

  const ExamplePage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}

