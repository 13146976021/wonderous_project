import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/ui/common/utils/context_utils.dart';

class AnimatedListItem extends StatelessWidget {
  const AnimatedListItem({super.key, required this.scrollPos, required this.builder});
  final ValueNotifier<double> scrollPos;
  final Widget Function(BuildContext context, double pctVisible) builder;


  @override
  Widget build(BuildContext context) {
    return Animate().toggle(
        builder: (_, value, __) => ValueListenableBuilder(
            valueListenable: scrollPos,
            builder: (_, value, __) {
              return LayoutBuilder(
                  builder: (_, constraints) {
                    Offset? pos = ContextUtils.getGlobalPos(context);
                    final yPos = pos?.dy;
                    final widgetHieght = constraints.maxHeight;
                    double pctVisible = 0;
                    if(yPos != null) {
                      final amtVisible = context.heightPx - yPos;
                      pctVisible = (amtVisible / widgetHieght * .5).clamp(0 ,1);
                    }
                    return builder(context, pctVisible);

                  });
            }));
  }
}


class ScalingListItem extends StatelessWidget {
  const ScalingListItem({
    super.key,
    required this.scrollpos,
    required this.child
  });

  final ValueNotifier<double> scrollpos;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedListItem(
        scrollPos: scrollpos,
        builder: (_, pctVisible) {
          final scale = 1.35 - pctVisible * .35;
          return ClipRect(
            child: Transform.scale(scale: scale,child:  child,)

          );
        });
  }
}
