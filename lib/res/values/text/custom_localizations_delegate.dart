import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mismedidasb/res/values/config.dart';
import 'package:mismedidasb/res/values/text/strings_base.dart';
import 'package:mismedidasb/res/values/text/strings_en.dart';
import 'package:mismedidasb/res/values/text/strings_es.dart';
import 'package:mismedidasb/res/values/text/strings_it.dart';

class CustomLocalizationsDelegate extends LocalizationsDelegate<StringsBase> {
  static StringsBase stringsBase = StringsEs();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("es", ""),
      Locale("en", ""),
      Locale("it", ""),
    ];
  }

  @override
  Future<StringsBase> load(Locale locale) {
    switch (locale.languageCode) {
      case "es":
        stringsBase = StringsEs();
        currentLang = AppLocale.ES;
        break;
      case "en":
        stringsBase = StringsEn();
        currentLang = AppLocale.EN;
        break;
      case "it":
        stringsBase = StringsIt();
        currentLang = AppLocale.IT;
        break;
      default:
        stringsBase = StringsEs();
        currentLang = AppLocale.ES;
        break;
    }
    return SynchronousFuture<StringsBase>(stringsBase);
  }

  static AppLocale currentLang;

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return resolve(locale, fallback, supported);
    };
  }

  Locale resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  bool isSupported(Locale locale) {
    return supportedLocales
        .map((l) => l.languageCode)
        .toList()
        .contains(locale.languageCode);
  }

  @override
  bool shouldReload(LocalizationsDelegate<StringsBase> old) => false;
}
