import 'package:flutter/material.dart';
import 'package:open_git/localizations/zh_string.dart';

import 'app_base_string.dart';
import 'en_string.dart';

class AppLocalizations {
  final Locale locale;

  final Map<String, AppBaseString> _localizations = {
    'en': EnString(),
    'zh': ZhString(),
  };

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  AppBaseString get currentlocal {
    return _localizations[locale.languageCode];
  }
}
