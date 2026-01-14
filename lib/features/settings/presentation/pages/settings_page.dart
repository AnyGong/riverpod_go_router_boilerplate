import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/providers/package_info_provider.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/widgets/notification_badge_settings.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/widgets/settings_section_header.dart';

/// Settings page demonstrating theme switching and app info.
class SettingsPage extends ConsumerWidget {
  /// Creates a [SettingsPage] instance.
  const SettingsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final packageInfo = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Appearance section
          const SettingsSectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: Text(_themeModeLabel(themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, ref),
          ),

          const Divider(),

          // Notifications section
          const SettingsSectionHeader(title: 'Notifications'),
          const NotificationBadgeSettings(),

          const Divider(),

          // About section
          const SettingsSectionHeader(title: 'About'),
          packageInfo.when(
            data: (final info) => Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Version'),
                  subtitle: Text('${info.version} (${info.buildNumber})'),
                ),
                ListTile(
                  leading: const Icon(Icons.apps),
                  title: const Text('Package Name'),
                  subtitle: Text(info.packageName),
                ),
              ],
            ),
            loading: () => const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Version'),
              subtitle: Text('Loading...'),
            ),
            error: (_, _) => const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Version'),
              subtitle: Text('Error loading info'),
            ),
          ),

          const Divider(),

          // Legal section
          const SettingsSectionHeader(title: 'Legal'),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.open_in_new, size: 20),
            onTap: () {
              // TODO: Open terms of service
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.open_in_new, size: 20),
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Open Source Licenses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Flutter Boilerplate',
            ),
          ),
        ],
      ),
    );
  }

  String _themeModeLabel(final ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
    ThemeMode.system => 'System default',
  };

  void _showThemeDialog(final BuildContext context, final WidgetRef ref) {
    final currentMode = ref.read(themeNotifierProvider);

    showDialog<void>(
      context: context,
      builder: (final dialogContext) => SimpleDialog(
        title: const Text('Choose Theme'),
        children: ThemeMode.values.map((final mode) {
          final isSelected = mode == currentMode;
          return SimpleDialogOption(
            onPressed: () {
              ref.read(themeNotifierProvider.notifier).setThemeMode(mode);
              Navigator.of(dialogContext).pop();
            },
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? dialogContext.colorScheme.primary : null,
                ),
                const HorizontalSpace.sm(),
                Text(
                  _themeModeLabel(mode),
                  style: isSelected
                      ? TextStyle(
                          fontWeight: FontWeight.bold,
                          color: dialogContext.colorScheme.primary,
                        )
                      : null,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
