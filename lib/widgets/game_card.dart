import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String? time; //Time of the game.
  final String? location; //Address of the Field.
  final String? message; //Potential Announcements.
  final double? rating; //Averaged rating of everyone in the group.
  final int? players;

  GameCard({
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
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time!,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              location!,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.0),
            Row( //TODO: Implement half-star functionality.
              children: List.generate(
                rating!.round()!,
                (index) => Icon(Icons.star, color: Colors.orange),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              message!,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}