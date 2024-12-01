import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MeasurableWidget extends SingleChildRenderObjectWidget {
  const MeasurableWidget({super.key,required this.onChange,required Widget super.child});
  final void Function(Size size) onChange;
  @override
  RenderObject createRenderObject(BuildContext context) =>MeasureSizeRenderObject(onChange);


}

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);

  void Function(Size size) onChange;

  Size _preSize = Size.zero;

  @override
  void performLayout() {
    // TODO: implement performLayout
    super.performLayout();
    Size newSize = child?.size ?? Size.zero;
    if(_preSize == newSize) return;
    _preSize = newSize;
    scheduleMicrotask(() => onChange(newSize));

  }




}