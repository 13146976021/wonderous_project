part of 'wonders_home_screen.dart';

class _VerticalSwipeController {


  _VerticalSwipeController(this.ticker, this.onSwipeComplete) {
    swipeReleaseAnim = AnimationController(vsync: ticker)..addListener(handleSwipeReleaseAnimTick);
  }

  final TickerProvider ticker;

  final swipeAmt = ValueNotifier<double>(0);

  //是否点击向下按钮
  final isPointerDown = ValueNotifier<bool>(false);

  final double _pullToViewDetailsThreshold = 150;
  final VoidCallback onSwipeComplete;
  late final AnimationController swipeReleaseAnim;

  /// When the _swipeReleaseAnim plays, sync its value to _swipeUpAmt
  /// /// 当 _swipeReleaseAnim 播放时，将其值同步到 _swipeUpAmt
  void handleSwipeReleaseAnimTick() => swipeAmt.value = swipeReleaseAnim.value;
  //s是否
  void handleTapDown(){
      print("handleTapDown");
      isPointerDown.value = true;
  }
  void handleTapCancelled() {

    print("handleTapCancelled");
    isPointerDown.value = false;
  }

  void handleVerticalSwipeCancelled() {

    print("handleVerticalSwipeCancelled");

    swipeReleaseAnim.duration = swipeAmt.value.seconds * 2.5;

    swipeReleaseAnim.reverse(from: swipeAmt.value);

    isPointerDown.value = false;
  }


  void handleVerticalSwipeCancelled1() {

    print("handleVerticalSwipeCancelled1");
    swipeReleaseAnim.duration = swipeAmt.value.seconds * .5;

    swipeReleaseAnim.reverse(from: swipeAmt.value);

    isPointerDown.value = false;
  }

  void handleVerticalSwipeUpdate(DragUpdateDetails details) {
    if (swipeReleaseAnim.isAnimating) swipeReleaseAnim.stop();

    isPointerDown.value = true;
    double value = (swipeAmt.value - details.delta.dy / _pullToViewDetailsThreshold).clamp(0, 1);
    if (value != swipeAmt.value) {
      swipeAmt.value = value;
      if (swipeAmt.value == 1) {
        onSwipeComplete();
      }
    }

    //print(_swipeUpAmt.value);
  }
  /// 一个实用方法，用于包装多个 ValueListenableBuilder，并将值传递给构建方法。
  /// 在订阅变化时，可以减少 UI 的样板代码。
  ///
  Widget buildListener(
      {required Widget Function(double swipeUpAmt, bool isPointerDown, Widget? child) builder,
          Widget? child}
      ) {
    return ValueListenableBuilder<double>(
      valueListenable: swipeAmt,
      builder: (_, swipeAmt, __) => ValueListenableBuilder<bool>(
        valueListenable: isPointerDown,
        builder: (_, isPointerDown, __) {
          return builder(swipeAmt, isPointerDown, child);
        },
      ),
    );
  }

  /// Utility method to wrap a gesture detector and wire up the required handlers.
  /// /// 一个实用方法，用于包装一个 GestureDetector 并连接所需的事件处理器。
  Widget wrapGestureDetector(Widget child, {Key? key}) => GestureDetector(
      key: key,
      excludeFromSemantics: true,
      //转场动画，手势向下滑的时候会调用此方法
      onTapDown: (_) => handleTapDown(),
      onTapUp: (_) => handleTapCancelled(),
      onVerticalDragUpdate: handleVerticalSwipeUpdate,
      onVerticalDragEnd: (_) => handleVerticalSwipeCancelled1(),
      onVerticalDragCancel: handleVerticalSwipeCancelled,
      behavior: HitTestBehavior.translucent,
      child: child);

  void dispose() {
    swipeAmt.dispose();
    isPointerDown.dispose();
    swipeReleaseAnim.dispose();
  }
}
