import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';


class WonderIllustration extends StatelessWidget {
  const WonderIllustration(this.type,{super.key,required this.config});
  final WonderType type;
  final WonderIllustration config;

  @override
  Widget build(BuildContext context) {
    return switch(type) {
      WonderType.chichenItza => C
    }
  }
}
