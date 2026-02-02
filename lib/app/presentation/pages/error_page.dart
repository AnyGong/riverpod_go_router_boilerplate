import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';

/// Error page shown when a route is not found (404).
///
/// Displays a user-friendly message with the attempted path
/// and provides navigation back to the home screen.
class ErrorPage extends StatelessWidget {
  /// Creates an [ErrorPage] widget.
  const ErrorPage({required this.path, super.key});

  /// The path that was not found.
  final String path;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ResponsivePadding(
            horizontal: AppSpacing.lg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildErrorIcon(context),
                const VerticalSpace.lg(),
                _buildTitle(context),
                const VerticalSpace.sm(),
                _buildPathText(context),
                const VerticalSpace.xl(),
                _buildHomeButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the error icon/animation container.
  Widget _buildErrorIcon(final BuildContext context) {
    final colorScheme = context.colorScheme;
    return LottieAnimationWidget(
      assetPath: Assets.errorAnimation,
      fallback: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.error_outline,
          size: AppConstants.iconSizeXL,
          color: colorScheme.error,
        ),
      ),
    );
  }

  /// Builds the title text.
  Widget _buildTitle(final BuildContext context) {
    final textTheme = context.textTheme;

    return Text(
      'Page Not Found',
      style: textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Builds the path display text.
  Widget _buildPathText(final BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM),
      ),
      child: Text(
        path,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontFamily: 'monospace',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Builds the home navigation button.
  Widget _buildHomeButton(final BuildContext context) {
    return AppButton(
      variant: .primary,
      onPressed: () => context.goRoute(.home),
      icon: Icons.home,
      label: 'Go Home',
    );
  }
}
