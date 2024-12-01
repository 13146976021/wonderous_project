import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wonders/assets.dart';
import 'package:wonders/common_libs.dart';
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
    final imgPath ='${type.assetPath}/${widget.fileName}';


    if(aspectRatio == null) {
      aspectRatio == 0;
      rootBundle.load(imgPath)
          .then((img)async {
            uiImage = await decodeImageFromList(img.buffer.asUint8List());
            if(!mounted) return;
            setState(() {
              aspectRatio = uiImage!.width / uiImage!.height;
            });
          });
    }
    return Align(
      alignment: widget.alignment,
      child: LayoutBuilder(
        key: ValueKey(aspectRatio),
        builder: (_, constraints) {
          final anim = wonderBuilder.anim;
          final curvedAnim = Curves.easeOut.transform(anim.value);
          final config = wonderBuilder.widget.config;
          Widget img = Image.asset(imgPath, opacity: anim,fit: BoxFit.fitHeight);
          img = OverflowBox(maxWidth: 2500,child:img);

          final double introZoom = (widget.initialScale - 1) * (1 - curvedAnim);

          final double height = max(widget.minHeight ?? 0, constraints.maxHeight * widget.heightFactor);

          Offset finalTranslation = widget.offset;
          if(widget.initialOffset != Offset.zero) {
            finalTranslation += widget.initialOffset * (1 - curvedAnim);
          }


          final dynamicOffsetAmt = ((context.widthPx - 400) / 1100).clamp(0, 1);
          finalTranslation += Offset(dynamicOffsetAmt * widget.dynamicHzOffset, 0);


          final width = height * (aspectRatio ?? 0);
          if(widget.fractionalOffset !=  null) {
            finalTranslation += Offset(
              widget.fractionalOffset!.dx * width,
              height * widget.fractionalOffset!.dy,
            );
          }

          Widget? content;

          if(uiImage != null) {
            content = Transform.translate(
                offset: finalTranslation,
                child: Transform.scale(
                  scale: 1 + (widget.zoomAmt * config.zoom) + introZoom,
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: img,
                  ),
                ),
            );
          }

          return Stack(
            children: [
              if(widget.bottom != null) Positioned.fill(child: widget.bottom!.call(context)),
              if(uiImage != null) ...[
                widget.enableHero ? Hero(tag: '$type-${widget.fileName}', child: content!) : content!,
                if(widget.top != null) Positioned.fill(child: widget.top!.call(context)),
              ]
            ],
          );
        },
      ),
    );



  }
}
