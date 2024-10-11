import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/find_locale.dart';
import 'package:wonders/main.dart';

class LocaleLogic {
  final Locale _defaultLocale = Locale('en');

  AppLocalizations? _strings;
  AppLocalizations get strings => _strings!;

  bool get isLoaded => _strings != null;

  bool get isEnglish => strings.localeName == 'en';



  Future<void>load() async{
    Locale locale = _defaultLocale;
    final localeCode = settingsLogic.currentLocale.value ?? await findSystemLocale();
    locale = Locale(localeCode.split('_')[0]);

    if(AppLocalizations.supportedLocales.contains(locale) == false) {
      locale = _defaultLocale;
    }
    settingsLogic.currentLocale.value = locale.languageCode;
    _strings = await AppLocalizations.delegate.load(locale);

  }


  Future<void> loadIfChange(Locale locale) async {
    bool didChange = _strings?.localeName != locale.languageCode;
    if(didChange && AppLocalizations.supportedLocales.contains(locale)) {
      _strings = await AppLocalizations.delegate.load(locale);
    }
  }






}