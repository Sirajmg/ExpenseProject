import 'package:flutter/material.dart';

class AppAnimations {
  static Widget fadeScale({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      ),
    );
  }

  static Widget slideUp({
    required Widget child,
    required Animation<double> animation,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static Widget slideIn({
    required Widget child,
    required Animation<double> animation,
    bool fromRight = true,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(fromRight ? 1.0 : -1.0, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static Widget bounce({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        ),
      ),
      child: child,
    );
  }

  static Widget shimmer({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white,
            Colors.white.withOpacity(0.5),
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: _SlidingGradientTransform(
            slidePercent: animation.value,
          ),
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, value, child) {
        return AppAnimations.fadeScale(
          animation: AlwaysStoppedAnimation(value),
          child: child!,
        );
      },
      child: child,
    );
  }
}

class AnimatedPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final bool fromRight;

  AnimatedPageRoute({
    required this.page,
    this.fromRight = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return AppAnimations.slideIn(
              animation: animation,
              fromRight: fromRight,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
} 