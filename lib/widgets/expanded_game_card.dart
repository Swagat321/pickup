import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:pickup/models/game.dart';
import 'package:pickup/models/user.dart';
import 'package:pickup/services/auth_service.dart';

class ExpandedGameCard extends StatelessWidget {
  final Game game;
  final User user = User(
    //TODO: Replace with actual user
    id: '1',
    userName: 'John Doe',
    email: 'john.doe@example.com',
    phoneNumber: '123-456-7890',
    ranking: 4.5,
    avatarUrl: 'https://example.com/avatar.jpg',
    location: 'New York, USA',
    chatIds: ['chat1', 'chat2', 'chat3'],
  );

  ExpandedGameCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool shouldRequestToJoin = game.currNumPlayers >= game.maxPlayers ||
        (user.ranking != null && user.ranking! < (game.minRating ?? 0)) ||
        game.reqPermission;
    //TODO: Add error handling for null checks.
    int fullStars = game.avgRanking!.floor();
    bool halfStar = (game.avgRanking! - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
    const double pad = 15;
    List<Widget> starWidgets = List.generate(
        fullStars,
        (index) => const Icon(
              Icons.star,
              color: Colors.amber,
              size: pad * 2,
            ));
    if (halfStar) {
      starWidgets.add(const Icon(
        Icons.star_half,
        color: Colors.amber,
        size: pad * 2,
      ));
    }
    starWidgets.addAll(List.generate(
        emptyStars,
        (index) => const Icon(
              Icons.star_border,
              color: Colors.amber,
              size: pad * 2,
            )));

    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(DateFormat.jm().format(game.time!.toDate()),
                      style: const TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(DateFormat.yMMMd().format(game.date!.toDate()),
                  style: const TextStyle(
                        fontSize: 15,
                        )),
                ],
              ),
              Text("@ ${game.location}", style: const TextStyle(fontSize: 20.0,)),
              const SizedBox(height: pad),
              Row(
                children: starWidgets,
              ),
              const SizedBox(height: pad),
              LinearProgressIndicator(
                semanticsLabel: 'Players filled',
                minHeight: pad / 2,
                borderRadius: BorderRadius.circular(pad),
                value: game.currNumPlayers / game.maxPlayers,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(
                  game.currNumPlayers > game.maxPlayers
                      ? Colors.red
                      : Colors.orange,
                ),
              ),
              Text("${game.currNumPlayers} / ${game.maxPlayers}"),
              const SizedBox(height: pad),
              Text(game.announcement ?? '', style: const TextStyle(fontSize: 20.0)),
              const SizedBox(height: pad),
              Image.network(game.gamePic??'https://via.placeholder.com/400',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: pad),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), backgroundColor: shouldRequestToJoin ? Colors.grey : Colors.green,
                  ),
                  onPressed: () {
                    
                  },
                  child: Text(shouldRequestToJoin ? 'Request to Join (Coming soon...)' : 'Join',
                      style: const TextStyle(fontSize: 20.0,
                      color: Colors.white),
                ),
              ),
          )
          ],
          ),
        ),
      ),
    );
  }
}
