import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Localization {
  Localization(this._locale);

  final Locale _locale;

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  Map<String, dynamic> _sentences;

  Future<bool> load() async {
    String data = await rootBundle
        .loadString('Assets/lang/${this._locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }

  String trans(String key) {
    return this._sentences[key];
  }
}

class TranslationsDelegate extends LocalizationsDelegate<Localization> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) async {
    Localization localizations = new Localization(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}

class SpecifiedLocalizationDelegate
    extends LocalizationsDelegate<Localization> {
  final Locale overriddenLocale;

  const SpecifiedLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => this.overriddenLocale != null;

  @override
  Future<Localization> load(Locale locale) async {
    Localization localizations = new Localization(this.overriddenLocale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(SpecifiedLocalizationDelegate old) => true;
}
