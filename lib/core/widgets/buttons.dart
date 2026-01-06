import 'package:flutter/material.dart';

/// A primary button with consistent styling.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final AppButtonVariant variant;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary ? colorScheme.onPrimary : colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: _iconSize), const SizedBox(width: 8)],
              Text(label),
            ],
          );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: _buttonStyle(context),
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: _buttonStyle(context),
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: isLoading ? null : onPressed,
        style: _buttonStyle(context),
        child: child,
      ),
    };

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  double get _iconSize => switch (size) {
    AppButtonSize.small => 16,
    AppButtonSize.medium => 20,
    AppButtonSize.large => 24,
  };

  ButtonStyle _buttonStyle(BuildContext context) {
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(_minSize),
      padding: WidgetStatePropertyAll(_padding),
    );
  }

  Size get _minSize => switch (size) {
    AppButtonSize.small => const Size(64, 36),
    AppButtonSize.medium => const Size(88, 44),
    AppButtonSize.large => const Size(112, 52),
  };

  EdgeInsets get _padding => switch (size) {
    AppButtonSize.small => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  };
}

enum AppButtonVariant { primary, secondary, text }

enum AppButtonSize { small, medium, large }

/// An icon button with consistent styling.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.variant = AppIconButtonVariant.standard,
    this.size = 24,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final AppIconButtonVariant variant;
  final double size;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      AppIconButtonVariant.standard => IconButton(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(context),
        iconSize: size,
        tooltip: tooltip,
      ),
      AppIconButtonVariant.filled => IconButton.filled(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(context),
        iconSize: size,
        tooltip: tooltip,
      ),
      AppIconButtonVariant.outlined => IconButton.outlined(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(context),
        iconSize: size,
        tooltip: tooltip,
      ),
      AppIconButtonVariant.filledTonal => IconButton.filledTonal(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(context),
        iconSize: size,
        tooltip: tooltip,
      ),
    };

    return button;
  }

  Widget _buildIcon(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: size * 0.8,
        height: size * 0.8,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Icon(icon);
  }
}

enum AppIconButtonVariant { standard, filled, outlined, filledTonal }
