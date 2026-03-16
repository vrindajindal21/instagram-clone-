import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'pinch_to_zoom.dart';

class PostMedia extends StatefulWidget {
  final List<String> images;
  final VoidCallback onDoubleTap;

  const PostMedia({super.key, required this.images, required this.onDoubleTap});

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  late AnimationController _heartController;
  late Animation<double> _heartScale;
  late Animation<double> _heartOpacity;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2).chain(CurveTween(curve: Curves.elasticOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_heartController);

    _heartOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_heartController);
  }

  @override
  void dispose() {
    _heartController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    widget.onDoubleTap();
    _heartController.forward(from: 0);
  }

  Widget _buildDotIndicator() {
    if (widget.images.length <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.images.length, (index) {
        bool isCurrent = _currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          height: isCurrent ? 6.0 : 5.0,
          width: isCurrent ? 6.0 : 5.0,
          decoration: BoxDecoration(
            color: isCurrent ? Colors.white : Colors.grey.shade600,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildTopCounter() {
    if (widget.images.length <= 1) return const SizedBox.shrink();
    return Positioned(
      top: 15,
      right: 15,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(153),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${_currentIndex + 1}/${widget.images.length}',
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1, // Traditional Instagram Square ratio
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTap: _handleDoubleTap,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return PinchToZoom(
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey.shade900),
                        errorWidget: (context, url, error) => _buildErrorWidget(),
                      ),
                    );
                  },
                ),
              ),
              _buildTopCounter(),
              // Heart Animation Overlay
              IgnorePointer(
                child: AnimatedBuilder(
                  animation: _heartController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _heartOpacity.value,
                      child: Transform.scale(
                        scale: _heartScale.value,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 100, // Slightly larger for better visibility
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (widget.images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: _buildDotIndicator(),
          ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey.shade900,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.grey, size: 40),
          SizedBox(height: 8),
          Text('Failed to load image', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
