// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Boilerplate';

  @override
  String get welcomeMessage => 'Welcome to the app!';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get home => 'Home';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get biometricAuthentication => 'Biometric Authentication';

  @override
  String get biometricPromptTitle => 'Authenticate';

  @override
  String get biometricPromptSubtitle => 'Verify your identity to continue';

  @override
  String get biometricPromptCancel => 'Cancel';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorUnauthorized => 'Session expired. Please login again.';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get searchHint => 'Search...';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String itemCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Last updated: $dateString';
  }

  @override
  String get onboardingTitle1 => 'Welcome';

  @override
  String get onboardingDescription1 =>
      'Discover amazing features and get started with our app.';

  @override
  String get onboardingTitle2 => 'Explore';

  @override
  String get onboardingDescription2 =>
      'Browse through a wide variety of content tailored for you.';

  @override
  String get onboardingTitle3 => 'Get Started';

  @override
  String get onboardingDescription3 =>
      'Create your account and start your journey.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get offlineModeEnabled => 'Offline mode enabled';

  @override
  String get backOnline => 'You\'re back online';
}
