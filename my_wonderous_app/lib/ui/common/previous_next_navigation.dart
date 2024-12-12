import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/common/platform_info.dart';
import 'package:wonders/ui/common/app_icons.dart';
import 'package:wonders/ui/common/controls/circle_buttons.dart';
import 'package:wonders/ui/common/fullscreen_keyboard_listener.dart';



/// 仅供出iPhone以外的端使用，包含：
/// 1.两个按钮（上一页、下一页）
/// 2.监听键盘左右键
/// 3.监听鼠标滚轮使用
class PreviousNextNavigation extends StatefulWidget {
  const PreviousNextNavigation(
      {super.key,

        required this.onPreviousPressed,
        required this.onNextPressed,
        required this.child,
        this.maxWidth = 1000,
        this.nextBtnColor,
        this.previousBtnColor,
        this.listenToMouseWheel = true});

  //上一页
  final VoidCallback? onPreviousPressed;
  //下一页
  final VoidCallback? onNextPressed;
  //下一页颜色
  final Color? nextBtnColor;
  //上一页颜色
  final Color? previousBtnColor;

  final Widget child;
  //最大宽度
  final double? maxWidth;
  //是否监听鼠标滚轮
  final bool listenToMouseWheel;


  @override
  State<PreviousNextNavigation> createState() => _PreviousNextNavigationState();
}

class _PreviousNextNavigationState extends State<PreviousNextNavigation> {
  DateTime _lastMouseScrollTime = DateTime.now();
  final int _scrollColldownMs = 300;


  bool _handleKeyDown(KeyDownEvent event) {
    if(event.logicalKey == LogicalKeyboardKey.arrowLeft && widget.onPreviousPressed != null) {
      widget.onPreviousPressed?.call();
      return true;
    }
    if(event.logicalKey == LogicalKeyboardKey.arrowRight && widget.onNextPressed != null) {
      widget.onNextPressed?.call();

    }
    return false;
  }



  void _handleMouseScroll(event) {

    if(event is PointerScrollEvent) {
      if(DateTime.now().millisecondsSinceEpoch - _lastMouseScrollTime.millisecondsSinceEpoch < _scrollColldownMs) {
        return;
      }
      _lastMouseScrollTime = DateTime.now();

      if(event.scrollDelta.dy > 0 && widget.onPreviousPressed != null) {
        widget.onPreviousPressed!();
      } else if(event.scrollDelta.dy < 0 && widget.onNextPressed != null) {
        widget.onNextPressed!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(PlatformInfo.isMobile) return widget.child;

    //注册监听
    return Listener(
      //鼠标滚动
      onPointerSignal: widget.listenToMouseWheel ? _handleMouseScroll : null,
      //监听键盘
      child:  FullscreenKeyboardListener(
          //触发监听方法
          onKeyDown: _handleKeyDown,
          //当期页面布局。类似这样  <- [主要内容] ->
          child: Stack(
            children: [
              widget.child,
              Center(
                child: SizedBox(
                  width: widget.maxWidth ?? double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: $styles.instes.sm),
                    child: Row(
                      children: [
                        CircleIconBtn(
                          icon: AppIcons.prev,
                          onPressed: widget.onPreviousPressed,
                          semanticLabel: 'Previous',
                          bgColor: widget.previousBtnColor,
                        ),

                        //占位符
                        const Spacer(),
                        CircleIconBtn(
                          icon: AppIcons.prev,
                          onPressed: widget.onNextPressed,
                          semanticLabel: 'Next',
                          flipIcon: true,
                          bgColor: widget.nextBtnColor,
                        )
                      ],
                    ),

                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
