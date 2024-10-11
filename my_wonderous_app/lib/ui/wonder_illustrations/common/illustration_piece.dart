import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wonders/assets.dart';
import 'package:wonders/styles/wonders_color_extensions.dart';
import 'package:wonders/ui/common/app_icons.dart';
import 'package:wonders/ui/wonder_illustrations/common/wonder_illustration_builder.dart';
class IllustrationPiece extends StatefulWidget {
  const IllustrationPiece({
    super.key,
    required this.fileName,
    required this.heightFactor,
    this.alignment = Alignment.center,
    this.minHeight,
    this.offset = Offset.zero,
    this.fractionalOffset,
    this.zoomAmt = 0,
    this.initialOffset = Offset.zero,
    this.enableHero = false,
    this.initialScale = 1,
    this.dynamicHzOffset = 0,
    this.top,
    this.bottom,
  });


  final String fileName;

  final Alignment alignment;

  final Offset initialOffset;

  final double initialScale;

  final double heightFactor;

  final double? minHeight;

  final Offset offset;

  final Offset? fractionalOffset;

  final double zoomAmt;

  final bool enableHero;

  final double dynamicHzOffset;

  final Widget Function(BuildContext context)? top;

  final Widget Function(BuildContext context)? bottom;


  @override
  State<IllustrationPiece> createState() => _IllustrationPieceState();
}

class _IllustrationPieceState extends State<IllustrationPiece> {
  double? aspectRatio;
  ui.Image? uiImage;


  @override
  Widget build(BuildContext context) {

    final wonderBuilder = context.watch<WonderIllustrationBuilderState>();
    final type = wonderBuilder.widget.wonderType;
    final imgPath =' ${type.assetPath}/${widget.fileName}';


    if(aspectRatio == null) {
      aspectRatio == 0;
      // rootBundle.load(img)
    }
    return Placeholder();



  }
}
