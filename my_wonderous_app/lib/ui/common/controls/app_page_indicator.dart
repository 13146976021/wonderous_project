
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wonders/common_libs.dart';


class AppPageIndicator extends StatefulWidget {
   AppPageIndicator({
    super.key,
    required this.count,
    required this.controller,
    this.onDotPressed,
    this.dotSize,
    String? semanticPageTitle,
    this.color,
  }) : semanticPageTitle = semanticPageTitle ?? $strings.appPageDefaultTitlePage;

   //总个数
  final int count;
  //控制器
  final PageController controller;
  //选中事件
  final void Function(int index)? onDotPressed;
  //颜色
  final Color? color;
  //指示器大小
  final double? dotSize;
  //辅助文字
  final String? semanticPageTitle;

  @override
  State<AppPageIndicator> createState() => _AppPageIndicatorState();
}

class _AppPageIndicatorState extends State<AppPageIndicator> {

  //创建一个页面的值监听器
  final _currentPage = ValueNotifier(0);
  //获取控制器当前的页面
  int get _controllerPage => _currentPage.value;

  //页面改变的是调用
  void _handlePageChanged() {
    //更改值监听器
    _currentPage.value = widget.controller.page!.round();
  }
  @override
  void initState() {
    //添加对controller添加监听
    widget.controller.addListener(_handlePageChanged);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    //页面布局
    return Stack(
      children: [

        //屏幕阅读器
        Container(
          color: Colors.transparent,
          height: 30,
          alignment: Alignment.center,
          child: ValueListenableBuilder<int>(
            valueListenable: _currentPage,
            builder: (_, value, child){
              return Semantics(
                liveRegion: true,
                focusable: false,
                readOnly: true,
                label: $strings.appPageSemanticSwipe(
                  widget.semanticPageTitle as Object,
                  (_controllerPage % (widget.count) + 1),
                  widget.count,
                ),

              );
            },
          ),

        ),
        Positioned.fill(
            child:Center(
              child: ExcludeSemantics(
                child: SmoothPageIndicator(
                  controller: widget.controller,
                  count: widget.count,
                  onDotClicked: widget.onDotPressed,
                  effect: ExpandingDotsEffect(
                    dotWidth: widget.dotSize ?? 6,
                    dotHeight: widget.dotSize ?? 6,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: (widget.dotSize ?? 6) / 2,
                    dotColor: widget.color ?? $styles.colors.accent1,
                    activeDotColor: widget.color ?? $styles.colors.accent1,
                      expansionFactor: 2
                  ),
                ),
              ),
            )
        )
      ],
    );
  }
}
