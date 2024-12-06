import 'dart:math';

import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/data/wonder_data.dart';
import 'package:wonders/logic/string_utils.dart';
import 'package:wonders/styles/wonders_color_extensions.dart';
import 'package:wonders/ui/common/blend_mask.dart';
import 'package:wonders/ui/common/centered_box.dart';
import 'package:wonders/ui/common/compass_divider.dart';
import 'package:wonders/ui/common/curved_clippers.dart';
import 'package:wonders/ui/common/fullscreen_keyboard_list_scroller.dart';
import 'package:wonders/ui/common/gradient_container.dart';
import 'package:wonders/ui/common/hiddent_collectible.dart';
import 'package:wonders/ui/common/pop_router_on_over_scroll.dart';
import 'package:wonders/ui/common/scaling_list_item.dart';
import 'package:wonders/ui/common/static_text_scale.dart';
import 'package:wonders/ui/common/themed_text.dart';
import 'package:wonders/ui/common/utils/context_utils.dart';
import 'package:wonders/ui/common/wonder_illustration.dart';
import 'package:wonders/ui/common/wonder_illustration_config.dart';
import 'package:wonders/ui/wonder_illustrations/common/wonder_title_text.dart';


part 'widgets/_top_illustration.dart';
part 'widgets/_title_text.dart';
part 'widgets/_app_bar.dart';
part 'widgets/_circular_title_bar.dart';
part 'widgets/_scrolling_content.dart';
part 'widgets/_collapsing_pull_quote_image.dart';

class WonderEditorialScreen extends StatefulWidget {
  const WonderEditorialScreen(this.data,{super.key,required this.contentPadding});

  final WonderData data;
  final EdgeInsets contentPadding;


  @override
  State<WonderEditorialScreen> createState() => _WonderEditorialScreenState();
}

class _WonderEditorialScreenState extends State<WonderEditorialScreen> {

  //触发scroll触发方法
  void _handleScrollChanged() {
    _scrollPos.value = _scroll.position.pixels;
  }

  //创建scrollController 控制器，并监听其变化
  late final ScrollController _scroll = ScrollController()..addListener(_handleScrollChanged);

  final _scrollPos = ValueNotifier(0.0);
  final _sectionIndex = ValueNotifier(0);

  @override
  void dispose() {
    // TODO: implement dispose
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void scrl(ScrollView v) {

    }

    return LayoutBuilder(builder: (_, constraints){
      bool shortMode = constraints.biggest.height < 700;
      double illustrationHeight = shortMode ? 250 : 200;
      double minAppBarHeight = shortMode ? 80 : 150;

      double maxAppBarHeight = min(context.widthPx, $styles.sizes.maxContentWidth1) * 1.2;

      //1.监听手势，退出pop
      return PopRouterOnOverScroll(
          controller: _scroll,
          //颜色背景
          child: ColoredBox(
            // color: $styles.colors.offWhite,
            color: Colors.red,

            //页面内容
            child:  Stack(
              children: [
                //页面背景
                Positioned.fill(
                    child:ColoredBox(color: widget.data.type.bgColor,)
                ),
                //展示内容
                SizedBox(
                  //页面 高度
                  height:illustrationHeight,
                  //监听_scrollPos的改变
                  child: ValueListenableBuilder<double>(
                    valueListenable: _scrollPos,
                    builder: (_, value, child) {
                      //是否显示页面
                      double opacity = (1 - value / 700).clamp(0, 1);
                      return Opacity(opacity: opacity, child: child);
                    },
                    //设置边界点，使其提高渲染效率。
                    child: RepaintBoundary(
                      // child: Text("111"),
                      child: _TopIllustration(
                        widget.data.type,
                        fgOffset: Offset(widget.contentPadding.left / 2, 0),
                    )
                    ),
                  ),
                ),



                TopCenter(
                  child: Padding(
                    padding: widget.contentPadding,
                    child: SizedBox(
                      //键盘按钮
                      child: FocusTraversalGroup(
                        //键盘
                        child: FullscreenKeyboardListScroller(
                          scrollController: _scroll,
                          child: CustomScrollView(
                            controller: _scroll,
                            scrollBehavior: ScrollConfiguration.of(context).copyWith(),
                            //这个需要跟PageStorage配合使用，不过Scroll里面已经有了
                            key: PageStorageKey('editorial'),
                            slivers: [
                              SliverToBoxAdapter(
                                child: SizedBox(height: illustrationHeight,),
                              ),
                              SliverToBoxAdapter(
                                child: ValueListenableBuilder<double>(
                                  valueListenable: _scrollPos,
                                  builder: (_, value, child) {
                                    double offsetAmt = max(0, value * .3);
                                    double opacity = (1 - offsetAmt / 150).clamp(0, 1);

                                    return Transform.translate(
                                      offset: Offset(0, offsetAmt),
                                      child: Opacity(opacity: opacity, child:  child),
                                    );
                                  },

                                  child: _TitleText(widget.data, scroller: _scroll),

                                ),

                              ),

                              SliverAppBar(
                                pinned: true,
                                collapsedHeight: minAppBarHeight,
                                toolbarHeight: minAppBarHeight,
                                expandedHeight: maxAppBarHeight,
                                backgroundColor: Colors.purple,
                                elevation: 0,
                                leading: SizedBox.shrink(),
                                flexibleSpace: SizedBox.expand(
                                  child: _AppBar(
                                    widget.data.type,
                                    scrollPos: _scrollPos,
                                    sectionIndex: _sectionIndex,
                                  ),
                                ),
                              ),
                            _ScrollingContent(widget.data, scrollPos: _scrollPos, sectionNotifier: _sectionIndex)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]
            ),
          )
      );
    }
    );
  }
}
