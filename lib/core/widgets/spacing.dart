import 'package:flutter/material.dart';

/// Standard spacing values used throughout the app.
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Horizontal spacing widgets.
class HorizontalSpace extends StatelessWidget {
  const HorizontalSpace.xs({super.key}) : width = AppSpacing.xs;
  const HorizontalSpace.sm({super.key}) : width = AppSpacing.sm;
  const HorizontalSpace.md({super.key}) : width = AppSpacing.md;
  const HorizontalSpace.lg({super.key}) : width = AppSpacing.lg;
  const HorizontalSpace.xl({super.key}) : width = AppSpacing.xl;
  const HorizontalSpace.xxl({super.key}) : width = AppSpacing.xxl;
  const HorizontalSpace.custom(this.width, {super.key});

  final double width;

  @override
  Widget build(final BuildContext context) => SizedBox(width: width);
}

/// Vertical spacing widgets.
class VerticalSpace extends StatelessWidget {
  const VerticalSpace.xs({super.key}) : height = AppSpacing.xs;
  const VerticalSpace.sm({super.key}) : height = AppSpacing.sm;
  const VerticalSpace.md({super.key}) : height = AppSpacing.md;
  const VerticalSpace.lg({super.key}) : height = AppSpacing.lg;
  const VerticalSpace.xl({super.key}) : height = AppSpacing.xl;
  const VerticalSpace.xxl({super.key}) : height = AppSpacing.xxl;
  const VerticalSpace.custom(this.height, {super.key});

  final double height;

  @override
  Widget build(final BuildContext context) => SizedBox(height: height);
}

/// A responsive padding wrapper.
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    required this.child,
    super.key,
    this.horizontal = AppSpacing.md,
    this.vertical = AppSpacing.md,
  });

  final Widget child;
  final double horizontal;
  final double vertical;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: child,
    );
  }
}

/// A constrained container for maximum width content.
class ContentContainer extends StatelessWidget {
  const ContentContainer({
    required this.child,
    super.key,
    this.maxWidth = 600,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
