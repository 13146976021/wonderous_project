import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl_standalone.dart';
import 'package:wonders/main.dart';

//语言配置
class LocaleLogic {
  //Locale 一个配置语言的，可以设置语言和地图，比如'zh','中国'
  final Locale _defaultLocale = const Locale('en');

  //私有对象仅供内部使用
  AppLocalizations? _strings;

  //供外部调用对象
  //好处：防止外界修改
  AppLocalizations get strings => _strings!;

  bool get isLoaded => _strings != null;

  bool get isEnglish => strings.localeName == 'en';



  Future<void>load() async{
    //设置默认的地区
    Locale locale = _defaultLocale;
    //获取之前存储或者系统默认的语言信息。
    final localeCode = settingsLogic.currentLocale.value ?? await findSystemLocale();
    locale = Locale(localeCode.split('_')[0]);

    //判断改语言是否支持国际化
    if(AppLocalizations.supportedLocales.contains(locale) == false) {
      //不支持使用默认语言
      locale = _defaultLocale;
    }
    //更改语言配置信息
    settingsLogic.currentLocale.value = locale.languageCode;

    //根据语言
    _strings = await AppLocalizations.delegate.load(locale);

  }


  Future<void> loadIfChange(Locale locale) async {
    //判断当前的修改和之前记录的是否一致
    bool didChange = _strings?.localeName != locale.languageCode;
    //且是否支持当前需要修改的语言。
    if(didChange && AppLocalizations.supportedLocales.contains(locale)) {
      _strings = await AppLocalizations.delegate.load(locale);
    }
  }






}