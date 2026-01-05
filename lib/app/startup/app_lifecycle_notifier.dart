import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/app_config.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_events.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_signals.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_machine.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/startup_state_resolver.dart';
import 'package:riverpod_go_router_boilerplate/core/session/session.dart';

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

  /// Check if we transitioned from one state type to another
  bool transitionedFrom<T extends StartupState>() {
    return previousState is T && currentState is! T;
  }

  @override
  String toString() =>
      'AppLifecycleState(current: $currentState, previous: $previousState, event: $lastEvent, initialized: $isInitialized)';
}

/// Notifier that manages the app lifecycle and state transitions.
///
/// This provides explicit lifecycle management with:
/// - Event-driven state changes (not just "where do I go?" but "why am I here?")
/// - State transition tracking
/// - Re-evaluation capability when conditions change
/// - ChangeNotifier for GoRouter integration
class AppLifecycleNotifier extends Notifier<AppLifecycleState> with ChangeNotifier {
  @override
  AppLifecycleState build() {
    return const AppLifecycleState.initial();
  }

  /// Initialize the app lifecycle by processing the launch event.
  ///
  /// Call this from SplashPage to trigger initial state resolution.
  Future<void> initialize() async {
    if (state.isInitialized) return;

    await processEvent(const AppLaunched());

    state = state.copyWith(isInitialized: true);
    notifyListeners();
  }

  /// Process a startup event and potentially transition to a new state.
  ///
  /// This is the main entry point for lifecycle transitions.
  /// Events describe "why" we need to re-evaluate, and the
  /// resolver determines "where" we should go.
  Future<void> processEvent(StartupEvent event) async {
    final signals = await _collectSignals(event);
    final newState = StartupStateResolver.resolve(signals);

    // Only transition if state actually changed
    if (newState.runtimeType != state.currentState.runtimeType) {
      _transitionTo(newState, event);
    } else {
      // Update event even if state didn't change
      state = state.copyWith(lastEvent: event);
    }
  }

  /// Manually trigger re-evaluation of the current state.
  ///
  /// Useful when external conditions might have changed
  /// (remote config, feature flags, etc.)
  Future<void> reevaluate() async {
    final signals = await _collectCurrentSignals();
    final newState = StartupStateResolver.resolve(signals);

    if (newState.runtimeType != state.currentState.runtimeType) {
      _transitionTo(newState, null);
    }
  }

  /// Collect signals based on the triggering event.
  ///
  /// Different events may short-circuit certain signals.
  Future<StartupSignals> _collectSignals(StartupEvent event) async {
    switch (event) {
      case AppLaunched():
        return _collectCurrentSignals();

      case UserAuthenticated():
        // User just logged in, skip auth check
        return StartupSignals(
          isInMaintenance: await _checkMaintenance(),
          hasCompletedOnboarding: await _checkOnboarding(),
          isAuthenticated: true,
          isAuthEnabled: AppConfig.authEnabled,
          isOnboardingEnabled: AppConfig.onboardingEnabled,
        );

      case UserLoggedOut():
      case SessionExpiredEvent():
        // Session ended, we know auth state
        return StartupSignals(
          isInMaintenance: await _checkMaintenance(),
          hasCompletedOnboarding: await _checkOnboarding(),
          isAuthenticated: false,
          isAuthEnabled: AppConfig.authEnabled,
          isOnboardingEnabled: AppConfig.onboardingEnabled,
        );

      case OnboardingCompleted():
        // Onboarding just finished
        return StartupSignals(
          isInMaintenance: await _checkMaintenance(),
          hasCompletedOnboarding: true,
          isAuthenticated: await _checkAuth(),
          isAuthEnabled: AppConfig.authEnabled,
          isOnboardingEnabled: AppConfig.onboardingEnabled,
        );

      case MaintenanceEnabled():
        return StartupSignals(
          isInMaintenance: true,
          hasCompletedOnboarding: await _checkOnboarding(),
          isAuthenticated: await _checkAuth(),
          isAuthEnabled: AppConfig.authEnabled,
          isOnboardingEnabled: AppConfig.onboardingEnabled,
        );

      case MaintenanceDisabled():
        return StartupSignals(
          isInMaintenance: false,
          hasCompletedOnboarding: await _checkOnboarding(),
          isAuthenticated: await _checkAuth(),
          isAuthEnabled: AppConfig.authEnabled,
          isOnboardingEnabled: AppConfig.onboardingEnabled,
        );

      default:
        return _collectCurrentSignals();
    }
  }

  /// Collect all current signals by checking actual state.
  Future<StartupSignals> _collectCurrentSignals() async {
    return StartupSignals(
      isInMaintenance: await _checkMaintenance(),
      hasCompletedOnboarding: await _checkOnboarding(),
      isAuthenticated: await _checkAuth(),
      isAuthEnabled: AppConfig.authEnabled,
      isOnboardingEnabled: AppConfig.onboardingEnabled,
    );
  }

  Future<bool> _checkMaintenance() async {
    // Could be extended to check remote config
    return false;
  }

  Future<bool> _checkOnboarding() async {
    // Could check shared preferences or a dedicated service
    return true; // Default to completed
  }

  Future<bool> _checkAuth() async {
    final sessionState = ref.read(sessionStateProvider);
    return sessionState.isAuthenticated;
  }

  void _transitionTo(StartupState newState, StartupEvent? event) {
    state = AppLifecycleState(
      currentState: newState,
      lastEvent: event,
      previousState: state.currentState,
      isInitialized: state.isInitialized,
    );
    notifyListeners();
  }

  // --- Convenience methods for common events ---

  /// Call when user successfully logs in
  Future<void> onUserLoggedIn(String userId) async {
    await processEvent(UserAuthenticated(userId: userId));
  }

  /// Call when user logs out
  Future<void> onUserLoggedOut() async {
    await processEvent(const UserLoggedOut());
  }

  /// Call when session expires
  Future<void> onSessionExpired({String? reason}) async {
    await processEvent(SessionExpiredEvent(reason: reason));
  }

  /// Call when onboarding is completed
  Future<void> onOnboardingCompleted() async {
    await processEvent(const OnboardingCompleted());
  }

  /// Call when maintenance mode changes
  Future<void> onMaintenanceModeChanged({required bool isEnabled}) async {
    if (isEnabled) {
      await processEvent(const MaintenanceEnabled());
    } else {
      await processEvent(const MaintenanceDisabled());
    }
  }
}

/// Provider for the AppLifecycleNotifier.
final appLifecycleNotifierProvider = NotifierProvider<AppLifecycleNotifier, AppLifecycleState>(
  AppLifecycleNotifier.new,
);

/// Listenable for GoRouter refresh.
///
/// This is what connects the lifecycle to router navigation.
final appLifecycleListenableProvider = Provider<Listenable>((ref) {
  final notifier = ref.watch(appLifecycleNotifierProvider.notifier);
  return notifier;
});

/// Current startup state for convenience.
final currentStartupStateProvider = Provider<StartupState>((ref) {
  return ref.watch(appLifecycleNotifierProvider).currentState;
});

/// Whether app lifecycle is initialized.
final isLifecycleInitializedProvider = Provider<bool>((ref) {
  return ref.watch(appLifecycleNotifierProvider).isInitialized;
});
