import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import '../providers/feed_provider.dart';
import 'post_media.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;

  const PostWidget({super.key, required this.post});

  void _showSnackbar(BuildContext context, String action) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF262626),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        content: Text('$action not implemented', style: const TextStyle(color: Colors.white, fontSize: 14)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: post.user.hasActiveStory ? const LinearGradient(
                    colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFF77737), Color(0xFFFFDC80)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ) : null,
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundImage: CachedNetworkImageProvider(post.user.profileImageUrl),
                    backgroundColor: Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                post.user.username,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () => _showSnackbar(context, 'Options'),
              )
            ],
          ),
        ),

        // Post Media (Carousel + Pinch-to-zoom + Double-tap Like)
        PostMedia(
          images: post.images,
          onDoubleTap: () => context.read<FeedProvider>().likePost(post.id),
        ),

        // Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Consumer<FeedProvider>(
                builder: (context, provider, _) {
                  return IconButton(
                    icon: Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : Colors.white,
                      size: 26,
                    ),
                    onPressed: () => provider.toggleLike(post.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  );
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, size: 24),
                onPressed: () => _showSnackbar(context, 'Comments'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.send_outlined, size: 24),
                onPressed: () => _showSnackbar(context, 'Share'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.repeat, size: 24),
                onPressed: () => _showSnackbar(context, 'Repost'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              Consumer<FeedProvider>(
                builder: (context, provider, _) {
                  return IconButton(
                    icon: Icon(
                       post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                       color: Colors.white,
                       size: 26,
                    ),
                    onPressed: () {
                      final bool wasSaved = post.isSaved;
                      provider.toggleSave(post.id);
                      if (!wasSaved) {
                        _showSavedNotification(context);
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  );
                },
              ),
            ],
          ),
        ),

        // Likes & Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Consumer<FeedProvider>(
                  builder: (context, provider, _) {
                    return Text(
                      '${post.likesCount} likes',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    );
                  }
               ),
               const SizedBox(height: 5),
               RichText(
                 text: TextSpan(
                   style: const TextStyle(color: Colors.white, fontSize: 13.5),
                   children: [
                     TextSpan(
                        text: post.user.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                     ),
                     const TextSpan(text: ' '),
                     TextSpan(text: post.caption),
                   ]
                 ),
               ),
               const SizedBox(height: 5),
               Text(
                 'View all comments',
                 style: TextStyle(color: Colors.grey.shade600, fontSize: 13.5),
               ),
               const SizedBox(height: 2),
               Text(
                 post.timeAgo,
                 style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
               ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  void _showSavedNotification(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF262626),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Saved', style: TextStyle(color: Colors.white, fontSize: 14)),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Save to collection',
                style: TextStyle(color: Color(0xFF0095F6), fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
