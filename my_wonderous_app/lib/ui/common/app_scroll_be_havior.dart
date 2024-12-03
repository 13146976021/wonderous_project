import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:wonders/logic/common/platform_info.dart';

class AppScrollBehavior extends ScrollBehavior {
  @override
  // TODO: implement dragDevices
  Set<PointerDeviceKind> get dragDevices {
    final devices = Set<PointerDeviceKind>.from(super.dragDevices);
    devices.add(PointerDeviceKind.mouse);
    return devices;
  }


  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // TODO: implement getScrollPhysics
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {

    if (PlatformInfo.isMobile) return child;
    return RawScrollbar(
      controller: details.controller,
      thumbVisibility: PlatformInfo.isDesktopOrWeb,
      thickness: 8,
      interactive: true,
      child: child,
    );
  }
}