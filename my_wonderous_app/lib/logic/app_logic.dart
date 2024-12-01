import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:wonders/assets.dart';
import 'package:wonders/logic/common/platform_info.dart';
import 'package:wonders/logic/locale_logic.dart';
import 'package:wonders/main.dart';
import 'package:wonders/ui/common/page_routes.dart';
class AppLogic {



  ///app的大小
  Size _appSize = Size.zero;

  //判断是否是第一次进入app
  bool isBootstrapComplete = true;

  //默认横屏和竖屏
  List<Axis> supportedOrientations = [Axis.vertical, Axis.horizontal];


  //接受设备支持的方向
  List<Axis>? _supportedOrientationsOverride;

  set supportedOrientationsOverride(List<Axis>? value) {
    if (_supportedOrientationsOverride != value) {
      _supportedOrientationsOverride = value;
      _updateSystemOrientation();
    }
  }
  bool shouldUseNavRail() => _appSize.width > _appSize.height && _appSize.height > 250;


  Future<void> bootstrap() async {
    debugPrint("bootsrap start");
    if(PlatformInfo.isDesktop) {
      //如果是桌面端，设置最小宽高
      await DesktopWindow.setMinWindowSize($styles.sizes.minAppSize);
    }





    i(kIsWeb) {
      //请求web自动启用无障碍功能
      WidgetsFlutterBinding.ensureInitialized().ensureSemantics();
    }


    await AppBitmaps.init();
    await localeLogic.load();

    wondersLogic.init();



    if(!kIsWeb && PlatformInfo.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }

  }

  Display get display => PlatformDispatcher.instance.displays.first;


  Future<T?> showFullscreenDialogRoute<T>(BuildContext context, Widget child, {bool transparent = false}) async {
    return await Navigator.of(context).push<T>(
      PageRoutes.dialog<T>(child, duration: $styles.times.pageTransition),
    );
  }

  void handleAppSizeChanged(Size appSize) {
    bool isSmall = display.size.shortestSide / display.devicePixelRatio < 600;
    supportedOrientations = isSmall ? [Axis.vertical] : [Axis.vertical, Axis.horizontal];
    _updateSystemOrientation();
    _appSize = appSize;
  }


  //更新系统的方向Orientation指的是方向
  void _updateSystemOrientation() {
    final axisList = _supportedOrientationsOverride ?? supportedOrientations;
    //debugPrint('updateDeviceOrientation, supportedAxis: $axisList');
    final orientations = <DeviceOrientation>[];
    if (axisList.contains(Axis.vertical)) {
      orientations.addAll([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    if (axisList.contains(Axis.horizontal)) {
      orientations.addAll([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    SystemChrome.setPreferredOrientations(orientations);
  }
}
