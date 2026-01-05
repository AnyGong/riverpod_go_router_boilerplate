import 'package:riverpod_go_router_boilerplate/app/startup/startup_events.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';

/// State for the AppLifecycle that tracks both current state and history.
class AppLifecycleState {
  const AppLifecycleState({
    required this.currentState,
    required this.lastEvent,
    required this.isInitialized,
    this.previousState,
  });

  const AppLifecycleState.initial()
    : currentState = const PublicState(),
      lastEvent = null,
      previousState = null,
      isInitialized = false;

  final StartupState currentState;
  final StartupEvent? lastEvent;
  final StartupState? previousState;
  final bool isInitialized;

  AppLifecycleState copyWith({
    StartupState? currentState,
    StartupEvent? lastEvent,
    StartupState? previousState,
    bool? isInitialized,
  }) {
    return AppLifecycleState(
      currentState: currentState ?? this.currentState,
      lastEvent: lastEvent ?? this.lastEvent,
      previousState: previousState ?? this.previousState,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  /// Check if we transitioned from one state type to another.
  bool transitionedFrom<T extends StartupState>() {
    return previousState is T && currentState is! T;
  }

  @override
  String toString() =>
      'AppLifecycleState(current: $currentState, previous: $previousState, '
      'event: $lastEvent, initialized: $isInitialized)';
}
