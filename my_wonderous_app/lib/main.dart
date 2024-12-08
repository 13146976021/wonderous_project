import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:go_router/go_router.dart';
import 'package:wonders/logic/app_logic.dart';
import 'package:wonders/logic/artifact_api_logic.dart';
import 'package:wonders/logic/collectibles_logic.dart';
import 'package:wonders/logic/locale_logic.dart';
import 'package:wonders/logic/native_widget_service.dart';
import 'package:wonders/logic/settings_logic.dart';
import 'package:wonders/logic/unsplash_logic.dart';
import 'package:wonders/logic/wonders_logic.dart';
import 'package:wonders/router.dart';
import 'package:wonders/styles/styles.dart';
import 'package:wonders/ui/app_scaffold.dart';
import 'package:wonders/ui/common/Appshortcuts.dart';

//使用异步加载main函数是为了处理一些耗时操作
void main() async {

  //FlutterNativeSplash插件或框架需要访问 Flutter 的引擎或绑定层
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //插件防止应用程序过早的关闭启动页，即时应用加载完成也可继续显示启动页。
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //仅在web平台有效
  GoRouter.optionURLReflectsImperativeAPIs = true;

  //注册单例的类
  registerSingletons();

  //运行app
  runApp(WondersApp());

  //各种初始化设置，展示轮播图
  await appLogic.bootstrap();

  FlutterNativeSplash.remove();
}


class WondersApp extends StatelessWidget with GetItMixin{
   WondersApp({super.key});


  @override
  Widget build(BuildContext context) {

    print("WondersApp =============");
    final local = watchX((SettingsLogic s) => s.currentLocale);


    return MaterialApp.router(
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      locale: local == null ? null : Locale(local),

      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.routerDelegate,
      shortcuts: Appshortcuts.defaults,
      theme: ThemeData(fontFamily: $styles.text.body.fontFamily, useMaterial3: true),
      color: $styles.colors.black,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate

      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}


void registerSingletons() {
GetIt.I.registerLazySingleton<AppLogic>(() => AppLogic());
GetIt.I.registerLazySingleton<SettingsLogic>(() => SettingsLogic());
GetIt.I.registerLazySingleton<LocaleLogic>(() => LocaleLogic());
GetIt.I.registerLazySingleton<WondersLogic>(() => WondersLogic());

GetIt.I.registerLazySingleton<UnsplashLogic>(() => UnsplashLogic());
GetIt.I.registerLazySingleton<NativeWidgetService>(() => NativeWidgetService());
GetIt.I.registerLazySingleton<CollectiblesLogic>(() => CollectiblesLogic());
GetIt.I.registerLazySingleton<ArtifactAPILogic>(() => ArtifactAPILogic());
}

AppLogic get appLogic => GetIt.I.get<AppLogic>();
SettingsLogic get settingsLogic => GetIt.I.get<SettingsLogic>();
LocaleLogic get localeLogic => GetIt.I.get<LocaleLogic>();
WondersLogic get wondersLogic => GetIt.I.get<WondersLogic>();
CollectiblesLogic get collectiblesLogic => GetIt.I.get<CollectiblesLogic>();
ArtifactAPILogic get artifactLogic => GetIt.I.get<ArtifactAPILogic>();
UnsplashLogic get unsplashLogic => GetIt.I.get<UnsplashLogic>();



AppStyle get $styles => WonderAppScaffold.style;
AppLocalizations get $strings =>  localeLogic.strings;

