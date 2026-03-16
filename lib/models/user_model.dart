class UserModel {
  final String id;
  final String username;
  final String profileImageUrl;
  final bool hasActiveStory;

  UserModel({
    required this.id,
    required this.username,
    required this.profileImageUrl,
    this.hasActiveStory = false,
  });
}
