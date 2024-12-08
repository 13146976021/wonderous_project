part of '../editorial_screen.dart';

class _ScrollingContent extends StatelessWidget {
  const _ScrollingContent(this.data,{super.key,   required this.scrollPos, required this.sectionNotifier});

  final WonderData data;
  final ValueNotifier<double> scrollPos;
  final ValueNotifier<int> sectionNotifier;


  String _fixNewlines(String text) {
    const nl = '\n';
    final chunks = text.split(nl);
    while(chunks.last == nl) {
      chunks.removeLast();
    }

    chunks.removeWhere((element) => element.trim().isEmpty);
    final result = chunks.join('$nl$nl');
    return result;
  }

  @override
  Widget build(BuildContext context) {

    Widget buildText(String value) => Focus(child: Text(_fixNewlines(value), style: $styles.text.body,));

    Widget buildDropCapText(String value) {
      final TextStyle dropStyle = $styles.text.dropCase;
      final TextStyle bodyStyle = $styles.text.body;
      final String dropChar = value.substring(0, 1);
      final textScale = MediaQuery.of(context).textScaleFactor;
      final double dropCapWidth = StringUtils.measure(dropChar, dropStyle).width * textScale;
      final bool skipCap = !localeLogic.isEnglish;

      return Semantics(
        label: value,
        child:  ExcludeSemantics(
          child: !skipCap
          ? DropCapText(
              _fixNewlines(value).substring(1),
            dropCap: DropCap(
              width: dropCapWidth,
              height: $styles.text.body.fontSize! * $styles.text.body.height! * 2,
              child: Transform.translate(
                  offset: Offset(0, bodyStyle.fontSize! * (bodyStyle.height! - 1) - 2),
                  child: Text(
                    dropChar,
                    overflow: TextOverflow.visible,
                    style: $styles.text.dropCase.copyWith(
                      color: $styles.colors.accent1,
                      height: 1
                    ),
                  ),
              ),
            ),
            style: $styles.text.body,
            dropCapPadding: const EdgeInsets.only(right: 6),
            dropCapStyle: $styles.text.dropCase.copyWith(
              color: $styles.colors.accent1,
              height: 1

            ),
          )
          : Text(value, style: bodyStyle,),
        ),
      );
    }

    Widget buildHiddenCollectible({required int slot}) {
      List<WonderType> getTypeForSlot(solt) {
        return switch(solt) {
          0 => [WonderType.chichenItza, WonderType.colosseum],
          1 => [WonderType.pyramidsGiza, WonderType.petra],
          2 => [WonderType.machuPicchu, WonderType.chichenItza],
          _ => [WonderType.tajMahal, WonderType.greatWall],
        };

      }


      return HiddentCollectible(data.type, index: 0, size: 120, matches: getTypeForSlot(slot));
    }


    return SliverBackgroundColor(
        color: $styles.colors.offWhite,
      sliver: SliverPadding(
        padding: EdgeInsets.symmetric(vertical: $styles.instes.md),
        sliver: SliverList(
          delegate: SliverChildListDelegate.fixed([
            
            Center(
              child: SizedBox(
                width: $styles.sizes.maxContentWidth1,
                child: Column(children: [
                  ..._contentSection([

                    Center(child: buildHiddenCollectible(slot: 0),),
                    buildDropCapText(data.historyInfo1),
                    _CollapsingPullQuoteImage(scrollPos: scrollPos, data: data),
                    Center(child: buildHiddenCollectible(slot: 1),),
                    _Callout(data.callout1),
                    buildText(data.historyInfo2),
                    _SectionDivider(scrollPos, sectionNotifier, index: 1),
                    buildDropCapText(data.constructionInfo1),
                    Center(child: buildHiddenCollectible(slot: 2)),
                    _YouTubeThumbnail(id: data.videoId, caption: data.videoCaption),

                  ]),
                  Gap($styles.instes.md),
                  ..._contentSection([
                    Gap($styles.instes.xs),
                    _Callout(data.callout2),
                    buildText(data.constructionInfo2),

                    _SlidingImageStack(scrollPos: scrollPos, type: data.type),
                    _SectionDivider(scrollPos, sectionNotifier, index: 2),

                    buildDropCapText(data.locationInfo1),
                    _LargeSimpleQuotete(text: data.pullQuote2, author: data.pullQuote2Author),
                    buildText(data.locationInfo2),

                  ]),

                  Gap($styles.instes.md),
                  _MapsThumbnail(data),
                  Gap($styles.instes.md),
                  ..._contentSection([Center(child: buildHiddenCollectible(slot: 3),)]),

                ],),
              ),
            ),

          ]),
        ),
        
      ),
    );
  }

  List<Widget> _contentSection(List<Widget> children) {
    return [
      for(int i = 0; i < children.length - 1; i++) ...[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: $styles.instes.md),
            child: children[i],
        ),
        Gap($styles.instes.md),
      ],
      Padding(
        padding: EdgeInsets.symmetric(horizontal: $styles.instes.md),
        child: children.last,
      )
    ];
    
  }
}



class SliverBackgroundColor extends SingleChildRenderObjectWidget {
   SliverBackgroundColor({
    super.key,
    required this.color,
    Widget? sliver,
  }) : super(child: sliver);


  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverBackgroundColor(color);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderSliverBackgroundColor renderObject) {
    // TODO: implement updateRenderObject
    renderObject.color = color;
  }


}

class RenderSliverBackgroundColor extends RenderProxySliver {
  RenderSliverBackgroundColor(this._color);

  Color _color;
  Color get color => _color;

  set color(Color value) {
    if(value == color){
      return ;
    }
    _color = color;
    markNeedsPaint();
  }
  @override
  void paint(PaintingContext context, Offset offset){

    if(child != null && child!.geometry!.visible) {
      final SliverPhysicalParentData childParentData = child!.parentData! as SliverPhysicalParentData;

      final Rect childRect =
          offset + childParentData.paintOffset & Size(constraints.crossAxisExtent, child!.geometry!.paintExtent);
      context.canvas.drawRect(childRect, Paint()..style = PaintingStyle.fill ..color = color);
      context.paintChild(child!, offset + childParentData.paintOffset);

    }
  }


}


class _YouTubeThumbnail extends StatelessWidget {
  const _YouTubeThumbnail({super.key, required this.id, required this.caption});
  final String id;
  final String caption;

  String get imageUrl => 'https://www.wonderous.info/youtube/$id.jpg';


  @override
  Widget build(BuildContext context) {

    void handlePressed() => context.go(ScreenPaths.video(id));

    return MergeSemantics(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          children: [
            AppBtn.basic(
                onPressed: handlePressed,
                semanticLabel: $strings.scrollingContentSemanticYoutube,
                child: Stack(
                  children: [
                    AppImage(image: NetworkImage(imageUrl),fit: BoxFit.cover, scale: 1.0,),
                    Positioned.fill(child: Center(child: Container(
                      padding: EdgeInsets.all($styles.instes.xs),
                      decoration: BoxDecoration(
                        color: $styles.colors.black.withOpacity(0.66),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: $styles.colors.white,
                        size: $styles.instes.xl,
                      ),
                    ),))
                  ],
                ),
            ),

            Gap($styles.instes.xs),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: $styles.instes.md),
              child: Text(caption,style: $styles.text.caption,),),



          ],
        ),
      ),
    );
  }
}

// class _MapsThumbnail extends StatefulWidget {
//   const _MapsThumbnail(this.data,{super.key});
//
//   final WonderData data;
//
//   @override
//   State<_MapsThumbnail> createState() => _MapsThumbnailState();
// }
//
// class _MapsThumbnailState extends State<_MapsThumbnail> {
//
//   CameraPosition get startPos => CameraPosition(target: LatLng(widget.data.lat,widget.data.lng),zoom: 3);
//
//   @override
//   Widget build(BuildContext context) {
//     void handlePressed() => context.go(ScreenPaths.maps(widget.data.type));
//     if(PlatformInfo.isDesktop) return SizedBox.shrink();
//
//     return AspectRatio(
//         aspectRatio: 1.65,
//         child: MergeSemantics(
//           child: Column(
//             children: [
//               Flexible(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular($styles.corners.md),
//                     child: AppBtn.basic(
//                         onPressed: handlePressed,
//                         semanticLabel: $strings.scrollingContentSemanticOpen,
//                         child: Stack(
//                           children: [
//                             const Positioned.fill(child: ColoredBox(color: Colors.transparent,)),
//                             IgnorePointer(
//                               child: GoogleMap(
//                                 markers: {getMapsMarker(startPos.target)},
//                                 zoomControlsEnabled: false,
//                                 mapType: MapType.normal,
//                                 mapToolbarEnabled: false,
//                                 initialCameraPosition: startPos,
//                                 myLocationButtonEnabled: false,
//
//                               ),
//                             )
//                           ],
//                         ),
//                     ),
//                   ),
//               ),
//
//               Gap($styles.instes.xs),
//               Semantics(
//                 sortKey: OrdinalSortKey(0),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: $styles.instes.md),
//                   child: Text(widget.data.mapCaption,style: $styles.text.caption,),
//                 ),
//               )
//             ],
//           ),
//         ),
//     );
//   }
// }

class _MapsThumbnail extends StatefulWidget {
  const _MapsThumbnail(this.data, {super.key});
  final WonderData data;

  @override
  State<_MapsThumbnail> createState() => _MapsThumbnailState();
}

class _MapsThumbnailState extends State<_MapsThumbnail> {
  CameraPosition get startPos => CameraPosition(target: LatLng(widget.data.lat, widget.data.lng), zoom: 3);

  @override
  Widget build(BuildContext context) {
    void handlePressed() => context.go(ScreenPaths.maps(widget.data.type));
    if (PlatformInfo.isDesktop) return SizedBox.shrink();
    return AspectRatio(
      aspectRatio: 1.65,
      child: MergeSemantics(
        child: Column(
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular($styles.corners.md),
                child: AppBtn.basic(
                  semanticLabel: $strings.scrollingContentSemanticOpen,
                  onPressed: handlePressed,

                  /// To prevent the map widget from absorbing the onPressed action, use a Stack + IgnorePointer + a transparent Container
                  child: const Stack(
                    children: [
                      Positioned.fill(child: ColoredBox(color: Colors.transparent)),
                      IgnorePointer(
                        child:SizedBox.shrink(),

                        // GoogleMap(
                        //   markers: {getMapsMarker(startPos.target)},
                        //   zoomControlsEnabled: false,
                        //   mapType: MapType.normal,
                        //   mapToolbarEnabled: false,
                        //   initialCameraPosition: startPos,
                        //   myLocationButtonEnabled: false,
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap($styles.instes.xs),
            Semantics(
              sortKey: OrdinalSortKey(0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: $styles.instes.md),
                child: Text(widget.data.mapCaption, style: $styles.text.caption),
              ),
            ),
          ],
        ),
      ),
    );
  }
}