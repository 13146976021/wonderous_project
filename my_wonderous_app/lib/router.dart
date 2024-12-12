

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wonders/logic/data/wonder_type.dart';
import 'package:wonders/main.dart';
import 'package:wonders/ui/app_scaffold.dart';
import 'package:wonders/ui/screens/home/wonders_home_screen.dart';
import 'package:wonders/ui/screens/intro/intro_screen.dart';
import 'package:wonders/ui/screens/page_not_found/page_not_found.dart';
import 'package:wonders/ui/screens/wonder_details/wonder_details_screen.dart';


/// 配置路由的简化别名
class ScreenPaths {
  static String splash = '/';
  static String intro = '/welcome';
  static String home = '/home';
  static String settings = '/settings';

  static String wonderDetails(WonderType type,{required int tabIndex}) => '$home/wonder/${type.name}?t=$tabIndex';
  static String video(String id) => _appendToCurrentPath('/video/$id');
  static String maps(WonderType type) => _appendToCurrentPath('/maps/${type.name}');


  static String _appendToCurrentPath(String newPath) {
    final newPathUri = Uri.parse(newPath);
    final currentUri = appRouter.routeInformationProvider.value.uri;
    Map<String, dynamic> params = Map.of(currentUri.queryParameters);
    params.addAll(newPathUri.queryParameters);
    Uri? loc = Uri(path: '${currentUri.path}/${newPathUri.path}'.replaceAll('//', '/'), queryParameters: params);
    return loc.toString();
  }

}


//创建路由管理器
final appRouter = GoRouter(
  //重定向路由
  redirect: _handleRedirect,
  //路由出错时调用
  errorPageBuilder: (context, state) => MaterialPage(child: PageNotFound(url: state.uri.toString())),

  //所有的路由页面
  routes: [
    //ShellRoute
    //定义具有共享 UI（如底部导航栏、侧边栏等）的路由结构。
    //允许子路由共享父路由的一部分 UI，同时能够独立地加载内容。
    ShellRoute(
      builder: (context, router, navigator) {
        return WonderAppScaffold(child: navigator);
      },
      routes: [
        AppRoute(ScreenPaths.splash, (_) => Container(color: $styles.colors.greyStrong,)),
        AppRoute(ScreenPaths.intro,(_) => const IntroScreen()),
        AppRoute(ScreenPaths.home,(_) => const HomeScreen(), routes: [
        _timelineRoute,
        _collectionRoute,
          AppRoute('wonder/:detailsType', (s){
            int tab = int.tryParse(s.uri.queryParameters['t'] ?? '') ?? 0;

            //返回对应的类型
            return WonderDetailsScreen(
                type:_parseWonderType(s.pathParameters['detailsType']),
                tabIndex: tab);
            },
            useFade: true
          ),
        ]),
      ],
    )
  ]
);




WonderType _parseWonderType(String? value){
  const fallback = WonderType.chichenItza;
  if(value == null) return fallback;
  return _tryParseWonderType(value) ?? fallback;

}

WonderType? _tryParseWonderType(String value) => WonderType.values.asNameMap()[value];



AppRoute get _timelineRoute {
  return AppRoute(
  'timeline',
  (s) => const Placeholder(),
  );
}

AppRoute get _collectionRoute {
  return AppRoute('collection', (s) => const Placeholder());
}


AppRoute get _artifactRoute => AppRoute('', (s) => const Placeholder());



String? get initialDeeplink => _initialDeeplink;
String? _initialDeeplink;


String? _handleRedirect(BuildContext context, GoRouterState state){
  if(!appLogic.isBootstrapComplete && state.uri.path != ScreenPaths.splash) {
    _initialDeeplink ??= state.uri.toString();
    return ScreenPaths.splash;
  }
  
  if(appLogic.isBootstrapComplete && state.uri.path == ScreenPaths.splash) {
    return ScreenPaths.home;
  }
  if (!kIsWeb) debugPrint('Navigate to: ${state.uri}');
  return null;
}


class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
  {
    List<GoRoute> routes = const [],this.useFade = false}):
      super(
        path: path,
        routes: routes,
        pageBuilder: (context, state)
        {

          final pageContent = Scaffold(
            body: builder(state),
            //屏蔽键盘弹出自动调整布局
            resizeToAvoidBottomInset: false);

          //是否使用动画
          if(useFade) {
            //
            return CustomTransitionPage
              (
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder: (context, animation, secondaryAnimation,child)
                {
                  return FadeTransition(opacity: animation,child: child,);
                });
          }
          //使用Cupertino风格
          return CupertinoPage(child: pageContent);}
      );
  final bool useFade;



}

