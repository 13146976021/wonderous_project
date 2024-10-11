import 'dart:js_interop';

import 'package:wonders/common_libs.dart';

import 'package:flutter/material.dart';
import 'package:wonders/main.dart';
import 'package:wonders/ui/common/previous_next_navigation.dart';
import 'package:wonders/ui/common/wonder_illustration.dart';
import 'package:wonders/ui/common/wonder_illustration_config.dart';

import '../../../logic/data/wonder_data.dart';

part '_vertical_swipe_controller.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> with GetItStatefulWidgetMixin {

  late final PageController _pageController;
  List<WonderData>get _wonders => wondersLogic.all;

  bool _isMenuOpen = false;

  late int _wonderIndex = 0;
  int get _numWonders => _wonders.length;

  double? _swipeOverride;

  bool _fadeInOnNextBuild = false;

  final _fadeAnims = <AnimationController>[];

  WonderData get currentWonder => _wonders[_wonderIndex];

  late final _VerticalSwipeController _swipeController = _VerticalSwipeController(this, _showDetailsPage);



  void _handlePrevNext(int i) => _setPageIndex(_wonderIndex + i,animate: true);
  bool _isSelected(WonderType t) => t == currentWonder.type;

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

    _wonderIndex = settingsLogic.prevWonderIndex.value ?? 0;
    final initialPage = _numWonders * 100 + _wonderIndex;

    _pageController = PageController(viewportFraction: 1,initialPage: initialPage);
  }


  void _showDetailsPage() async {
    _swipeOverride = _swipeController.swipeAmt.value;
    context.go(ScreenPaths.wonderDetails(currentWonder.type, tabIndex: 0));
    await Future.delayed(100.ms);
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




  @override
  Widget build(BuildContext context) {
    if(_fadeInOnNextBuild == true){
      _startDelayedFgFade();
      _fadeInOnNextBuild = false;
    }


    return _swipeController.wrapGestureDetector(Container(
      color: $styles.colors.black,
      child: PreviousNextNavigation(
          listenToMouseWheel: false,
          onPreviousPressed: () => _handlePrevNext(-1),
          onNextPressed: () => _handlePrevNext(1),
          child: Stack(
            children: [
              ..._buildBgAndClouds()
            ],
          )
      ),
    ))
  }

  List<Widget> _buildBgAndClouds() {

    return [
      ..._wonders.map((e) {
        final config = WonderIllustrationConfig.bg(
          isShowing: _isSelected(e.type),

        );
        return WonderIllustration(e.type, config: config);

      }),

      FractionallySizedBox(
        widthFactor: 1,
        heightFactor: .5,
        child: AnimatedC,
      )

    ];


  }
}
