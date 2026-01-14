import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/app/startup/app_lifecycle_notifier.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/domain/entities/user.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';
import 'package:riverpod_go_router_boilerplate/features/home/presentation/widgets/notification_demo.dart';

/// Home page shown after successful authentication.
class HomePage extends ConsumerWidget {
  /// Creates a [HomePage] instance.
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          const ConnectivityIndicator(),
          AppIconButton(
            icon: Icons.settings_outlined,
            onPressed: () => context.pushRoute(AppRoute.settings),
          ),
        ],
      ),
      body: AsyncValueWidget<User?>(
        value: authState,
        data: (final user) {
          if (user == null) {
            return const Center(child: Text('No user data'));
          }
          return _HomeContent(user: user, theme: theme);
        },
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.user, required this.theme});

  final User user;
  final ThemeData theme;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ResponsivePadding(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // User avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                user.email.substring(0, 1).toUpperCase(),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const VerticalSpace.md(),

            // User info
            Text(
              user.name ?? 'User',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const VerticalSpace.sm(),
            Text(
              user.email,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const VerticalSpace.md(),
            // Welcome message
            _WelcomeCard(theme: theme),
            const VerticalSpace.md(),

            // Demo: Notification with Deep Linking & Badges
            const NotificationDeepLinkDemo(),
            const VerticalSpace.md(),
            // Logout button
            AppButton(
              variant: .secondary,
              size: .large,
              isExpanded: true,
              onPressed: () => _handleLogout(context, ref),
              icon: Icons.logout,
              label: 'Sign Out',
            ),
            const VerticalSpace.md(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          AppButton(
            variant: .text,
            isExpanded: false,
            onPressed: () => Navigator.of(context).pop(false),
            label: 'Cancel',
          ),
          AppButton(
            variant: .primary,
            isExpanded: false,
            onPressed: () => Navigator.of(context).pop(true),
            label: 'Sign Out',
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      final sessionService = ref.read(sessionServiceProvider);
      await sessionService.endSession();

      final lifecycleNotifier = ref.read(appLifecycleNotifierProvider.notifier);
      await lifecycleNotifier.onUserLoggedOut();
    }
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(final BuildContext context) {
    return Card(
      child: ResponsivePadding(
        child: Column(
          children: [
            Icon(
              Icons.check_circle,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const VerticalSpace.md(),
            Text("You're all set!", style: theme.textTheme.titleLarge),
            const VerticalSpace.sm(),
            Text(
              'Start building your amazing app.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
