import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/styles/wonders_color_extensions.dart';
import 'package:wonders/ui/common/fade_color_transition.dart';
import 'package:wonders/ui/common/wonder_illustration_config.dart';
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

      IllustrationPiece
    ];
  }



}
