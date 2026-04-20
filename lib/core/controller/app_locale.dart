import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fruitstime/core/model/app_locale.dart';

final availableLocalesProvider = Provider(
  (ref) => [
    AppLocale(localeName: "🇺🇿 O'zbekcha", localeCode: 'uz'),
    AppLocale(localeName: "🇬🇧 English", localeCode: 'en'),
    AppLocale(localeName: "🇷🇺 Русский", localeCode: 'ru'),
  ],
);

final appLocaleProvider = NotifierProvider(_LocaleNotifier.new);

class _LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => Locale('uz');

  void setLocale(String localeCode) {
    state = Locale(localeCode);
  }
}
