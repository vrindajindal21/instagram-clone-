import 'package:flutter/material.dart';

class SingleImageZoom extends StatefulWidget {
  final Widget child;

  const SingleImageZoom({super.key, required this.child});

  @override
  State<SingleImageZoom> createState() => _SingleImageZoomState();
}

class _SingleImageZoomState extends State<SingleImageZoom> with SingleTickerProviderStateMixin {
  late TransformationController _transformController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        _transformController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _transformController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    _animation = Matrix4Tween(
      begin: _transformController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformController,
      panEnabled: false, // Pan only when scaled
      clipBehavior: Clip.none,
      minScale: 1.0,
      maxScale: 4.0,
      onInteractionEnd: _onInteractionEnd,
      child: widget.child,
    );
  }
}
