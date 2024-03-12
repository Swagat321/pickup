import 'package:flutter/material.dart';

class PickUpLogo extends StatelessWidget {
  const PickUpLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'PickUp',
      style: TextStyle(
        color: Colors.red, // Adjust the color to match the design
        fontSize: 32, // Adjust the font size to match the design
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
