import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/ui/common/controls/app_loading_indicator.dart';
import 'package:wonders/ui/common/fullscreen_keyboard_listener.dart';


part 'widgets/_animated_cutout_overlay.dart';


class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key, this.imageSize, required this.collectionId, required this.wonderType});

  final Size? imageSize;
  final String collectionId;
  final WonderType wonderType;


  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {

  static const int _gridSize = 5;
  int _index = ((_gridSize * _gridSize) / 2).round();
  Offset _lastSwipeDir = Offset.zero;
  final double _scale = 1;
  bool _skipNextOffsetTween  = false;
  late Duration swipeDuration = $styles.times.med * 4;
  final _photoIds = ValueNotifier<List<String>>([]);

  int get _imgCount => pow(_gridSize, 2).round();

  late final List<FocusNode> _focusNodes = List.generate(_imgCount, (index) => FocusNode());
  final bool useClipPathWorkAroundForWeb = kIsWeb;







  bool _handleKeyDown(KeyDownEvent envet) {
    return false;
  }

  @override
  void initState() {
    super.initState();
    _initPhotoIds();

  }

  Future<void> _initPhotoIds() async {

    print('${widget.collectionId} + ==============');
    var ids = unsplashLogic.getCollectionPhotos(widget.collectionId);
    if(ids != null && ids.isNotEmpty) {
      while(ids.length < _imgCount) {
        ids.addAll(List.from(ids));
        if(ids.length > _imgCount) ids.length = _imgCount;

      }
    }

    setState(() {
      _photoIds.value = ids ?? [];
    });
  }



  @override
  Widget build(BuildContext context) {
    return FullscreenKeyboardListener(
        onKeyDown: _handleKeyDown,
        child: ValueListenableBuilder<List<String>>(
          valueListenable: _photoIds,
          builder: (_, value, __) {
            if(value.isEmpty) {
              return Center(child: AppLoadingIndicator());
            }

            Size imgSize = context.isLandscape
                ? Size(context.widthPx * .5, context.heightPx * .66)
                : Size(context.widthPx * .66 ,context.heightPx *.5 );
            imgSize = (widget.imageSize ?? imgSize) * _scale;

            final padding = $styles.instes.md;
            var gridOffset = _calculateCurrentOffset(padding, imgSize);
            gridOffset += Offset(0, -context.mq.padding.top / 2);

            final offsetTweenDuration = _skipNextOffsetTween ? Duration.zero : swipeDuration;
            final cutoutTweenDuration = _skipNextOffsetTween ? Duration.zero : swipeDuration * .5;

            return _AnimatedCutoutOverlay(
                cutoutSize: imgSize,
                animationKey: ValueKey(_index),
                swipeDir: _lastSwipeDir,
                opacity: _scale == 1 ? .7 : .5,
                enable: useClipPathWorkAroundForWeb == false,
                child: SafeArea(
                  bottom: false,
                  child: OverflowBox(
                    maxWidth: _gridSize * imgSize.width + padding * (_gridSize - 1),
                    maxHeight: _gridSize * imgSize.height + padding * (_gridSize - 1),
                    alignment: Alignment.center,
                    child: Container(
                      color: Colors.red,
                      child: Text("111"),
                    )
                  ),
                ),
            );
          },
        ));

  }

  Offset _calculateCurrentOffset(double padding, Size size) {
    double halfCount = (_gridSize / 2).floorToDouble();
    Size paddingImageSize = Size(size.width + padding , size.height + padding);
    final originOffset = Offset(halfCount * paddingImageSize.width, halfCount * paddingImageSize.height);

    int col = _index % _gridSize;
    int row = (_index / _gridSize).floor();
    final indexedOffset = Offset(-paddingImageSize.width * col, -paddingImageSize.height * row);

    return originOffset + indexedOffset;

  }
}
