import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer(this.colors, this.stops,
      {super.key,
        this.child,
        this.width,
        this.height,
        this.alignment,
        this.begin,
        this.end,
        this.blendMode,
        this.borderRadius});
  final List<Color> colors;
  final List<double> stops;
  final double? width;
  final double? height;
  final Widget? child;
  final Alignment? begin;
  final Alignment? end;
  final Alignment? alignment;
  final BlendMode? blendMode;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: width,
      height: height,
      alignment: alignment,
      /*
      *   color	Color?	设置背景颜色。
      *   image	DecorationImage?	设置背景图片，可以配置图片的重复模式、对齐方式等。
      *   gradient	Gradient?	设置渐变背景，可以是线性渐变、径向渐变等。
      *   border	BoxBorder?	设置边框，包括颜色、宽度、样式等。
      *   borderRadius	BorderRadius?	设置圆角边框，需要配合 border 属性使用，或者直接影响背景的圆角。
      *   boxShadow	List<BoxShadow>?	设置阴影效果，包括颜色、模糊半径、偏移等。
      *   shape	BoxShape	设置形状，支持矩形（默认）或圆形。
      *
      * */

      //设置背景颜色、背景图片、渐变、边框、阴影、圆角等效果。
      decoration: BoxDecoration(
        //设置渐变背景，可以是线性渐变、径向渐变等。
        gradient: LinearGradient(
          begin: begin ?? Alignment.centerLeft,
          end: end ?? Alignment.centerRight,
          colors: colors,
          stops: stops,
        ),
        backgroundBlendMode: blendMode,
        borderRadius: borderRadius,
      ),
      child: child,
    ),
  );
}

class HzGradient extends GradientContainer {
  const HzGradient(super.colors, super.stops,
      {super.key, super.child, super.width, super.height, super.alignment, super.blendMode, super.borderRadius});
}

class VtGradient extends GradientContainer {
  const VtGradient(super.colors, super.stops,
      {super.key, super.child, super.width, super.height, super.alignment, super.blendMode, super.borderRadius})
      : super(begin: Alignment.topCenter, end: Alignment.bottomCenter);
}
