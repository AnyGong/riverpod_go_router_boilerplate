// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ফ্লাটার বয়লারপ্লেট';

  @override
  String get welcomeMessage => 'অ্যাপে স্বাগতম!';

  @override
  String get login => 'লগইন';

  @override
  String get logout => 'লগআউট';

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get signUp => 'সাইন আপ';

  @override
  String get settings => 'সেটিংস';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get home => 'হোম';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get language => 'ভাষা';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get biometricAuthentication => 'বায়োমেট্রিক প্রমাণীকরণ';

  @override
  String get biometricPromptTitle => 'প্রমাণীকরণ';

  @override
  String get biometricPromptSubtitle => 'চালিয়ে যেতে আপনার পরিচয় যাচাই করুন';

  @override
  String get biometricPromptCancel => 'বাতিল';

  @override
  String get errorGeneric => 'কিছু ভুল হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get errorNetwork =>
      'নেটওয়ার্ক সমস্যা। অনুগ্রহ করে আপনার সংযোগ পরীক্ষা করুন।';

  @override
  String get errorTimeout => 'সময় শেষ। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get errorUnauthorized =>
      'সেশন শেষ হয়েছে। অনুগ্রহ করে আবার লগইন করুন।';

  @override
  String get retry => 'পুনরায় চেষ্টা';

  @override
  String get cancel => 'বাতিল';

  @override
  String get confirm => 'নিশ্চিত';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get delete => 'মুছুন';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get noData => 'কোন তথ্য পাওয়া যায়নি';

  @override
  String get searchHint => 'অনুসন্ধান করুন...';

  @override
  String version(String version) {
    return 'সংস্করণ $version';
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
      other: '$countStringটি আইটেম',
      one: '১টি আইটেম',
      zero: 'কোন আইটেম নেই',
    );
    return '$_temp0';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'সর্বশেষ আপডেট: $dateString';
  }

  @override
  String get onboardingTitle1 => 'স্বাগতম';

  @override
  String get onboardingDescription1 =>
      'আমাদের অ্যাপের দারুণ ফিচারগুলো আবিষ্কার করুন এবং শুরু করুন।';

  @override
  String get onboardingTitle2 => 'অন্বেষণ';

  @override
  String get onboardingDescription2 =>
      'আপনার জন্য বিশেষভাবে তৈরি বিভিন্ন কন্টেন্ট ব্রাউজ করুন।';

  @override
  String get onboardingTitle3 => 'শুরু করুন';

  @override
  String get onboardingDescription3 =>
      'আপনার অ্যাকাউন্ট তৈরি করুন এবং যাত্রা শুরু করুন।';

  @override
  String get skip => 'স্কিপ';

  @override
  String get next => 'পরবর্তী';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get offlineModeEnabled => 'অফলাইন মোড সক্রিয়';

  @override
  String get backOnline => 'আপনি আবার অনলাইনে আছেন';
}
