import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wonders/main.dart';
import 'package:wonders/styles/styles.dart';
import  'package:sized_context/sized_context.dart';
import 'package:wonders/ui/common/app_scroll_be_havior.dart';


class WonderAppScaffold extends StatelessWidget {
  const WonderAppScaffold({super.key, required this.child});

  static AppStyle get style => _style;
  static AppStyle _style =  AppStyle();
  final Widget child;


  @override
  Widget build(BuildContext context) {
    //监听设备宽度，更新app样式
    final mq = MediaQuery.of(context);
    appLogic.handleAppSizeChanged(mq.size);

    Animate.defaultDuration = _style.times.fast;

    _style = AppStyle(screenSize: context.sizePx);

    return KeyedSubtree(
        key: ValueKey($styles.scale),
        child: Theme(
            data: $styles.colors.toThemeData(),
            child: DefaultTextStyle(
                style: $styles.text.body,
                child: ScrollConfiguration(
                    behavior: AppScrollBehavior(),
                    child: child
                ),
            )
        )
    );
  }
}
