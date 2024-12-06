import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BlendMask extends SingleChildRenderObjectWidget {

  const BlendMask({required this.blendModes,this.opacity = 1.0, required Widget super.child});


  final List<BlendMode> blendModes;
  final double opacity;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderBlendMask(this.blendModes, this.opacity);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderBlendMask renderObject) {
    renderObject.blendModes = blendModes;
    renderObject.opacity = opacity;
  }


}


class RenderBlendMask extends RenderProxyBox {
  List<BlendMode> blendModes;
  double opacity;

  RenderBlendMask(this.blendModes, this.opacity);


  @override
  void paint(PaintingContext context, Offset offset) {
    context.setWillChangeHint();

    for(var blend in blendModes) {
      context.canvas.saveLayer(
        offset & size,
        Paint()
          ..blendMode = blend
          ..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255),
      );
    }

    super.paint(context, offset);
    context.canvas.restore();

  }
}