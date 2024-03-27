import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:pickup/models/game.dart'; // Adjust import paths as necessary
import 'package:pickup/models/user.dart'; // Adjust import paths as necessary
import 'package:pickup/widgets/expanded_game_card.dart'; // Adjust import paths as necessary

class GameCard extends StatelessWidget {
  final Game game;
  final User user;

  const GameCard({
    super.key,
    required this.game,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // Safely handle potentially null game.time with a fallback
    String formattedTime = game.time != null ? DateFormat('h:mm a').format(game.time!.toDate()) : 'Time not set';

    // Calculate the number of full and half stars for the rating
    int fullStars = game.avgRanking?.floor() ?? 0;
    bool hasHalfStar = game.avgRanking != null && (game.avgRanking! - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    List<Widget> starWidgets = List.generate(fullStars, (index) => const Icon(Icons.star, color: Colors.amber));
    if (hasHalfStar) {
      starWidgets.add(const Icon(Icons.star_half, color: Colors.amber));
    }
    starWidgets.addAll(List.generate(emptyStars, (index) => const Icon(Icons.star_border, color: Colors.amber)));

    // Prepare a sample of the announcement text, safely handling a potentially null announcement
    String announcementSample = game.announcement != null && game.announcement!.length > 50
        ? '${game.announcement!.substring(0, 50)}...'
        : game.announcement ?? '';

    return InkWell(
      onTap: () {
        Get.dialog(
          Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
              child: ExpandedGameCard(game: game, user: user),
            ),
          ),
          barrierDismissible: true,
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedTime,
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  if (game.reqPermission) const Icon(Icons.lock_outline, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                game.location ?? 'Location not set', // Safely handle potentially null location
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8.0),
              Row(children: starWidgets),
              const SizedBox(height: 8.0),
              Text(
                announcementSample,
                style: const TextStyle(fontSize: 16.0, overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
