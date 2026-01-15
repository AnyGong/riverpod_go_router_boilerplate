import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Welcome card displayed on the home page.
///
/// Shows a success message with a welcome icon to greet the user
/// after successful authentication.
class WelcomeCard extends StatelessWidget {
  /// Creates a [WelcomeCard] instance.
  const WelcomeCard({required this.theme, super.key});

  /// The theme data for styling.
  final ThemeData theme;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
            Text(
              l10n.youAreAllSet,
              style: theme.textTheme.titleLarge,
            ),
            const VerticalSpace.sm(),
            Text(
              l10n.startBuilding,
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
