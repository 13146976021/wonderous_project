import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ContextUtils {
  static Offset? getGlobalPos(BuildContext context, [Offset offset = Offset.zero]){
    final rb = context.findRenderObject() as RenderBox?;
    if(rb?.hasSize == true) {
      return rb?.localToGlobal(offset);
    }
  }

  static Size? getSize(BuildContext context){
    final rb = context.findRenderObject() as RenderBox?;
    if(rb?.hasSize == true) {
      return rb?.size;
    }
  }
}