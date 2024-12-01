
import 'package:wonders/common_libs.dart';

import 'package:flutter/material.dart';
import 'package:wonders/main.dart';
import 'package:wonders/styles/wonders_color_extensions.dart';
import 'package:wonders/ui/common/app_icons.dart';
import 'package:wonders/ui/common/controls/app_hearder.dart';
import 'package:wonders/ui/common/controls/app_page_indicator.dart';
import 'package:wonders/ui/common/gradient_container.dart';
import 'package:wonders/ui/common/themed_text.dart';
import 'package:wonders/ui/wonder_illustrations/common/animated_clouds.dart';
import 'package:wonders/ui/common/previous_next_navigation.dart';
import 'package:wonders/ui/common/utils/app_haptics.dart';
import 'package:wonders/ui/common/wonder_illustration.dart';
import 'package:wonders/ui/common/wonder_illustration_config.dart';
import 'package:wonders/ui/wonder_illustrations/common/wonder_title_text.dart';

import '../../../logic/data/wonder_data.dart';

part '_vertical_swipe_controller.dart';
part 'widgets/_animated_arrow_button.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  //页面控制器
  late final PageController _pageController;
  //获取所有数据源
  List<WonderData>get _wonders => wondersLogic.all;

  //判断是否打开菜单键
  bool _isMenuOpen = false;

  //当前的索引
  late int _wonderIndex = 0;

  //所有的wonders的个数
  int get _numWonders => _wonders.length;


  double? _swipeOverride;

  bool _fadeInOnNextBuild = false;

  //动画控制器数组
  final _fadeAnims = <AnimationController>[];


  //获取当前页面的数据
  WonderData get currentWonder => _wonders[_wonderIndex];

  //初始化滑动控制器
  late final _VerticalSwipeController _swipeController = _VerticalSwipeController(this, _showDetailsPage);


  //手动点击上一个按钮
  void _handlePrevNext(int i) => _setPageIndex(_wonderIndex + i,animate: true);

  //是否是当前选中的selected
  bool _isSelected(WonderType t) => t == currentWonder.type;


  //获取当前页面的索引
  void _setPageIndex(int index,{bool animate = false}) {
    if(index == _wonderIndex) return;
    //计算出当前页面的位置，当前的页面 3，总页面6。 3/6 * 6 =
    final pos = ((_pageController.page  ?? 0) / _numWonders).floor() * _numWonders;
    final newIndex = pos + index;
    if(animate == true) {
      _pageController.animateToPage(newIndex, duration: $styles.times.med, curve: Curves.easeOutCubic);

    }else {
      _pageController.jumpToPage(newIndex);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //1.获取当前的索引值
    _wonderIndex = settingsLogic.prevWonderIndex.value ?? 0;
    //2.初始化页面数量
    final initialPage = _numWonders * 100 + _wonderIndex;
    //3.预加载页面数量
    _pageController = PageController(viewportFraction: 1,initialPage: initialPage);
  }

  void _showDetailsPage() async {

    _swipeOverride = _swipeController.swipeAmt.value;

    context.go(ScreenPaths.wonderDetails(currentWonder.type, tabIndex: 0));
    await Future.delayed(3000.ms);
    _swipeOverride = null;
    _fadeInOnNextBuild = true;

  }

  void _startDelayedFgFade() async {
    try {
      for(var a in _fadeAnims) {
        a.value = 0;
      }
      await Future.delayed(300.ms);

      for(var a in _fadeAnims) {
        a.forward();
      }

    }on Exception catch(e){
      debugPrint(e.toString());
    }

  }

  void _handleFadeAnimInit(AnimationController controller) {
    _fadeAnims.add(controller);
    controller.value = 1;
  }
  void _handlePageChanged(value){
    final newIndex = value % _numWonders;
    if(newIndex == _wonderIndex) {
      return;
    }

    setState(() {
      _wonderIndex = newIndex;
      settingsLogic.prevWonderIndex.value = _wonderIndex;

    });
    AppHaptics.lightImpact();

  }
  
  Widget _buildFgAndGradients() {
    Widget buildSwipeableBgGradient(Color fgColor) {
      return _swipeController.buildListener(builder: (swipeAmt, isPointerDown, _) {
        return IgnorePointer(
          child: FractionallySizedBox(
            heightFactor: .6,
            child:  Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      fgColor.withOpacity(0),
                      fgColor.withOpacity(.5 + fgColor.opacity * .25 + (isPointerDown ? .05 : 0) + swipeAmt * .20)
                    ],
                    stops: const [0 ,1],
                  )
              ),
            ),
          ),
        );
      });
    }

    final gradientColor = currentWonder.type.bgColor;
    return Stack(children: [
      BottomCenter(
        child:  buildSwipeableBgGradient(gradientColor),


      ),
      ..._wonders.map((e) {
        return _swipeController.buildListener(builder: (swipeAmt,_, child) {
          //设置配置信息
          final config = WonderIllustrationConfig.fg(
            //判断是否显示当前的背景图片
            isShowing: _isSelected(e.type),

            zoom: .4 * (_swipeOverride ?? swipeAmt),
          );

          return Animate(
            effects: const [FadeEffect()],
            onPlay: _handleFadeAnimInit,
            child: IgnorePointer(child: WonderIllustration(e.type, config: config
            ),),
          );
        });
      }),
    ],
    );

  }

  Widget _buildMgPageView() {
    return ExcludeSemantics(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _handlePageChanged,
        itemBuilder: (_, index) {
          final wonder = _wonders[index % _wonders.length];
          final wonderType = wonder.type;
          bool isShowing = _isSelected(wonderType);
          return _swipeController.buildListener(
              builder: (swipeAmt, _ , chilid) {
                final config = WonderIllustrationConfig.mg(
                  isShowing: isShowing,
                  zoom: .05 * swipeAmt
                );
                return WonderIllustration(wonderType, config: config);
              });
        },
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    if(_fadeInOnNextBuild == true){
      _startDelayedFgFade();
      _fadeInOnNextBuild = false;
    }
    return _swipeController.wrapGestureDetector(
        Container(
          color: $styles.colors.black,
          //web端页面显示内容
          child: PreviousNextNavigation(
              listenToMouseWheel: false,
              //上一页按钮
              onPreviousPressed: () => _handlePrevNext(-1),
              //下一页按钮
              onNextPressed: () => _handlePrevNext(1),
              //页面布局真正开始，使用stack布局层叠布局
              child: Stack(
                children: [
                  //最底层页面
                  ..._buildBgAndClouds(),
                  _buildMgPageView(),
                  _buildFgAndGradients(),
                  _buildFloatingUi(),
            ],
          )
      ),
    )
    );
  }

  List<Widget> _buildBgAndClouds() {

    return [
      //遍历所有数据源
      ..._wonders.map((e) {
        //获取所有配置玄心
        final config = WonderIllustrationConfig.bg(
          isShowing: _isSelected(e.type),
        );
        //返回所有的背景颜色
        return WonderIllustration(e.type, config: config);
      }),

      FractionallySizedBox(
        widthFactor: 1,
        heightFactor: .5,
        child: AnimatedClouds(wonderType: currentWonder.type, opacity: 1)
      )

    ];

  }
  Widget _buildFloatingUi() {
    return Stack(children: [
      /// Floating controls / UI
      AnimatedSwitcher(
        duration: $styles.times.fast,
        child: AnimatedOpacity(
          opacity: _isMenuOpen ? 0 : 1,
          duration: $styles.times.med,
          child: RepaintBoundary(
            child: OverflowBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: double.infinity),
                  const Spacer(),
                  /// Title Content
                  LightText(
                    child: IgnorePointer(
                      ignoringSemantics: false,
                      child: Transform.translate(
                        offset: Offset(0, 30),
                        child: Column(
                          children: [
                            Semantics(
                              liveRegion: true,
                              button: true,
                              header: true,
                              onIncrease: () => _setPageIndex(_wonderIndex + 1),
                              onDecrease: () => _setPageIndex(_wonderIndex - 1),
                              onTap: () => _showDetailsPage(),
                              // Hide the title when the menu is open for visual polish
                              //文字
                              child: WonderTitleText(currentWonder, enableShadows: true),
                            ),
                            Gap($styles.instes.md),

                            //显示的小点
                            AppPageIndicator(
                              count: _numWonders,
                              controller: _pageController,
                              color: $styles.colors.accent1,
                              dotSize: 8,
                              onDotPressed: _handlePageIndicatorDotPressed,
                              semanticPageTitle: $strings.homeSemanticWonder,
                            ),
                            Gap($styles.instes.md),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Animated arrow and background
                  /// Wrap in a container that is full-width to make it easier to find for screen readers
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,

                    /// Lose state of child objects when index changes, this will re-run all the animated switcher and the arrow anim
                    key: ValueKey(_wonderIndex),
                    child: Stack(
                      children: [
                        /// Expanding rounded rect that grows in height as user swipes up
                        Positioned.fill(
                            child: _swipeController.buildListener(
                              builder: (swipeAmt, _, child) {
                                double heightFactor = .5 + .5 * (1 + swipeAmt * 4);
                                return FractionallySizedBox(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: heightFactor,
                                  child: Opacity(opacity: swipeAmt * .5, child: child),
                                );
                              },
                              child: VtGradient(
                                [$styles.colors.white.withOpacity(0), $styles.colors.white.withOpacity(1)],
                                const [.3, 1],
                                borderRadius: BorderRadius.circular(99),
                              ),
                            )),

                        /// Arrow Btn that fades in and out
                        _AnimatedArrowButton(onTap: _showDetailsPage, semanticTitle: currentWonder.title),
                      ],
                    ),
                  ),
                  Gap($styles.instes.md),
                ],
              ),
            ),
          ),
        ),
      ),

      /// Menu Btn
      TopLeft(
        child: AnimatedOpacity(
          duration: $styles.times.fast,
          opacity: _isMenuOpen ? 0 : 1,
          // child:  const Text('AppHeader'),
          child: AppHearder(
            backIcon: AppIcons.menu,
            backBtnSemantics: $strings.homeSemanticOpenMain,
            onBack: _handleOpenMenuPressed,
            isTransparent: true,
          ),
        ),
      ),
    ]);
  }


  void _handlePageIndicatorDotPressed(int index) => _setPageIndex(index);


  void _handleOpenMenuPressed() async {
    setState(() => _isMenuOpen = true);
    WonderType? pickedWonder = await appLogic.showFullscreenDialogRoute<WonderType>(
      context,
      // HomeMenu(data: currentWonder),
      Placeholder(),
      transparent: true,
    );
    setState(() => _isMenuOpen = false);
    if (pickedWonder != null) {
      _setPageIndex(_wonders.indexWhere((w) => w.type == pickedWonder));
    }
  }
}
