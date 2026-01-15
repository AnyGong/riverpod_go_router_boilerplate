import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/widgets/language_selection_dialog.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/widgets/theme_selection_dialog.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/providers/package_info_provider.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/widgets/notification_badge_settings.dart';
import 'package:riverpod_go_router_boilerplate/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Settings page demonstrating theme switching and app info.
class SettingsPage extends ConsumerWidget {
  /// Creates a [SettingsPage] instance.
  const SettingsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final currentLocale = ref.watch(localeNotifierProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    final l10n = AppLocalizations.of(context);

    // Track screen view
    ref.read(analyticsServiceProvider).logScreenView(screenName: 'settings');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Appearance section
          SettingsSectionHeader(title: l10n.appearance),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.theme),
            subtitle: Text(_themeModeLabel(themeMode, l10n)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showThemeSelectionDialog(context, ref, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.language),
            subtitle: Text(
              _languageLabel(currentLocale ?? const Locale('en'), l10n),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLanguageSelectionDialog(context, ref, l10n),
          ),

          const Divider(),

          // Notifications section
          SettingsSectionHeader(title: l10n.notifications),
          const NotificationSettings(),

          const Divider(),

          // About section
          SettingsSectionHeader(title: l10n.about),
          packageInfo.when(
            data: (final info) => Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.versionLabel),
                  subtitle: Text('${info.version} (${info.buildNumber})'),
                ),
                ListTile(
                  leading: const Icon(Icons.apps),
                  title: Text(l10n.packageName),
                  subtitle: Text(info.packageName),
                ),
              ],
            ),
            loading: () => ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.versionLabel),
              subtitle: Text(l10n.loading),
            ),
            error: (_, _) => ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.versionLabel),
              subtitle: Text(l10n.errorGeneric),
            ),
          ),

          const Divider(),

          // Legal section
          SettingsSectionHeader(title: l10n.legal),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.termsOfService),
            trailing: const Icon(
              Icons.open_in_new,
              size: AppConstants.iconSizeMD,
            ),
            onTap: () {
              // TODO: Open terms of service
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(
              Icons.open_in_new,
              size: AppConstants.iconSizeMD,
            ),
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: Text(l10n.openSourceLicenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
            ),
          ),
        ],
      ),
    );
  }

  String _themeModeLabel(
    final ThemeMode mode,
    final AppLocalizations l10n,
  ) => switch (mode) {
    ThemeMode.light => l10n.lightMode,
    ThemeMode.dark => l10n.darkModeOption,
    ThemeMode.system => l10n.systemDefault,
  };

  String _languageLabel(
    final Locale locale,
    final AppLocalizations l10n,
  ) => locale.languageCode == 'bn' ? l10n.bengali : l10n.english;
}
