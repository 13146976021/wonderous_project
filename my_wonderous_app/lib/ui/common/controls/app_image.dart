import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/common/retry_image.dart';
import 'package:wonders/ui/common/controls/app_loading_indicator.dart';

import '../../../common_libs.dart';

class AppImage extends StatefulWidget {
  const AppImage({
    super.key,
    required this.image,
    this.fit = BoxFit.scaleDown,
    this.alignment = Alignment.center,
    this.duration,
    this.syncDuration,
    this.distrator = false,
    this.progress = false,
    this.color,
    this.scale});

  final ImageProvider? image;
  final BoxFit fit;
  final Alignment alignment;
  final Duration? duration;
  final Duration? syncDuration;
  final bool distrator;
  final bool progress;
  final Color? color;
  final double? scale;


  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  ImageProvider? _displayImage;
  ImageProvider? _sourceImage;

  @override
  void didChangeDependencies() {
    _updateImage();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AppImage oldWidget) {
    _updateImage();
    super.didUpdateWidget(oldWidget);
  }

  void _updateImage() {
    if(widget.image == _sourceImage) return;
    _sourceImage = widget.image;
    _displayImage = _capImageSize(_addRetry(_sourceImage));

  }

  @override
  Widget build(BuildContext context) {
    return ImageFade(
      image: _displayImage,
      fit: widget.fit,
      alignment: widget.alignment,
      duration: widget.duration ?? $styles.times.fast,
      syncDuration: widget.syncDuration ?? 0.ms,
      loadingBuilder: (_ ,value, __){
        if(!widget.distrator && !widget.progress) return SizedBox();
        return Center(child: AppLoadingIndicator(value: widget.progress ? value : null, color: widget.color,),);

      },
      errorBuilder: (_, __) => Container(
        padding: EdgeInsets.all($styles.instes.xs),
        alignment: Alignment.center,
        child: LayoutBuilder(builder: (_, constraints) {
          double size = min(constraints.biggest.width, constraints.biggest.height);
          if(size < 16) return SizedBox();
          return  Icon(
            Icons.image_not_supported_outlined,
            color: $styles.colors.white.withOpacity(0.1),
            size: min(size, $styles.instes.lg),
          );
        },),
      ),

    );
  }

  ImageProvider? _addRetry(ImageProvider? image) {
    return image == null ? image : RetryImage(image);
  }

  ImageProvider?  _capImageSize(ImageProvider? image) {
    if(image == null || widget.scale == null) return image;
    final MediaQueryData mq = MediaQuery.of(context);
    final Size size = mq.size * mq.devicePixelRatio * widget.scale!;
    return ResizeImage(image, width:  size.width.round());

  }
}
