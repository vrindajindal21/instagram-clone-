import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post_model.dart';
import '../repositories/post_repository.dart';

class FeedProvider with ChangeNotifier {
  final PostRepository _repository;

  List<PostModel> _posts = [];
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;

  List<PostModel> get posts => _posts;
  bool get isLoadingInitial => _isLoadingInitial;
  bool get isLoadingMore => _isLoadingMore;

  FeedProvider(this._repository) {
    _fetchInitialPosts();
  }

  Future<void> _fetchInitialPosts() async {
    _isLoadingInitial = true;
    notifyListeners();

    try {
       final newPosts = await _repository.fetchPosts(page: _currentPage);
       _posts = newPosts;
    } catch (e) {
      // Handle error gracefully if needed
    }

    _isLoadingInitial = false;
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    if (_isLoadingMore || _isLoadingInitial) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    try {
      final newPosts = await _repository.fetchPosts(page: _currentPage);
      _posts.addAll(newPosts);
    } catch(e) {
      // Handle error silently
      _currentPage--;
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  void toggleLike(String postId) {
    int index = _posts.indexWhere((p) => p.id == postId);
    if(index != -1) {
      PostModel p = _posts[index];
      p.isLiked = !p.isLiked;
      p.likesCount += p.isLiked ? 1 : -1;
      HapticFeedback.mediumImpact();
      notifyListeners();
    }
  }

  void likePost(String postId) {
    int index = _posts.indexWhere((p) => p.id == postId);
    if(index != -1 && !_posts[index].isLiked) {
      _posts[index].isLiked = true;
      _posts[index].likesCount++;
      HapticFeedback.mediumImpact();
      notifyListeners();
    } else if (index != -1) {
       // Still trigger haptic even if already liked for feedback
       HapticFeedback.mediumImpact();
    }
  }

  void toggleSave(String postId) {
    int index = _posts.indexWhere((p) => p.id == postId);
    if(index != -1) {
       PostModel p = _posts[index];
       p.isSaved = !p.isSaved;
       HapticFeedback.lightImpact();
       notifyListeners();
    }
  }
}
