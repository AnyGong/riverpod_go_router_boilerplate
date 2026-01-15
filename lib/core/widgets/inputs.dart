import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_go_router_boilerplate/core/constants/app_constants.dart';
import 'package:riverpod_go_router_boilerplate/core/extensions/context_extensions.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// A styled text field with consistent app styling.
///
/// Use this for all text inputs to ensure consistent appearance.
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.autovalidateMode,
  });

  /// Controller for the text field.
  final TextEditingController? controller;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// Label text above the field.
  final String? label;

  /// Hint text inside the field.
  final String? hint;

  /// Helper text below the field.
  final String? helper;

  /// Error message below the field.
  final String? error;

  /// Widget displayed before the input.
  final Widget? prefix;

  /// Icon displayed before the input.
  final IconData? prefixIcon;

  /// Widget displayed after the input.
  final Widget? suffix;

  /// Icon displayed after the input.
  final IconData? suffixIcon;

  /// Type of keyboard to display.
  final TextInputType? keyboardType;

  /// Action button on keyboard.
  final TextInputAction? textInputAction;

  /// How to capitalize text.
  final TextCapitalization textCapitalization;

  /// Whether to obscure text (for passwords).
  final bool obscureText;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether to autofocus on build.
  final bool autofocus;

  /// Maximum number of lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Maximum character length.
  final int? maxLength;

  /// Input formatters to apply.
  final List<TextInputFormatter>? inputFormatters;

  /// Validation function.
  final String? Function(String?)? validator;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when user submits.
  final ValueChanged<String>? onSubmitted;

  /// Called when field is tapped.
  final VoidCallback? onTap;

  /// Auto-validation mode.
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(final BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helper,
        errorText: error,
        prefix: prefix,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffix: suffix,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
    );
  }
}

/// A search text field with built-in styling.
class AppSearchField extends StatelessWidget {
  /// Creates an [AppSearchField].
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.autofocus = false,
  });

  /// Controller for the search field.
  final TextEditingController? controller;

  /// Focus node for the search field.
  final FocusNode? focusNode;

  /// Hint text in the field.
  final String hint;

  /// Called when text changes.
  final ValueChanged<String>? onChanged;

  /// Called when user submits search.
  final ValueChanged<String>? onSubmitted;

  /// Called when clear button is pressed.
  final VoidCallback? onClear;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to autofocus on build.
  final bool autofocus;

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: .search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller != null
            ? ListenableBuilder(
                listenable: controller!,
                builder: (final context, _) {
                  if (controller!.text.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller!.clear();
                      onClear?.call();
                    },
                  );
                },
              )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: .circular(AppConstants.borderRadiusXLarge),
          borderSide: .none,
        ),
        contentPadding: const .symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}

/// A styled chip widget for tags, filters, etc.
class AppChip extends StatelessWidget {
  /// Creates an [AppChip].
  const AppChip({
    required this.label,
    super.key,
    this.icon,
    this.avatar,
    this.selected = false,
    this.onSelected,
    this.onDeleted,
    this.variant = .filled,
  });

  /// Label text for the chip.
  final String label;

  /// Optional icon before label.
  final IconData? icon;

  /// Optional avatar widget.
  final Widget? avatar;

  /// Whether chip is selected.
  final bool selected;

  /// Called when selection changes.
  final ValueChanged<bool>? onSelected;

  /// Called when delete is pressed.
  final VoidCallback? onDeleted;

  /// Visual variant of the chip.
  final AppChipVariant variant;

  @override
  Widget build(final BuildContext context) {
    if (onDeleted != null) {
      return InputChip(
        label: Text(label),
        avatar: avatar ?? (icon != null ? Icon(icon, size: AppConstants.chipIconSize) : null),
        selected: selected,
        onSelected: onSelected,
        onDeleted: onDeleted,
      );
    }

    if (onSelected != null) {
      return switch (variant) {
        .filled => FilterChip(
          label: Text(label),
          avatar: avatar ?? (icon != null ? Icon(icon, size: AppConstants.chipIconSize) : null),
          selected: selected,
          onSelected: onSelected,
        ),
        .outlined => FilterChip.elevated(
          label: Text(label),
          avatar: avatar ?? (icon != null ? Icon(icon, size: AppConstants.chipIconSize) : null),
          selected: selected,
          onSelected: onSelected,
        ),
      };
    }

    return Chip(
      label: Text(label),
      avatar: avatar ?? (icon != null ? Icon(icon, size: AppConstants.chipIconSize) : null),
    );
  }
}

/// Visual variants for [AppChip].
enum AppChipVariant {
  /// Filled chip style.
  filled,

  /// Outlined chip style.
  outlined,
}

/// A badge widget for displaying counts or status.
class AppBadge extends StatelessWidget {
  /// Creates an [AppBadge].
  const AppBadge({
    super.key,
    this.count,
    this.label,
    this.child,
    this.color,
    this.textColor,
    this.showZero = false,
    this.maxCount = 99,
    this.size = .medium,
    this.position = .topRight,
  });

  /// Count to display.
  final int? count;

  /// Label to display (instead of count).
  final String? label;

  /// Child widget to attach badge to.
  final Widget? child;

  /// Background color of badge.
  final Color? color;

  /// Text color of badge.
  final Color? textColor;

  /// Whether to show badge when count is 0.
  final bool showZero;

  /// Maximum count to display (shows 99+ if exceeded).
  final int maxCount;

  /// Size of the badge.
  final AppBadgeSize size;

  /// Position of badge relative to child.
  final AppBadgePosition position;

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    final badgeColor = color ?? theme.colorScheme.error;
    final badgeTextColor = textColor ?? theme.colorScheme.onError;

    // Determine badge content
    String? content;
    if (label != null) {
      content = label;
    } else if (count != null) {
      if (count == 0 && !showZero) {
        if (child != null) return child!;
        return const SizedBox.shrink();
      }
      content = count! > maxCount ? '$maxCount+' : '$count';
    }

    final badge = Container(
      padding: .symmetric(
        horizontal: size == .small ? 4 : 6,
        vertical: size == .small ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: .circular(
          size == .small ? 8 : 10,
        ),
      ),
      constraints: BoxConstraints(
        minWidth: size == .small ? 16 : 20,
        minHeight: size == .small ? 16 : 20,
      ),
      child: content != null
          ? Text(
              content,
              style: TextStyle(
                color: badgeTextColor,
                fontSize: size == .small ? 10 : 12,
                fontWeight: .bold,
              ),
              textAlign: .center,
            )
          : null,
    );

    if (child == null) return badge;

    // Position calculation
    final (top, right, bottom, left) = switch (position) {
      AppBadgePosition.topRight => (-4.0, -4.0, null, null),
      AppBadgePosition.topLeft => (-4.0, null, null, -4.0),
      AppBadgePosition.bottomRight => (null, -4.0, -4.0, null),
      AppBadgePosition.bottomLeft => (null, null, -4.0, -4.0),
    };

    return Stack(
      clipBehavior: .none,
      children: [
        child!,
        Positioned(
          top: top,
          right: right,
          bottom: bottom,
          left: left,
          child: badge,
        ),
      ],
    );
  }
}

/// Size variants for [AppBadge].
enum AppBadgeSize {
  /// Small badge.
  small,

  /// Medium badge.
  medium,
}

/// Position variants for [AppBadge].
enum AppBadgePosition {
  /// Top-right corner.
  topRight,

  /// Top-left corner.
  topLeft,

  /// Bottom-right corner.
  bottomRight,

  /// Bottom-left corner.
  bottomLeft,
}

/// A divider with optional label text.
class AppDivider extends StatelessWidget {
  /// Creates an [AppDivider].
  const AppDivider({
    super.key,
    this.label,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });

  /// Optional label to display in the middle.
  final String? label;

  /// Thickness of the divider.
  final double thickness;

  /// Indent from the leading edge.
  final double indent;

  /// Indent from the trailing edge.
  final double endIndent;

  /// Color of the divider.
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    final dividerColor = color ?? theme.dividerColor;

    if (label == null) {
      return Divider(
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: dividerColor,
      );
    }

    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: thickness,
            indent: indent,
            color: dividerColor,
          ),
        ),
        Padding(
          padding: const .symmetric(horizontal: AppSpacing.md),
          child: Text(
            label!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness,
            endIndent: endIndent,
            color: dividerColor,
          ),
        ),
      ],
    );
  }
}

/// A status indicator dot.
class StatusDot extends StatelessWidget {
  /// Creates a [StatusDot].
  const StatusDot({
    super.key,
    this.status = StatusType.info,
    this.size = 8,
    this.animated = false,
  });

  /// Creates an online status dot.
  const StatusDot.online({super.key, this.size = 8, this.animated = false})
    : status = StatusType.success;

  /// Creates an offline status dot.
  const StatusDot.offline({super.key, this.size = 8, this.animated = false})
    : status = StatusType.neutral;

  /// Creates a busy status dot.
  const StatusDot.busy({super.key, this.size = 8, this.animated = false})
    : status = StatusType.error;

  /// Creates an away status dot.
  const StatusDot.away({super.key, this.size = 8, this.animated = false})
    : status = StatusType.warning;

  /// Status type determining color.
  final StatusType status;

  /// Size of the dot.
  final double size;

  /// Whether to show pulse animation.
  final bool animated;

  @override
  Widget build(final BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final color = switch (status) {
      StatusType.success => colorScheme.primary,
      StatusType.warning => colorScheme.tertiary,
      StatusType.error => colorScheme.error,
      StatusType.info => colorScheme.secondary,
      StatusType.neutral => colorScheme.outline,
    };

    final dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: .circle,
      ),
    );

    if (!animated) return dot;

    return _PulsingDot(color: color, size: size);
  }
}

/// Status types for status indicators.
enum StatusType {
  /// Success/online status.
  success,

  /// Warning/away status.
  warning,

  /// Error/busy status.
  error,

  /// Informational status.
  info,

  /// Neutral/offline status.
  neutral,
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _animation.value),
            shape: .circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _animation.value * 0.5),
                blurRadius: widget.size,
                spreadRadius: widget.size * 0.25 * _animation.value,
              ),
            ],
          ),
        );
      },
    );
  }
}
