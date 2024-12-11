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

  //移除插件，移除启动图，显示app内容。
  FlutterNativeSplash.remove();
}


class WondersApp extends StatelessWidget with GetItMixin{
   WondersApp({super.key});


  @override
  Widget build(BuildContext context) {

    //获取s.currentLocale的值，并且当值发生改变时会触发markNeedsBuild函数刷新当前页面
    final local = watchX((SettingsLogic s) => s.currentLocale);

    return MaterialApp.router(

      //捕获路由变化。从平台接收到原始的路由信息。如 /home
      routeInformationProvider: appRouter.routeInformationProvider,
      //解析路由信息。将路径 /home 解析为应用程序的路由状态对象（如 MyRouteState.home()）。
      routeInformationParser: appRouter.routeInformationParser,
      //根据解析后的路由状态构建和更新导航堆栈（如 Navigator）。
      routerDelegate: appRouter.routerDelegate,

      //默认使用的语言
      locale: local == null ? null : Locale(local),
      //是否显示debug横幅
      debugShowCheckedModeBanner: false,
      //键盘功能
      shortcuts: Appshortcuts.defaults,
      //主题
      theme: ThemeData(fontFamily: $styles.text.body.fontFamily, useMaterial3: true),
      //默认颜色
      color: $styles.colors.black,
      //
      localizationsDelegates: const [
        //自定义本地化代理
        AppLocalizations.delegate,
        // 支持 Material 风格组件
        GlobalMaterialLocalizations.delegate,
        //支持基本的 Widget 文本本地化
        GlobalWidgetsLocalizations.delegate,
        // 支持 Cupertino 风格组件
        GlobalCupertinoLocalizations.delegate
      ],
      //Flutter 应用支持哪些语言。
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

