import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/data/collectible_data.dart';

class HiddentCollectible extends StatelessWidget {
  const HiddentCollectible(this.currentWonder,{super.key, required this.index, required this.size, required this.matches, this.focus})
  : assert(index <= 2, 'index should not exceed 2');


  final int index;
  final double size;
  final List<WonderType> matches;
  final WonderType currentWonder;
  final FocusNode? focus;



  @override
  Widget build(BuildContext context) {
    // final data = collectiblesL

    return const Placeholder();
  }
}
