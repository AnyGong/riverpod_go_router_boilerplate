import 'package:flutter/material.dart';

/// Responsive breakpoints used throughout the app.
abstract class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

/// A widget that builds different layouts based on screen size.
///
/// Usage:
/// ```dart
/// ResponsiveBuilder(
///   mobile: (context) => MobileLayout(),
///   tablet: (context) => TabletLayout(),
///   desktop: (context) => DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.mobile, this.tablet, this.desktop});

  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.desktop) {
          return desktop?.call(context) ?? tablet?.call(context) ?? mobile(context);
        }
        if (constraints.maxWidth >= Breakpoints.tablet) {
          return tablet?.call(context) ?? mobile(context);
        }
        return mobile(context);
      },
    );
  }
}

/// A widget that returns different values based on screen size.
///
/// Usage:
/// ```dart
/// ResponsiveValue<int>(
///   context: context,
///   mobile: 2,
///   tablet: 3,
///   desktop: 4,
/// ).value
/// ```
class ResponsiveValue<T> {
  ResponsiveValue({required BuildContext context, required T mobile, T? tablet, T? desktop})
    : _mobile = mobile,
      _tablet = tablet,
      _desktop = desktop,
      _width = MediaQuery.of(context).size.width;

  final T _mobile;
  final T? _tablet;
  final T? _desktop;
  final double _width;

  T get value {
    if (_width >= Breakpoints.desktop) {
      return _desktop ?? _tablet ?? _mobile;
    }
    if (_width >= Breakpoints.tablet) {
      return _tablet ?? _mobile;
    }
    return _mobile;
  }
}

/// Extension for getting responsive values from context.
extension ResponsiveContextExtension on BuildContext {
  /// Get a responsive value based on screen size
  T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    return ResponsiveValue<T>(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).value;
  }

  /// Check if the current screen is mobile size
  bool get isMobile => MediaQuery.of(this).size.width < Breakpoints.mobile;

  /// Check if the current screen is tablet size
  bool get isTablet {
    final width = MediaQuery.of(this).size.width;
    return width >= Breakpoints.mobile && width < Breakpoints.tablet;
  }

  /// Check if the current screen is desktop size
  bool get isDesktop => MediaQuery.of(this).size.width >= Breakpoints.tablet;
}

/// A responsive grid that adjusts columns based on screen size.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio = 1,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        if (constraints.maxWidth >= Breakpoints.desktop) {
          columns = desktopColumns;
        } else if (constraints.maxWidth >= Breakpoints.tablet) {
          columns = tabletColumns;
        } else {
          columns = mobileColumns;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// A widget that shows/hides content based on screen size.
class ResponsiveVisibility extends StatelessWidget {
  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.visibleOnDesktop = true,
    this.replacement,
  });

  final Widget child;
  final bool visibleOnMobile;
  final bool visibleOnTablet;
  final bool visibleOnDesktop;
  final Widget? replacement;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool visible;
        if (constraints.maxWidth >= Breakpoints.desktop) {
          visible = visibleOnDesktop;
        } else if (constraints.maxWidth >= Breakpoints.tablet) {
          visible = visibleOnTablet;
        } else {
          visible = visibleOnMobile;
        }

        if (visible) return child;
        return replacement ?? const SizedBox.shrink();
      },
    );
  }
}
