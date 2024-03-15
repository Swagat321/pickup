import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:pickup/models/game.dart';
import 'package:pickup/widgets/expanded_game_card.dart';

class GameCard extends StatelessWidget {
  final Game game; // Using the Game model

  const GameCard({
    super.key, 
    required this.game, // Expect a Game object
  });

  @override
  Widget build(BuildContext context) {
    // Format the time as requested
    String formattedTime = DateFormat('h:mm a').format(game.time!.toDate());

    // Calculate the number of full and half stars for the rating
    int fullStars = game.avgRanking!.floor();
    bool hasHalfStar = (game.avgRanking! - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    // Generate star widgets, including half-stars
    List<Widget> starWidgets = List.generate(fullStars, 
      (index) => const Icon(Icons.star, color: Colors.amber));
    if (hasHalfStar) {
      starWidgets.add(const Icon(Icons.star_half, color: Colors.amber));
    }
    starWidgets.addAll(List.generate(emptyStars, 
      (index) => const Icon(Icons.star_border, color: Colors.amber)));

    // Prepare a sample of the announcement text
    String announcementSample = (game.announcement != null && game.announcement!.length > 50)
      ? '${game.announcement!.substring(0, 50)}...'
      : (game.announcement ?? '');

    return InkWell(
      onTap: () {
        // Navigate to the expanded game card view or show details
        // Get.to(ExpandedGameCard(game: game));
Get.dialog(
    Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400, // Maximum width for the dialog
          maxHeight: 600, // Maximum height for the dialog
        ),
        child: ExpandedGameCard(game: game), // Your custom widget
      ),
    ),
    barrierDismissible: true, // Set to true if you want to close the dialog by tapping the barrier
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
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (game.reqPermission) const Icon(Icons.lock_outline, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                game.location!,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: starWidgets,
              ),
              const SizedBox(height: 8.0),
              Text(
                announcementSample,
                style: const TextStyle(
                  fontSize: 16.0,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Make sure to also include the ExpandedGameCard implementation above,
// as the GameCard will be a gateway to showing the expanded view.
