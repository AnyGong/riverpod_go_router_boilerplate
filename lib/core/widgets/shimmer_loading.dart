import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer loading placeholder for content.
///
/// Usage:
/// ```dart
/// ShimmerLoading(
///   child: Container(
///     width: 100,
///     height: 100,
///     color: Colors.white,
///   ),
/// )
/// ```
class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    required this.child,
    super.key,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(final BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!),
      highlightColor:
          highlightColor ?? (isDark ? Colors.grey[700]! : Colors.grey[100]!),
      child: child,
    );
  }
}

/// A shimmer loading placeholder for a single line of text.
class ShimmerLine extends StatelessWidget {
  const ShimmerLine({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 4,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(final BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A shimmer loading placeholder for a circle (avatar).
class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({super.key, this.size = 48});

  final double size;

  @override
  Widget build(final BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// A shimmer loading placeholder for a card/container.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, this.width, this.height, this.borderRadius = 8});

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(final BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A shimmer loading placeholder for a list tile.
class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lines = 2,
  });

  final bool hasLeading;
  final bool hasTrailing;
  final int lines;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          if (hasLeading) ...[const ShimmerCircle(), const SizedBox(width: 16)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLine(width: 120, height: 14),
                if (lines > 1) ...[
                  const SizedBox(height: 8),
                  const ShimmerLine(height: 12),
                ],
                if (lines > 2) ...[
                  const SizedBox(height: 6),
                  ShimmerLine(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 12,
                  ),
                ],
              ],
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 16),
            const ShimmerBox(width: 24, height: 24),
          ],
        ],
      ),
    );
  }
}

/// A shimmer loading placeholder for a card with image and text.
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.width, this.imageHeight = 120});

  final double? width;
  final double imageHeight;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: double.infinity,
            height: imageHeight,
            borderRadius: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLine(width: width != null ? width! * 0.7 : 150),
                const SizedBox(height: 8),
                const ShimmerLine(height: 12),
                const SizedBox(height: 4),
                ShimmerLine(
                  width: width != null ? width! * 0.5 : 100,
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A list of shimmer loading placeholders.
class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lines = 2,
  });

  final int itemCount;
  final bool hasLeading;
  final bool hasTrailing;
  final int lines;

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (final context, final index) => ShimmerListTile(
        hasLeading: hasLeading,
        hasTrailing: hasTrailing,
        lines: lines,
      ),
    );
  }
}
