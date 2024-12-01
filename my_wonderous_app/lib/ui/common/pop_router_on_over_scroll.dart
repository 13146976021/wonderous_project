import 'package:wonders/common_libs.dart';



class PopRouterOnOverScroll extends StatefulWidget {
  const PopRouterOnOverScroll({super.key,required this.controller, required this.child});

  final ScrollController controller;
  final Widget child;


  @override
  State<PopRouterOnOverScroll> createState() => _PopRouterOnOverScrollState();
}

class _PopRouterOnOverScrollState extends State<PopRouterOnOverScroll> {

  final _scrollToPopThreshold = 70;
  bool _isPointerDown = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.controller.addListener(_handleScrollChanged);


  }


  @override
  void didUpdateWidget(covariant PopRouterOnOverScroll oldWidget) {
    if(widget.controller != oldWidget.controller) {
      widget.controller.addListener(_handleScrollChanged);
    }
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }



  void _handleScrollChanged() {
    final px = widget.controller.position.pixels;
    if(px < -_scrollToPopThreshold) {

      //退出pop，取消键监听。
      if(_isPointerDown) {
        context.pop();
        widget.controller.removeListener(_handleScrollChanged);
      }
    }
  }

  bool _checkPointerIsDown(d) => _isPointerDown = d.dragDetails != null;


  @override
  Widget build(BuildContext context) {
      //向下滚动监听
    return NotificationListener<ScrollUpdateNotification>(
        onNotification: _checkPointerIsDown,
        child: widget.child
    );
  }
}
