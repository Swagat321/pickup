
import 'package:flutter/material.dart';

class GameInfo {
  DateTime? date;
  TimeOfDay? time;
  String? location;
  int maxPlayers;
  int minRating;
  String? announcements;
  String? imageUrl;

  GameInfo({
    this.date,
    this.time,
    this.location,
    this.maxPlayers = 22,
    this.minRating = 0,
    this.announcements,
    this.imageUrl,
  });
}
