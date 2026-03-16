import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryTray extends StatelessWidget {
  const StoryTray({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        itemCount: 10,
        itemBuilder: (context, index) {
          bool isMe = index == 0;
          bool isCloseFriend = index == 2 || index == 5;
          bool isSeen = index == 3 || index == 6 || index == 8;

          Gradient? gradient;
          if (isMe) {
            gradient = null;
          } else if (isCloseFriend) {
            gradient = const LinearGradient(
              colors: [Color(0xFF1CB00F), Color(0xFF5ED53C)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            );
          } else if (isSeen) {
            gradient = null;
          } else {
             // Default Unseen Gradient
             gradient = const LinearGradient(
              colors: [
                Color(0xFF833AB4), // Purple
                Color(0xFFFD1D1D), // Red
                Color(0xFFF77737), // Orange
                Color(0xFFFFDC80), // Yellow
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSeen ? Border.all(color: Colors.grey.withAlpha(100), width: 1) : null,
                        gradient: gradient,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isMe || isSeen ? 0 : 2.5),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: 'https://picsum.photos/seed/story_$index/150/150',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey.shade900),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isMe)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: const Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isMe ? 'Your story' : 'user_$index',
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
