import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/ui/common/wonder_illustration_config.dart';

class WonderIllustrationBuilder extends StatefulWidget {
  const WonderIllustrationBuilder({
    super.key,
    required this.config,
    required this.fgBuilder,
    required this.mgBuilder,
    required this.bgBuilder,
    required this.wonderType,
  });
  final List<Widget> Function(BuildContext context, Animation<double> animation ) fgBuilder;
  final List<Widget> Function(BuildContext context, Animation<double> animation ) mgBuilder;
  final List<Widget> Function(BuildContext context, Animation<double> animation ) bgBuilder;

  final WonderIllustrationConfig config;
  final WonderType wonderType;



  @override
  State<WonderIllustrationBuilder> createState() => WonderIllustrationBuilderState();
}

class WonderIllustrationBuilderState extends State<WonderIllustrationBuilder>  with SingleTickerProviderStateMixin{

  late final anim = AnimationController(vsync: this,duration: $styles.times.med * .75)
  ..addListener(() => setState((){}) );

  bool get isShowing => widget.config.isShowing;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(isShowing) anim.forward(from: 0);
  }


  @override
  void didUpdateWidget(covariant WonderIllustrationBuilder oldWidget) {
    if(isShowing != oldWidget.config.isShowing) {
      isShowing ? anim.forward(from: 9) : anim.reverse(from: 1);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    anim.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(anim.value == 0 && widget.config.enableAnims) return SizedBox.expand();
    Animation<double> animation = widget.config.enableAnims ? anim : AlwaysStoppedAnimation(1);

    return Provider<WonderIllustrationBuilderState>.value(
      value: this,
      child: Stack(
        key: ValueKey(animation.value == 0),
        children: [
          if(widget.config.enableBg) ...widget.bgBuilder(context, animation),
          if(widget.config.enableMg) ...widget.mgBuilder(context, animation),
          if(widget.config.enableFg) ...widget.fgBuilder(context, animation),
        ],
      ),
    );
  }
}
