import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';

/// Types of snackbar messages.
enum SnackbarType {
  /// Success message (green).
  success,

  /// Error message (red).
  error,

  /// Warning message (orange).
  warning,

  /// Informational message (blue).
  info,
}

/// Configuration for a snackbar message.
class SnackbarConfig {
  /// Creates a [SnackbarConfig] instance.
  const SnackbarConfig({
    required this.message,
    this.type = SnackbarType.info,
    this.duration = const Duration(seconds: 3),
    this.action,
    this.actionLabel,
    this.dismissible = true,
  });

  /// The message to display.
  final String message;

  /// The type of snackbar (affects styling).
  final SnackbarType type;

  /// How long to show the snackbar.
  final Duration duration;

  /// Callback when action button is pressed.
  final VoidCallback? action;

  /// Label for the action button.
  final String? actionLabel;

  /// Whether the snackbar can be dismissed by swiping.
  final bool dismissible;
}

/// Configuration for a dialog.
class DialogConfig {
  /// Creates a [DialogConfig] instance.
  const DialogConfig({
    required this.title,
    this.message,
    this.content,
    this.confirmLabel = 'OK',
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
    this.isDestructive = false,
  });

  /// Dialog title.
  final String title;

  /// Simple text message (alternative to content).
  final String? message;

  /// Custom content widget (alternative to message).
  final Widget? content;

  /// Label for confirm button.
  final String confirmLabel;

  /// Label for cancel button (null = no cancel button).
  final String? cancelLabel;

  /// Callback when confirm is pressed.
  final VoidCallback? onConfirm;

  /// Callback when cancel is pressed.
  final VoidCallback? onCancel;

  /// Whether tapping outside dismisses the dialog.
  final bool barrierDismissible;

  /// Whether the action is destructive (affects confirm button styling).
  final bool isDestructive;
}

/// Service for showing dialogs and snackbars without BuildContext.
///
/// Uses the global [rootNavigatorKey] from GoRouter to access the overlay.
///
/// Example:
/// ```dart
/// // In a notifier or service (no BuildContext needed)
/// final feedbackService = ref.read(feedbackServiceProvider);
///
/// // Show a success message
/// feedbackService.showSuccess('Item saved successfully!');
///
/// // Show an error
/// feedbackService.showError('Failed to save item');
///
/// // Show a confirmation dialog
/// final confirmed = await feedbackService.showConfirmDialog(
///   title: 'Delete Item?',
///   message: 'This action cannot be undone.',
///   isDestructive: true,
/// );
/// if (confirmed) {
///   // Proceed with deletion
/// }
/// ```
class FeedbackService {
  /// Creates a [FeedbackService] instance.
  FeedbackService();

  /// Get the current overlay state from the navigator key.
  ScaffoldMessengerState? get _scaffoldMessenger {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return null;
    return ScaffoldMessenger.maybeOf(context);
  }

  /// Get the navigator state for showing dialogs.
  NavigatorState? get _navigator => rootNavigatorKey.currentState;

  /// Show a snackbar with the given configuration.
  void showSnackbar(final SnackbarConfig config) {
    final messenger = _scaffoldMessenger;
    if (messenger == null) return;

    final snackBar = SnackBar(
      content: Text(config.message),
      duration: config.duration,
      backgroundColor: _getBackgroundColor(config.type),
      behavior: SnackBarBehavior.floating,
      dismissDirection: config.dismissible
          ? DismissDirection.horizontal
          : DismissDirection.none,
      action: config.action != null && config.actionLabel != null
          ? SnackBarAction(
              label: config.actionLabel!,
              textColor: Colors.white,
              onPressed: config.action!,
            )
          : null,
    );

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Show a success snackbar.
  void showSuccess(
    final String message, {
    final Duration duration = const Duration(seconds: 3),
  }) {
    showSnackbar(
      SnackbarConfig(
        message: message,
        type: SnackbarType.success,
        duration: duration,
      ),
    );
  }

  /// Show an error snackbar.
  void showError(
    final String message, {
    final Duration duration = const Duration(seconds: 4),
    final VoidCallback? onRetry,
  }) {
    showSnackbar(
      SnackbarConfig(
        message: message,
        type: SnackbarType.error,
        duration: duration,
        action: onRetry,
        actionLabel: onRetry != null ? 'Retry' : null,
      ),
    );
  }

  /// Show a warning snackbar.
  void showWarning(
    final String message, {
    final Duration duration = const Duration(seconds: 3),
  }) {
    showSnackbar(
      SnackbarConfig(
        message: message,
        type: SnackbarType.warning,
        duration: duration,
      ),
    );
  }

  /// Show an info snackbar.
  void showInfo(
    final String message, {
    final Duration duration = const Duration(seconds: 3),
  }) {
    showSnackbar(
      SnackbarConfig(
        message: message,
        type: SnackbarType.info,
        duration: duration,
      ),
    );
  }

  /// Hide the current snackbar.
  void hideCurrentSnackbar() {
    _scaffoldMessenger?.hideCurrentSnackBar();
  }

  /// Show a dialog with the given configuration.
  Future<bool> showDialog(final DialogConfig config) async {
    final navigator = _navigator;
    if (navigator == null) return false;

    final result = await showAdaptiveDialog<bool>(
      context: navigator.context,
      barrierDismissible: config.barrierDismissible,
      builder: (final context) => AlertDialog.adaptive(
        title: Text(config.title),
        content:
            config.content ??
            (config.message != null ? Text(config.message!) : null),
        actions: [
          if (config.cancelLabel != null)
            TextButton(
              onPressed: () {
                config.onCancel?.call();
                Navigator.of(context).pop(false);
              },
              child: Text(config.cancelLabel!),
            ),
          TextButton(
            onPressed: () {
              config.onConfirm?.call();
              Navigator.of(context).pop(true);
            },
            style: config.isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(config.confirmLabel),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Show a simple confirmation dialog.
  ///
  /// Returns true if user confirmed, false otherwise.
  Future<bool> showConfirmDialog({
    required final String title,
    final String? message,
    final String confirmLabel = 'Confirm',
    final String cancelLabel = 'Cancel',
    final bool isDestructive = false,
  }) {
    return showDialog(
      DialogConfig(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
  }

  /// Show an alert dialog (single OK button).
  Future<void> showAlert({
    required final String title,
    final String? message,
    final String buttonLabel = 'OK',
  }) async {
    await showDialog(
      DialogConfig(
        title: title,
        message: message,
        confirmLabel: buttonLabel,
      ),
    );
  }

  /// Show a loading dialog that can be dismissed programmatically.
  ///
  /// Returns a function to dismiss the dialog.
  VoidCallback showLoading({final String? message}) {
    final navigator = _navigator;
    if (navigator == null) return () {};

    final completer = Completer<void>();

    showAdaptiveDialog<void>(
      context: navigator.context,
      barrierDismissible: false,
      builder: (final context) => PopScope(
        canPop: false,
        child: AlertDialog.adaptive(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              if (message != null) ...[
                const SizedBox(width: 16),
                Flexible(child: Text(message)),
              ],
            ],
          ),
        ),
      ),
    ).then((_) {
      if (!completer.isCompleted) completer.complete();
    });

    return () {
      if (!completer.isCompleted) {
        completer.complete();
        navigator.pop();
      }
    };
  }

  /// Show a bottom sheet.
  Future<T?> showBottomSheet<T>({
    required final Widget Function(BuildContext context) builder,
    final bool isDismissible = true,
    final bool enableDrag = true,
    final bool showDragHandle = true,
  }) async {
    final navigator = _navigator;
    if (navigator == null) return null;

    return showModalBottomSheet<T>(
      context: navigator.context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      builder: builder,
    );
  }

  Color _getBackgroundColor(final SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Colors.green.shade700;
      case SnackbarType.error:
        return Colors.red.shade700;
      case SnackbarType.warning:
        return Colors.orange.shade700;
      case SnackbarType.info:
        return Colors.blue.shade700;
    }
  }
}

/// Provider for [FeedbackService].
///
/// Use this to show dialogs and snackbars from anywhere without context.
final feedbackServiceProvider = Provider<FeedbackService>((final ref) {
  return FeedbackService();
});
