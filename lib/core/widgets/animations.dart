import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';

/// Animation utilities and pre-built animations.
abstract class AppAnimations {
  // ─────────────────────────────────────────────────────────────────────────────
  // CURVES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Standard easing curve for most animations.
  static const Curve standard = Curves.easeInOut;

  /// Emphasized curve for important transitions.
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Deceleration curve for entering elements.
  static const Curve decelerate = Curves.decelerate;

  /// Acceleration curve for exiting elements.
  static const Curve accelerate = Curves.easeIn;

  /// Bounce curve for playful animations.
  static const Curve bounce = Curves.bounceOut;

  /// Elastic curve for spring-like animations.
  static const Curve elastic = Curves.elasticOut;

  // ─────────────────────────────────────────────────────────────────────────────
  // PAGE TRANSITIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Fade page transition.
  static Widget fadeTransition(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
    final Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Slide up page transition.
  static Widget slideUpTransition(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
    final Widget child,
  ) {
    final tween = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).chain(CurveTween(curve: standard));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Slide from right page transition.
  static Widget slideRightTransition(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
    final Widget child,
  ) {
    final tween = Tween(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: standard));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Scale page transition.
  static Widget scaleTransition(
    final BuildContext context,
    final Animation<double> animation,
    final Animation<double> secondaryAnimation,
    final Widget child,
  ) {
    final tween = Tween(begin: 0.9, end: 1.0).chain(
      CurveTween(curve: standard),
    );

    return ScaleTransition(
      scale: animation.drive(tween),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

/// A widget that fades in when first built.
class FadeIn extends StatefulWidget {
  /// Creates a [FadeIn] widget.
  const FadeIn({
    required this.child,
    super.key,
    this.duration = AppConstants.animationNormal,
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
  });

  /// Child widget to animate.
  final Widget child;

  /// Duration of the animation.
  final Duration duration;

  /// Delay before animation starts.
  final Duration delay;

  /// Animation curve.
  final Curve curve;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

/// A widget that slides in when first built.
class SlideIn extends StatefulWidget {
  /// Creates a [SlideIn] widget.
  const SlideIn({
    required this.child,
    super.key,
    this.duration = AppConstants.animationNormal,
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.direction = SlideDirection.fromBottom,
    this.offset = 1.0,
  });

  /// Child widget to animate.
  final Widget child;

  /// Duration of the animation.
  final Duration duration;

  /// Delay before animation starts.
  final Duration delay;

  /// Animation curve.
  final Curve curve;

  /// Direction to slide from.
  final SlideDirection direction;

  /// Initial offset multiplier.
  final double offset;

  @override
  State<SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    final begin = switch (widget.direction) {
      SlideDirection.fromLeft => Offset(-widget.offset, 0),
      SlideDirection.fromRight => Offset(widget.offset, 0),
      SlideDirection.fromTop => Offset(0, -widget.offset),
      SlideDirection.fromBottom => Offset(0, widget.offset),
    };

    _animation = Tween(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}

/// Direction for slide animations.
enum SlideDirection {
  /// Slide from left.
  fromLeft,

  /// Slide from right.
  fromRight,

  /// Slide from top.
  fromTop,

  /// Slide from bottom.
  fromBottom,
}

/// A widget that scales in when first built.
class ScaleIn extends StatefulWidget {
  /// Creates a [ScaleIn] widget.
  const ScaleIn({
    required this.child,
    super.key,
    this.duration = AppConstants.animationNormal,
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.begin = 0.0,
    this.alignment = Alignment.center,
  });

  /// Child widget to animate.
  final Widget child;

  /// Duration of the animation.
  final Duration duration;

  /// Delay before animation starts.
  final Duration delay;

  /// Animation curve.
  final Curve curve;

  /// Initial scale value.
  final double begin;

  /// Alignment for scale transform.
  final Alignment alignment;

  @override
  State<ScaleIn> createState() => _ScaleInState();
}

class _ScaleInState extends State<ScaleIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween(begin: widget.begin, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}

/// A widget that animates a list of items with staggered timing.
class StaggeredList extends StatelessWidget {
  /// Creates a [StaggeredList].
  const StaggeredList({
    required this.children,
    super.key,
    this.itemDuration = const Duration(milliseconds: 200),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.curve = Curves.easeOut,
    this.direction = SlideDirection.fromBottom,
  });

  /// Children to animate.
  final List<Widget> children;

  /// Duration for each item's animation.
  final Duration itemDuration;

  /// Delay between each item's animation.
  final Duration staggerDelay;

  /// Animation curve.
  final Curve curve;

  /// Slide direction.
  final SlideDirection direction;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: children.asMap().entries.map((final entry) {
        return FadeIn(
          duration: itemDuration,
          delay: staggerDelay * entry.key,
          curve: curve,
          child: SlideIn(
            duration: itemDuration,
            delay: staggerDelay * entry.key,
            curve: curve,
            direction: direction,
            offset: 0.3,
            child: entry.value,
          ),
        );
      }).toList(),
    );
  }
}

/// A widget that shakes when triggered.
class ShakeWidget extends StatefulWidget {
  /// Creates a [ShakeWidget].
  const ShakeWidget({
    required this.child,
    required this.controller,
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.shakeCount = 3,
    this.shakeOffset = 10.0,
  });

  /// Child widget to shake.
  final Widget child;

  /// Controller to trigger shake.
  final ShakeController controller;

  /// Duration of shake animation.
  final Duration duration;

  /// Number of shakes.
  final int shakeCount;

  /// Offset of each shake.
  final double shakeOffset;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = TweenSequence<double>([
      for (int i = 0; i < widget.shakeCount; i++) ...[
        TweenSequenceItem(
          tween: Tween(begin: 0, end: widget.shakeOffset),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: widget.shakeOffset, end: -widget.shakeOffset),
          weight: 2,
        ),
        TweenSequenceItem(
          tween: Tween(begin: -widget.shakeOffset, end: 0.0),
          weight: 1,
        ),
      ],
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    widget.controller._attach(this);
  }

  void shake() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (final context, final child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: widget.child,
        );
      },
    );
  }
}

/// Controller for [ShakeWidget].
class ShakeController {
  _ShakeWidgetState? _state;

  void _attach(final _ShakeWidgetState state) {
    _state = state;
  }

  /// Triggers the shake animation.
  void shake() {
    _state?.shake();
  }
}

/// A pulsing animation widget.
class Pulse extends StatefulWidget {
  /// Creates a [Pulse] widget.
  const Pulse({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.0,
    this.enabled = true,
  });

  /// Child widget to animate.
  final Widget child;

  /// Duration of one pulse cycle.
  final Duration duration;

  /// Minimum scale value.
  final double minScale;

  /// Maximum scale value.
  final double maxScale;

  /// Whether animation is enabled.
  final bool enabled;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween(begin: widget.minScale, end: widget.maxScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(final Pulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (!widget.enabled) return widget.child;

    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
