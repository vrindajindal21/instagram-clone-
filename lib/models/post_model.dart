import 'user_model.dart';

class PostModel {
  final String id;
  final UserModel user;
  final List<String> images;
  final String caption;
  int likesCount;
  bool isLiked;
  bool isSaved;
  final String timeAgo;

  PostModel({
    required this.id,
    required this.user,
    required this.images,
    required this.caption,
    required this.likesCount,
    this.isLiked = false,
    this.isSaved = false,
    required this.timeAgo,
  });

  PostModel copyWith({
    bool? isLiked,
    bool? isSaved,
    int? likesCount,
  }) {
    return PostModel(
      id: id,
      user: user,
      images: images,
      caption: caption,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      timeAgo: timeAgo,
    );
  }
}
