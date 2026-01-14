import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
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
            onTap: () => _showThemeDialog(context, ref, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.language),
            subtitle: Text(
              _languageLabel(currentLocale ?? const Locale('en'), l10n),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref, l10n),
          ),

          const Divider(),

          // Notifications section
          SettingsSectionHeader(title: l10n.notifications),
          const NotificationBadgeSettings(),

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
            trailing: const Icon(Icons.open_in_new, size: 20),
            onTap: () {
              // TODO: Open terms of service
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(Icons.open_in_new, size: 20),
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

  void _showThemeDialog(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) {
    final currentMode = ref.read(themeNotifierProvider);

    showDialog<void>(
      context: context,
      builder: (final dialogContext) => SimpleDialog(
        title: Text(l10n.chooseTheme),
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
                  _themeModeLabel(mode, l10n),
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

  void _showLanguageDialog(
    final BuildContext context,
    final WidgetRef ref,
    final AppLocalizations l10n,
  ) {
    final currentLocale =
        ref.read(localeNotifierProvider) ?? const Locale('en');

    showDialog<void>(
      context: context,
      builder: (final dialogContext) => SimpleDialog(
        title: Text(l10n.chooseLanguage),
        children: [
          _buildLanguageOption(
            dialogContext,
            'en',
            l10n.english,
            currentLocale.languageCode == 'en',
            () {
              ref
                  .read(localeNotifierProvider.notifier)
                  .setLocale(const Locale('en'));
              Navigator.of(dialogContext).pop();
            },
          ),
          _buildLanguageOption(
            dialogContext,
            'bn',
            l10n.bengali,
            currentLocale.languageCode == 'bn',
            () {
              ref
                  .read(localeNotifierProvider.notifier)
                  .setLocale(const Locale('bn'));
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }

  SimpleDialogOption _buildLanguageOption(
    final BuildContext context,
    final String languageCode,
    final String languageName,
    final bool isSelected,
    final VoidCallback onTap,
  ) {
    return SimpleDialogOption(
      onPressed: onTap,
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? context.colorScheme.primary : null,
          ),
          const HorizontalSpace.sm(),
          Text(
            languageName,
            style: isSelected
                ? TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
