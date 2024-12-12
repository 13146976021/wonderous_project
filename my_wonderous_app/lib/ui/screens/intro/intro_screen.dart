import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/common/platform_info.dart';
import 'package:wonders/styles/wonders_color_extensions.dart';
import 'package:wonders/ui/common/app_icons.dart';
import 'package:wonders/ui/common/controls/app_page_indicator.dart';
import 'package:wonders/ui/common/controls/circle_buttons.dart';
import 'package:wonders/ui/common/gradient_container.dart';
import 'package:wonders/ui/common/previous_next_navigation.dart';
import 'package:wonders/ui/common/static_text_scale.dart';
import 'package:wonders/ui/common/themed_text.dart';
import 'package:wonders/ui/common/utils/app_haptics.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  //主要图片的宽高
  static const double _imageSize = 250;
  //logo高度
  static const double _logoHeight = 126;
  //文字高低
  static const double _textHeight = 110;
  //分页指示器的高度
  static const double _pageIndicatorHeight = 55;

  static List<_PageData> pageData = [];

  late final PageController _pageController = PageController()..addListener(_handlePageChange);
  late final ValueNotifier<int> _currentPage = ValueNotifier(0)..addListener(() => setState(() {}));
  bool get _isOnLastPage => _currentPage.value.round() == pageData.length - 1;
  bool get _isOnFirstPage => _currentPage.value.round() == 0;

  void _handleNavTextSemanticTap() => _incrementPage(1);


  void _incrementPage(int dir) {

    final int current = _pageController.page!.round();
    if(_isOnFirstPage && dir < 0) return;
    if(_isOnLastPage  && dir > 0) return;
    _pageController.animateToPage(current + dir, duration: 250.ms, curve: Curves.easeIn);

  }

  void _handleIntroCompletePressed(){
    if(_currentPage.value == pageData.length - 1) {
      context.go(ScreenPaths.home);
      settingsLogic.hasCompletedOnboarding.value = true;
    }
  }

  void _handleSemanticSwipe(int dir){
    _pageController.animateToPage((_pageController.page ?? 0).round() + dir, duration: $styles.times.fast, curve: Curves.easeIn);
  }

  void _handlePageChange() {
    //当前页面，round()取整
    int newPage = _pageController.page?.round() ?? 0;
    //记录当前页面的page
    _currentPage.value = newPage;

  }
  @override
  Widget build(BuildContext context) {

    pageData = [
      _PageData($strings.introTitleJourney, $strings.introDescriptionNavigate, 'camel', '1'),
      _PageData($strings.introTitleExplore, $strings.introDescriptionUncover, 'petra', '2'),
      _PageData($strings.introTitleDiscover, $strings.introDescriptionLearn, 'statue', '3'),
    ];


    final List<Widget> pages = pageData.map((e) => _Page(e)).toList(); // pageData.map((e) => _Page(data: e)).toList();

    //设置默认文字的颜色
    return DefaultTextColor(
        color: $styles.colors.offWhite,

        //设置背景
        child: ColoredBox(
          color: $styles.colors.black,
          //设置安全区域
          child: SafeArea(

            //动画,延迟500毫秒执行,显示画面
            child: Animate(
              delay: 500.ms,
              //动画效果，淡入、淡出效果
              effects: [FadeEffect()],
              //供除iPhone端以外的端使用，左右两边按钮
              child: PreviousNextNavigation(
                maxWidth: 600,
                nextBtnColor: _isOnLastPage ? $styles.colors.accent1 : null,
                onPreviousPressed: _isOnFirstPage ? null : () => _incrementPage(-1),
                onNextPressed: () {
                  if(_isOnLastPage){
                    _handleIntroCompletePressed();
                  }else {
                    _incrementPage(1);
                  }
                },

                //主要内容
                child: Stack(
                  children: [
                    MergeSemantics(
                      child: Semantics(
                        onIncrease: () => _handleSemanticSwipe(1),
                        onDecrease: () => _handleSemanticSwipe(-1),
                        //滚动页面view，包含底部文字标题和相信信息
                        child: PageView(
                          controller: _pageController,
                          children: pages,
                          onPageChanged: (_) => AppHaptics.lightImpact(),

                        ),
                      ),
                    ),

                    //忽略（穿透）手势事件
                    IgnorePointer(
                      child:  Column(
                        children: [
                          const Spacer(),
                          Semantics(
                            header: true,
                            //顶部logo 和 标题文字
                            child: Container(
                              height: _logoHeight,
                              alignment: Alignment.center,
                              //
                              child: const _WonderousLogo(),
                            ),
                          ),
                          //图片
                          SizedBox(
                            height: _imageSize,
                            width: _imageSize,
                            //监听_currentPage的改变
                            child: ValueListenableBuilder<int>(
                              valueListenable: _currentPage,
                              builder: (_,value,__) {
                                //切换组件使其过渡更平滑
                                return AnimatedSwitcher(
                                    duration: $styles.times.slow,
                                    //将_PageImage 封装成一个整体。
                                    child: KeyedSubtree(
                                      key: ValueKey(value),
                                      child: _PageImage(data: pageData[value],),
                                    ),
                                );
                              },
                            ),
                          ),

                          //设置间距
                          const Gap(_IntroScreenState._textHeight),
                          //分页指示器高度
                          Container(
                            height: _pageIndicatorHeight,
                            alignment:const Alignment(0,0),
                            child: AppPageIndicator(
                              count: pageData.length,
                              controller: _pageController,
                              color: $styles.colors.offWhite,
                            ),
                          ),
                          const Spacer(flex: 2,)
                        ],
                      ),
                    ),


                    _buildHzGradientOverlay(left: true),
                    _buildHzGradientOverlay(),

                    if(PlatformInfo.isMobile)...[
                      Positioned(
                          right: $styles.instes.lg,
                          bottom: $styles.instes.lg,
                          child: _buildFinishBtn(context)),
                      BottomCenter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: $styles.instes.lg),
                          child: _buildNavText(context),
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget _buildNavText(BuildContext context){
    //监听_currentPage的改变
    return ValueListenableBuilder(
        valueListenable: _currentPage,
        builder: (_, pageIndex, __){
          //当为页面不为最后一个时显示
          return AnimatedOpacity(
              opacity: pageIndex == pageData.length - 1 ? 0 : 1,
              duration: $styles.times.fast,
              child: Semantics(
                onTapHint: $strings.introSemanticNavigate,
                onTap: _isOnLastPage ? null : _handleNavTextSemanticTap,
                child: Text($strings.introSemanticSwipeLeft, style: $styles.text.bodySmall,),

              ),
          );
        });
  }

  Widget _buildFinishBtn(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _currentPage,
        builder: (context,pageIndex,_){
          return AnimatedOpacity(
              opacity: pageIndex == pageData.length - 1  ? 1 : 0,
              duration: $styles.times.fast,
              child: CircleIconBtn(
                icon: AppIcons.next_large,
                bgColor: $styles.colors.accent1,
                onPressed: _handleIntroCompletePressed,
                semanticLabel: $strings.introSemanticEnterApp,
              ),
          );
        });
  }

  Widget _buildHzGradientOverlay({bool left = false}) {

    return Align(
      alignment: Alignment(left? -1 : 1, 0),
      //FractionallySizedBox 按比例设置子组件的大小。比如父组件为300px。0.5就是 0.5 * 300 = 150px子组件的大小
      child: FractionallySizedBox(
        widthFactor: .5,
        child: Padding(
          //如果左边需要将右边的边距设置200
          padding: EdgeInsets.only(left: left ? 0 : 200, right: left ? 200 : 0),

          child:  Transform.scale(
            //水平翻转
            scaleX: left ? -1 : 1,
            //颜色渐变和渐变的起始位置。
            child: HzGradient([
              $styles.colors.black.withOpacity(0),
              $styles.colors.black
            ], const [
              0,
              .2
            ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _PageData {
  const _PageData(this.title, this.desc, this.img, this.mask);

  final String title;
  final String desc;
  final String img;
  final String mask;
}

class _Page extends StatelessWidget {
  const _Page(this.data,{super.key});
  final _PageData data;


  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: $styles.instes.md),
        child: Column(
          children: [
            const Spacer(),
            const Gap(_IntroScreenState._imageSize + _IntroScreenState._logoHeight),
            SizedBox(
              height: _IntroScreenState._textHeight,
              width: 400,
              child: StaticTextScale(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(data.title,style: $styles.text.wonderTitle.copyWith(fontSize: 24 * $styles.scale),),
                      Gap($styles.instes.sm),
                      Text(data.desc,style: $styles.text.body,textAlign: TextAlign.center,)
                    ],
                  )
              ),
            ),
            const Gap(_IntroScreenState._pageIndicatorHeight),
            const Spacer(flex: 2)
          ],



        ),
      ),
    );
  }
}


class _WonderousLogo extends StatelessWidget {
  const _WonderousLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExcludeSemantics(
          child: SvgPicture.asset(SvgPaths.compassSimple,colorFilter: $styles.colors.offWhite.colorFilter,),
        ),
        Gap($styles.instes.xs),
        StaticTextScale(
            child: Text(
              $strings.introSemanticWonderous,
              style: $styles.text.wonderTitle.copyWith(fontSize: 32 * $styles.scale,color:  $styles.colors.offWhite),
            ))
      ],
    );
  }
}

class _PageImage extends StatelessWidget {
  const _PageImage({super.key, required this.data});

  final _PageData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //盒子，expand宽高尽可能的小
        SizedBox.expand(
          child: Image.asset('${ImagePaths.common}/intro-${data.img}.jpg', fit: BoxFit.cover,alignment: Alignment.center),
        ),

        //配合stack的定位使用，fill上下左右边距都为0，做蒙版使用
        Positioned.fill(
          child:
            Image.asset('${ImagePaths.common}/intro-mask-${data.mask}.png',fit: BoxFit.fill,),
        )
      ],
    );
  }
}

