import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final DateTime? time; //Time of the game.
  final String? location; //Address of the Field.
  final String? message; //Potential Announcements.
  final double? rating; //Averaged rating of everyone in the group.
  final int? players;

  const GameCard({super.key, 
    this.time,
    this.location,
    this.message,
    this.rating,
    this.players,
  });

  //TODO: Replace null checks with proper error handling.
  //TODO: Rethink the logic/design.
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time!.toString(),
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              location!,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8.0),
            Row( //TODO: Implement half-star functionality.
              children: List.generate(
                rating!.round(),
                (index) => const Icon(Icons.star, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message!,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}