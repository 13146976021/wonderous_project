import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/ui/common/app_icons.dart';
import 'package:wonders/ui/common/controls/circle_buttons.dart';


class AppHearder extends StatelessWidget {
  const AppHearder({
    super.key,
    this.title,
    this.subtitle,
    this.showBackBtn = true,
    this.isTransparent = false,
    this.onBack,
    this.trailing,
    this.backIcon = AppIcons.prev,
    this.backBtnSemantics
  });


  final String? title;
  final String? subtitle;
  final bool showBackBtn;
  final AppIcons backIcon;

  final String? backBtnSemantics;
  final bool isTransparent;
  final VoidCallback? onBack;
  final Widget Function(BuildContext context)? trailing;



  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isTransparent ? Colors.transparent : $styles.colors.black,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64 * $styles.scale,
          child: Stack(
            children: [
              MergeSemantics(
              child: Semantics(
              header: true,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(title != null)
                      Text(
                        title!.toUpperCase(),
                        textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                        style: $styles.text.h4.copyWith(
                          color: $styles.colors.offWhite,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    if(subtitle != null)
                      Text(
                        subtitle!.toUpperCase(),
                        textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                        style: $styles.text.title1.copyWith(color: $styles.colors.accent1),
                      ),
                  ],
                ),

              ),

          ),
          ),
              Positioned.fill(
                child: Center(
                  child: Row(
                    children: [
                      Gap($styles.instes.sm),
                      if(showBackBtn)
                        BackBtn(
                          onPressed: onBack,
                          icon: backIcon,
                          semanticLabel: backBtnSemantics,
                        ),
                      Spacer(),
                      if(trailing != null) trailing!.call(context),
                      Gap($styles.instes.sm)

                    ],
                  ),
                ),
              )
          ]

          )
        ),
      ),
    );
  }
}
