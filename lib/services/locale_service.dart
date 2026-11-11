
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocaleService {
  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier(const Locale('en'));

  // Only three supported languages
  static const List<String> supportedLanguageCodes = [
    'en',
    'hi',
    'mr',
  ];

  // Load previously saved language
  static Future<void> loadSavedLanguage() async {
    final box = Hive.box('settings');

    final savedLanguage = box.get(
      'languageCode',
      defaultValue: 'en',
    ) as String;

    // If an unsupported language was previously saved,
    // automatically switch to English.
    final languageCode =
        supportedLanguageCodes.contains(savedLanguage)
            ? savedLanguage
            : 'en';

    localeNotifier.value = Locale(languageCode);

    // Update the saved value if it was unsupported.
    if (savedLanguage != languageCode) {
      await box.put('languageCode', languageCode);
    }
  }

  // Change and save selected language
  static Future<void> changeLanguage(String languageCode) async {
    if (!supportedLanguageCodes.contains(languageCode)) {
      return;
    }

    final box = Hive.box('settings');

    await box.put('languageCode', languageCode);

    localeNotifier.value = Locale(languageCode);
  }
}
