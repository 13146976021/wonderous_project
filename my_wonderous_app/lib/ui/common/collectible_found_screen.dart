import 'package:flutter/cupertino.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/data/collectible_data.dart';

import '';


class CollectibleFoundScreen extends StatelessWidget {
  const CollectibleFoundScreen({super.key});
  
  final CollectibleData collectible;
  final ImageProvider imageProvider;
  

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  
  Widget _buildIntro(BuildContext context) {
    Duration t = $styles.times.fast;
    return Stack(
      children: [
        Animate().custom(builder: (context, ratio,_) => )
      ],
    )
  }
}
