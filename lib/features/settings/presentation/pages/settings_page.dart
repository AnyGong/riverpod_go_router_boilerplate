import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_go_router_boilerplate/core/theme/theme_notifier.dart';
import 'package:riverpod_go_router_boilerplate/core/widgets/spacing.dart';

/// Provider for package info
final packageInfoProvider = FutureProvider<PackageInfo>((final ref) async {
  return PackageInfo.fromPlatform();
});

/// Settings page demonstrating theme switching and app info.
class SettingsPage extends ConsumerWidget {
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
          const _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: Text(_themeModeLabel(themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, ref),
          ),

          const Divider(),

          // About section
          const _SectionHeader(title: 'About'),
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
          const _SectionHeader(title: 'Legal'),
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
            onTap: () => showLicensePage(context: context, applicationName: 'Flutter Boilerplate'),
          ),
        ],
      ),
    );
  }

  String _themeModeLabel(final ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System default',
    };
  }

  void _showThemeDialog(final BuildContext context, final WidgetRef ref) {
    final currentMode = ref.read(themeNotifierProvider);

    showDialog(
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
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Theme.of(dialogContext).colorScheme.primary : null,
                ),
                const SizedBox(width: 12),
                Text(
                  _themeModeLabel(mode),
                  style: isSelected
                      ? TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(dialogContext).colorScheme.primary,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
      ),
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
