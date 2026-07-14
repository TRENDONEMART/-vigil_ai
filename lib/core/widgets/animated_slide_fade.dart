import 'package:flutter/material.dart';

class AnimatedSlideFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double beginOffsetY;
  final Curve curve;

  const AnimatedSlideFadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 420),
    this.delay = Duration.zero,
    this.beginOffsetY = 0.10,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedSlideFadeIn> createState() => _AnimatedSlideFadeInState();
}

class _AnimatedSlideFadeInState extends State<AnimatedSlideFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final tween = Tween<double>(begin: 0, end: 1);
    final eased = CurvedAnimation(parent: _controller, curve: widget.curve);

    _opacity = tween.animate(eased);

    _offset = Tween<Offset>(
      begin: Offset(0, widget.beginOffsetY),
      end: Offset.zero,
    ).animate(eased);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}

