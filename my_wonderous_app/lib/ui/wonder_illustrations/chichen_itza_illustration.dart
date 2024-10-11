import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/styles/wonders_color_extensions.dart';
import 'package:wonders/ui/common/fade_color_transition.dart';
import 'package:wonders/ui/common/wonder_illustration_config.dart';
import 'package:wonders/ui/wonder_illustrations/common/illustration_piece.dart';
import 'package:wonders/ui/wonder_illustrations/common/paint_textures.dart';


class ChichenItzaIllustration extends StatelessWidget {
  ChichenItzaIllustration({super.key,required this.config});

  final WonderIllustrationConfig config;
  final asssetPath = WonderType.chichenItza.assetPath;
  final fgColor = WonderType.chichenItza.fgColor;


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  List<Widget> _buildBg(BuildContext context,Animation<double> anim){
    return [
      FadeColorTransition(animation: anim, color: fgColor),
      Positioned.fill(
          child: IllustrationTexture(
            ImagePaths.roller2,
            color: Color(0xffDC762A),
            opacity: anim.drive(Tween(begin: 0,end: 0.5)),
            flipY: true,
            scale: config.shortMode ? 4 : 1.15,
          ),
      ),

      // IllustrationPiece

      IllustrationPiece(
          fileName: "sun.png",
          initialOffset: Offset(0, 50),
          enableHero: true,
          minHeight: 200,
          fractionalOffset: Offset(.55, config.shortMode ? .2 : -.35),
          heightFactor: .4),

    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) {
    return [
      Transform.translate(
        offset: Offset(0, config.shortMode ? 70 : -30),
        child: const IllustrationPiece(
            fileName: 'chichen.png',
            minHeight: 180,
            zoomAmt: 01,
            enableHero: true,
            heightFactor: .4),
      ),
    ];
  }

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      const IllustrationPiece(
          fileName: "foreground-right.png",
          alignment: Alignment.bottomCenter,
          initialOffset: Offset(20, 40),
          initialScale: .95,
          heightFactor: .4,
          fractionalOffset: Offset(.5, - .1),
          zoomAmt: .1,
        dynamicHzOffset: 250,
        ),

      const IllustrationPiece(
        fileName: 'foreground-left.png',
        alignment: Alignment.bottomCenter,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .65,
        fractionalOffset: Offset(-.4, .2),
        zoomAmt: .25,
        dynamicHzOffset: -250,
      ),
      const IllustrationPiece(
        fileName: 'top-left.png',
        alignment: Alignment.topLeft,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .65,
        fractionalOffset: Offset(-.4, -.4),
        zoomAmt: .05,
        dynamicHzOffset: 100,
      ),
      const IllustrationPiece(
        fileName: 'top-right.png',
        alignment: Alignment.topRight,
        initialOffset: Offset(20, 40),
        initialScale: .95,
        heightFactor: .65,
        fractionalOffset: Offset(.35, -.4),
        zoomAmt: .05,
        dynamicHzOffset: -100,
      ),
    ];
  }



}
