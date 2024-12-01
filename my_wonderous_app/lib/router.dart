

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wonders/logic/data/wonder_type.dart';
import 'package:wonders/main.dart';
import 'package:wonders/ui/app_scaffold.dart';
import 'package:wonders/ui/screens/home/wonders_home_screen.dart';
import 'package:wonders/ui/screens/page_not_found/page_not_found.dart';
import 'package:wonders/ui/screens/wonder_details/wonder_details_screen.dart';


class ScreenPaths {
  static String splash = '/';
  static String intro = '/welcome';
  static String home = '/home';
  static String settings = '/settings';

  static String wonderDetails(WonderType type,{required int tabIndex}) => '$home/wonder/${type.name}?t=$tabIndex';
  
}

final appRouter = GoRouter(
  redirect: _handleRedirect,
  errorPageBuilder: (context, state) => MaterialPage(child: PageNotFound(url: state.uri.toString())),
  routes: [
    ShellRoute(
      builder: (context, router, navigator) {
        return WonderAppScaffold(child: navigator);
      },
      routes: [
        AppRoute(ScreenPaths.splash, (_) => Container(color: $styles.colors.greyStrong,)),
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
            resizeToAvoidBottomInset: false);

          if(useFade) {
            return CustomTransitionPage
              (
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder: (context, animation, secondaryAnimation,child)
                {
                  return FadeTransition(opacity: animation,child: child,);
                });
          }

          return CupertinoPage(child: pageContent);
        }
      );
  final bool useFade;



}

