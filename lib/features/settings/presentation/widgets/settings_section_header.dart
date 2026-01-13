import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// Section header for settings groups.
class SettingsSectionHeader extends StatelessWidget {
  /// Creates a [SettingsSectionHeader] instance.
  const SettingsSectionHeader({required this.title, super.key});

  /// The title of the section.
  final String title;

  @override
  Widget build(final BuildContext context) {
    return ResponsivePadding(
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
