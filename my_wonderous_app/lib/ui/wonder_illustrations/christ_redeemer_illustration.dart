import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/styles/wonders_color_extensions.dart';
import 'package:wonders/ui/common/fade_color_transition.dart';
import 'package:wonders/ui/common/wonder_illustration_config.dart';
import 'package:wonders/ui/wonder_illustrations/common/illustration_piece.dart';
import 'package:wonders/ui/wonder_illustrations/common/paint_textures.dart';
import 'package:wonders/ui/wonder_illustrations/common/wonder_illustration_builder.dart';

class ChristRedeemerIllustration extends StatelessWidget {
  ChristRedeemerIllustration({super.key, required this.config});




  final WonderIllustrationConfig config;

  final String assetPath = WonderType.christRedeemer.assetPath;

  final fgColor = WonderType.christRedeemer.fgColor;

  @override
  Widget build(BuildContext context) {
    return WonderIllustrationBuilder(
        config: config,
        fgBuilder: _buildFg,
        mgBuilder: _buildMg,
        bgBuilder: _buildBg,
        wonderType: WonderType.christRedeemer
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      FadeColorTransition(animation: anim, color: fgColor),
      Positioned.fill(child: IllustrationTexture (
        ImagePaths.roller1,
        color: Color(0xffFAE5C8),
        flipX: false,
        opacity: anim.drive(Tween(begin: 0, end: 0.8)),
        scale: config.shortMode ? 3.5 : 1.15,
        )
      ),

      IllustrationPiece(fileName: 'sun.png',
          initialOffset: Offset(0, 50),
          enableHero: true,
          minHeight: 120,
          fractionalOffset: Offset(.7,config.shortMode ? -.5 : -1.35),
          heightFactor: .25),


    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim ){
    return [
      ClipRect(
        clipBehavior: config.shortMode ? Clip.hardEdge : Clip.none,
        child:  IllustrationPiece(
          fileName: 'redeemer.png',
          enableHero: true,
          heightFactor: 1,
          alignment: Alignment.bottomCenter,
          fractionalOffset: Offset(0, config.shortMode ? .5 : 1),
          zoomAmt: .7,
        ),
      )

    ];

  }



  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      const IllustrationPiece(
        fileName: 'foreground-left.png',
        alignment: Alignment.bottomCenter,
        initialScale: .95,
        initialOffset: Offset(-140, 60),
        heightFactor: .65,
        fractionalOffset: Offset(-.25, .05),
        zoomAmt: .15,
        dynamicHzOffset: -100,
      ),
      const IllustrationPiece(
        fileName: 'foreground-right.png',
        alignment: Alignment.bottomCenter,
        initialOffset: Offset(120, 40),
        initialScale: .9,
        heightFactor: .55,
        fractionalOffset: Offset(.35, .2),
        zoomAmt: .1,
        dynamicHzOffset: 100,
      ),
    ];
  }





}
