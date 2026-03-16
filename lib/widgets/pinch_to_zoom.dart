import 'package:flutter/material.dart';

class PinchToZoom extends StatefulWidget {
  final Widget child;

  const PinchToZoom({super.key, required this.child});

  @override
  State<PinchToZoom> createState() => _PinchToZoomState();
}

class _PinchToZoomState extends State<PinchToZoom> with SingleTickerProviderStateMixin {
  late TransformationController _transformController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
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
    if (_transformController.value.getMaxScaleOnAxis() > 1.0) {
      _animation = Matrix4Tween(
        begin: _transformController.value,
        end: Matrix4.identity(),
      ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
      _animationController.forward(from: 0).then((_) {
         _removeOverlay();
      });
    } else {
       _removeOverlay();
    }
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // Initial start, wait for pointers in update
  }
  
  void _onInteractionUpdate(ScaleUpdateDetails details) {
     // CRITICAL: Only show the overlay if at least 2 fingers are detected.
     // This prevents the "zoom while scrolling" bug on mobile.
     if (_overlayEntry == null && details.pointerCount >= 2) {
       _showOverlay();
     }
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy,
              width: size.width,
              height: size.height,
              child: IgnorePointer(
                child: InteractiveViewer(
                  transformationController: _transformController,
                  panEnabled: false,
                  scaleEnabled: false, // Managed by the primary InteractiveViewer
                  clipBehavior: Clip.none,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: widget.child,
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _transformController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformController,
      panEnabled: false,
      scaleEnabled: true,
      clipBehavior: Clip.none,
      minScale: 1.0,
      maxScale: 4.0,
      onInteractionStart: _onInteractionStart,
      onInteractionUpdate: _onInteractionUpdate,
      onInteractionEnd: _onInteractionEnd,
      child: widget.child,
    );
  }
}
