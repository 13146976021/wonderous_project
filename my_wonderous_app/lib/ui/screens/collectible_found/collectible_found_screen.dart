import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/data/collectible_data.dart';
import 'package:wonders/ui/common/controls/app_image.dart';

import '';


class CollectibleFoundScreen extends StatelessWidget {
  const CollectibleFoundScreen({
    super.key,
    required this.collectible,
    required this.imageProvider});

  final CollectibleData collectible;
  final ImageProvider imageProvider;


  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _buildIntro(context).animate().swap(
        delay: $styles.times.fast * 3.5,
          builder: (_, __) => Text("22222")),
    );
  }

  Widget _buildGradient(BuildContext context, double ratioIn,double ratioOut) {
    ratioIn = Curves.easeOutExpo.transform(ratioIn);
    final double opacity = 1.0 * (ratioIn * 0.8 + ratioIn * 0.2);
    final Color light = $styles.colors.offWhite;
    final Color dark = $styles.colors.black;

    if(ratioOut == 1) return Container(color: dark.withOpacity(opacity),);

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Color.lerp(light, dark, ratioOut)!.withOpacity(opacity), dark.withOpacity(opacity)],
          stops: [0.2, min(1, 0.25 + ratioIn * 0.5+ ratioIn * 0.5)],

        )
      ),
    );

  }
  Widget _buildImage(BuildContext context) {
    Duration t = $styles.times.fast;
    return AppImage(image: imageProvider, scale: 1.0,)
        .animate()
        .custom(
        duration: t * 6,
        builder: (_, ratio, child) => Container(
          padding: EdgeInsets.all($styles.instes.xxs),
          margin: EdgeInsets.symmetric(horizontal: $styles.instes.xl),
          decoration: BoxDecoration(color: $styles.colors.offWhite, boxShadow: [
            BoxShadow(
              color: $styles.colors.accent1.withOpacity(ratio * 0.75),
              blurRadius: $styles.instes.xl * 2
            ),
            BoxShadow(
              color: $styles.colors.black.withOpacity(CupertinoThumbPainter.radius * 0.75),
              offset: Offset(0 ,$styles.instes.xxs),
              blurRadius: $styles.instes.sm,
            ),

          ]),
          child: child,
        )
    )
        .scale(begin: Offset(0.3, 0.3),duration: t * 2, curve: Curves.easeOutExpo,alignment: Alignment(0, 0.7));

  }

  Widget _buildDetail(BuildContext context) {
    return Text("data");

  }
  Widget _buildIntro(BuildContext context) {
    Duration t = $styles.times.fast;
    return Stack(
      children: [
        Animate().custom(builder: (context, ratio,_) => _buildGradient(context, ratio, 0)),
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.33,
            heightFactor: 0.33,
            child: Hero(
              tag: 'collectible_icon_${collectible.id}',
              child: Image(
                image: collectible.icon,
                fit: BoxFit.contain,
              ),
            ),

          )
              .animate()
              .scale(begin: Offset(1.5, 1.5),end:Offset(3, 3),curve: Curves.easeInExpo, delay: t,duration:t * 3 )
              .fadeOut(),
        )
      ],
    );
  }



}
