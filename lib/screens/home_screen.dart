import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/feed_provider.dart';
import '../widgets/post_widget.dart';
import '../widgets/story_tray.dart';
import '../widgets/shimmer_feed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(Icons.add_box_outlined, size: 28),
          onPressed: () { _showSnackbar(context, "Create Post"); },
        ),
        title: Text(
          'Instagram',
          style: GoogleFonts.grandHotel(
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 28),
            onPressed: () { _showSnackbar(context, "Notifications"); },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<FeedProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingInitial) {
            return const ShimmerFeed();
          }

          if (provider.posts.isEmpty) {
            return const Center(child: Text("No Posts Available"));
          }

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: StoryTray(),
              ),
              const SliverToBoxAdapter(
                child: Divider(height: 1, color: Colors.white24),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Trigger Pagination
                    if (index >= provider.posts.length - 2) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                         provider.fetchMorePosts();
                      });
                    }

                    if (index == provider.posts.length) {
                       return const Padding(
                         padding: EdgeInsets.all(16.0),
                         child: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                       );
                    }

                    return PostWidget(post: provider.posts[index]);
                  },
                  childCount: provider.posts.length + (provider.isLoadingMore ? 1 : 0),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnackbar(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action not implemented'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
