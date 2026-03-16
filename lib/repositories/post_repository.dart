import 'dart:math';
import '../models/post_model.dart';
import '../models/user_model.dart';

class PostRepository {
  final Random _random = Random();

  Future<List<PostModel>> fetchPosts({int page = 1, int limit = 10}) async {
    // Force a 1.5-second delay to demonstrate Loading State
    await Future.delayed(const Duration(milliseconds: 1500));

    List<PostModel> posts = [];
    for (int i = 0; i < limit; i++) {
      int idOffset = (page - 1) * limit + i;

      String userId = 'user_$idOffset';
      var user = UserModel(
        id: userId,
        username: 'coder_$idOffset',
        profileImageUrl: 'https://picsum.photos/seed/$userId/150/150',
        hasActiveStory: _random.nextBool(),
      );

      // 30% chance of multple images
      int imageCount = _random.nextDouble() > 0.7 ? 3 : 1;
      List<String> images = [];
      for(int j = 0; j<imageCount; j++) {
        images.add('https://picsum.photos/seed/post_${idOffset}_$j/1080/1080');
      }

      posts.add(
         PostModel(
           id: 'post_$idOffset',
           user: user,
           images: images,
           caption: 'This is an amazing post by ${user.username}! Pixel perfect replication for the challenge 🚀 #flutter #uiux',
           likesCount: _random.nextInt(1000) + 10,
           timeAgo: '${_random.nextInt(23) + 1} hours ago',
         )
      );
    }
    return posts;
  }
}
