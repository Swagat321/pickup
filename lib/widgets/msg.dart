import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickup/services/log.dart';

class Msg extends StatelessWidget {
  final String content;
  final Timestamp time;
  final String userName;
  final String avatarUrl;
  final bool isSentByMe;
  final Animation<double> animation; // New parameter for animation

  const Msg({
    Key? key,
    required this.content,
    required this.time,
    required this.userName,
    required this.avatarUrl,
    required this.isSentByMe,
    required this.animation, // Initialize this in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment:
                isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Stack(
                // fit: StackFit.passthrough,
                children: [
                  Transform.translate(
                    offset: Offset(-animation.value * 60,
                        0), // Slide the message content to the left
                    child: Column(children: [
                      if (!isSentByMe) ...[
                        Text(userName,
                            textAlign: TextAlign.left,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(avatarUrl),
                            ),
                            const SizedBox(width: 8),
                            ConstrainedBox(
                              
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6,
                              ),
                              child: Container(
                                
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  content,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ], // Message for the other user.

                      if (isSentByMe)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                content,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        )
                    ]),
                  ),
                  Positioned(
                    right: 0,
                    child: Opacity(
                      opacity: animation.value, // Fade the timestamp in or out
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat.jm().format(time.toDate()),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
