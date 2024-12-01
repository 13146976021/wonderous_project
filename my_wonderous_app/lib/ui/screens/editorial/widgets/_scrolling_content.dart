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
            dropCapPadding: EdgeInsets.only(right: 6),
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
        }
      }


      return Hidd
    }


    return const Placeholder();
  }
}


class SliverBackgroundColor extends SingleChildRenderObjectWidget {
   SliverBackgroundColor({
    super.key,
    required this.color,
    Widget? sliver,
  });

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