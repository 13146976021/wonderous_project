

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wonders/logic/data/wonder_type.dart';
import 'package:wonders/main.dart';
import 'package:wonders/ui/app_scaffold.dart';
import 'package:wonders/ui/screens/page_not_found/page_not_found.dart';


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
        // AppRoute(ScreenPaths.splash, (_) => Container(color: $styles.colors.greyStrong,)),
        AppRoute(ScreenPaths.splash, (_) => PageNotFound(url: "url")),
        AppRoute(ScreenPaths.home, (_) => Homescrenn)

      ]

    )
  ]

  
);


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