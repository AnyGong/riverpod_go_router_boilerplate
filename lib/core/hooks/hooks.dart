import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Custom hook for debounced text input.
///
/// Returns a debounced version of the input value that only updates
/// after the specified delay has passed without new input.
///
/// Useful for search fields to avoid making API calls on every keystroke.
///
/// ## Usage
///
/// ```dart
/// class SearchPage extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     final searchController = useTextEditingController();
///     final searchText = useState('');
///
///     // Update searchText on every change
///     useEffect(() {
///       void listener() => searchText.value = searchController.text;
///       searchController.addListener(listener);
///       return () => searchController.removeListener(listener);
///     }, [searchController]);
///
///     // Debounce the search query
///     final debouncedQuery = useDebouncedValue(
///       searchText.value,
///       const Duration(milliseconds: 500),
///     );
///
///     // Only fetch when debounced value changes
///     useEffect(() {
///       if (debouncedQuery.isNotEmpty) {
///         fetchSearchResults(debouncedQuery);
///       }
///       return null;
///     }, [debouncedQuery]);
///
///     return TextField(controller: searchController);
///   }
/// }
/// ```
String useDebouncedValue(final String value, final Duration delay) {
  final debouncedValue = useState(value);

  useEffect(() {
    final timer = Timer(delay, () {
      debouncedValue.value = value;
    });

    return timer.cancel;
  }, [value, delay]);

  return debouncedValue.value;
}

/// Generic debounced value hook for any type.
///
/// Similar to [useDebouncedValue] but works with any type, not just strings.
///
/// ## Usage
///
/// ```dart
/// final debouncedFilter = useDebounced<FilterOptions>(
///   currentFilter,
///   const Duration(milliseconds: 300),
/// );
/// ```
T useDebounced<T>(final T value, final Duration delay) {
  final debouncedValue = useState(value);

  useEffect(() {
    final timer = Timer(delay, () {
      debouncedValue.value = value;
    });

    return timer.cancel;
  }, [value, delay]);

  return debouncedValue.value;
}

/// Custom hook for managing async operations with loading/error states.
///
/// Usage:
/// ```dart
/// final asyncState = useAsyncState<User>();
/// asyncState.execute(() => fetchUser());
/// ```
class AsyncState<T> {
  AsyncState({
    required this.data,
    required this.isLoading,
    required this.error,
    required this.execute,
    required this.reset,
  });

  final T? data;
  final bool isLoading;
  final Object? error;
  final Future<void> Function(Future<T> Function() operation) execute;
  final VoidCallback reset;
}

AsyncState<T> useAsyncState<T>() {
  final data = useState<T?>(null);
  final isLoading = useState(false);
  final error = useState<Object?>(null);

  Future<void> execute(final Future<T> Function() operation) async {
    isLoading.value = true;
    error.value = null;
    try {
      data.value = await operation();
    } catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    data.value = null;
    isLoading.value = false;
    error.value = null;
  }

  return AsyncState(
    data: data.value,
    isLoading: isLoading.value,
    error: error.value,
    execute: execute,
    reset: reset,
  );
}

/// Custom hook for toggle state.
///
/// Usage:
/// ```dart
/// final (isVisible, toggle) = useToggle(false);
/// ```
(bool, VoidCallback) useToggle([final bool initialValue = false]) {
  final state = useState(initialValue);
  return (state.value, () => state.value = !state.value);
}

/// Custom hook for text editing controller with auto-dispose.
///
/// Usage:
/// ```dart
/// final controller = useTextController(text: 'initial');
/// ```
TextEditingController useTextController({final String? text}) {
  return useTextEditingController(text: text);
}

/// Custom hook for focus node with auto-dispose.
///
/// Usage:
/// ```dart
/// final focusNode = useFocusNode();
/// ```
FocusNode useFocusNode() {
  final focusNode = useMemoized(FocusNode.new);
  useEffect(() => focusNode.dispose, [focusNode]);
  return focusNode;
}

/// Custom hook for scroll controller with auto-dispose.
///
/// Usage:
/// ```dart
/// final scrollController = useScrollController();
/// ```
ScrollController useScrollController() {
  final controller = useMemoized(ScrollController.new);
  useEffect(() => controller.dispose, [controller]);
  return controller;
}

/// Custom hook for page controller with auto-dispose.
///
/// Usage:
/// ```dart
/// final pageController = usePageController();
/// ```
PageController usePageController({final int initialPage = 0}) {
  final controller = useMemoized(
    () => PageController(initialPage: initialPage),
  );
  useEffect(() => controller.dispose, [controller]);
  return controller;
}

/// Custom hook for counting down from a value.
///
/// Usage:
/// ```dart
/// final countdown = useCountdown(60);
/// print(countdown.remaining); // seconds left
/// countdown.start();
/// ```
class CountdownState {
  CountdownState({
    required this.remaining,
    required this.isRunning,
    required this.start,
    required this.pause,
    required this.reset,
  });

  final int remaining;
  final bool isRunning;
  final VoidCallback start;
  final VoidCallback pause;
  final void Function([int?]) reset;
}

CountdownState useCountdown(final int initialSeconds) {
  final remaining = useState(initialSeconds);
  final isRunning = useState(false);
  final isMounted = useIsMounted();

  useEffect(() {
    if (!isRunning.value || remaining.value <= 0) {
      if (remaining.value <= 0) isRunning.value = false;
      return null;
    }

    final future = Future.delayed(const Duration(seconds: 1), () {
      if (isMounted() && isRunning.value && remaining.value > 0) {
        remaining.value--;
      }
    });

    return future.ignore;
  }, [isRunning.value, remaining.value]);

  return CountdownState(
    remaining: remaining.value,
    isRunning: isRunning.value,
    start: () => isRunning.value = true,
    pause: () => isRunning.value = false,
    reset: ([final int? newValue]) {
      remaining.value = newValue ?? initialSeconds;
      isRunning.value = false;
    },
  );
}

/// Custom hook for previous value.
///
/// Usage:
/// ```dart
/// final prevCount = usePrevious(count);
/// ```
T? usePrevious<T>(final T value) {
  final ref = useRef<T?>(null);
  useEffect(() {
    ref.value = value;
    return null;
  }, [value]);
  return ref.value;
}

/// Custom hook for mounted state check.
///
/// Usage:
/// ```dart
/// final isMounted = useIsMounted();
/// if (isMounted()) { /* safe to update state */ }
/// ```
bool Function() useIsMounted() {
  final isMounted = useRef(true);
  useEffect(() {
    isMounted.value = true;
    return () => isMounted.value = false;
  }, []);
  return () => isMounted.value;
}
