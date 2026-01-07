import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that displays loading, error, or data states for an [AsyncValue].
///
/// Example:
/// ```dart
/// AsyncValueWidget<User>(
///   value: ref.watch(userProvider),
///   data: (user) => Text(user.name),
/// )
/// ```
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.value,
    required this.data,
    super.key,
    this.loading,
    this.error,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = false,
  });

  /// The [AsyncValue] to display.
  final AsyncValue<T> value;

  /// Builder for the data state.
  final Widget Function(T data) data;

  /// Optional builder for the loading state.
  /// Defaults to a centered [CircularProgressIndicator].
  final Widget Function()? loading;

  /// Optional builder for the error state.
  /// Defaults to a centered error message with retry option.
  final Widget Function(Object error, StackTrace stackTrace)? error;

  /// Whether to skip showing loading indicator on refresh.
  final bool skipLoadingOnRefresh;

  /// Whether to skip showing loading indicator on reload.
  final bool skipLoadingOnReload;

  @override
  Widget build(final BuildContext context) {
    return value.when(
      data: data,
      loading: loading ?? () => const LoadingWidget(),
      error: error ?? (final e, final st) => ErrorWidget.builder(error: e),
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
    );
  }
}

/// A widget that displays a loading indicator.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.size = 40.0, this.strokeWidth = 3.0, this.message});

  final double size;
  final double strokeWidth;
  final String? message;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(strokeWidth: strokeWidth),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}

/// A widget that displays an error message with optional retry action.
class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    required this.message,
    super.key,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Build an error widget from an exception.
  factory ErrorWidget.builder({
    required final Object error,
    final VoidCallback? onRetry,
  }) {
    return ErrorWidget(message: error.toString(), onRetry: onRetry);
  }

  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget that displays an empty state.
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    required this.message,
    super.key,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.actionLabel,
  });

  final String message;
  final IconData icon;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(onPressed: action, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
