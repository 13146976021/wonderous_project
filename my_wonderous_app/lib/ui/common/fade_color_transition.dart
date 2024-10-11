import 'package:wonders/common_libs.dart';

class FadeColorTransition extends  StatelessWidget {
  const FadeColorTransition({super.key, required this.animation, required this.color});

  final Animation<double>animation;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: animation, builder: (_,__) => Container(color: color.withOpacity(animation.value)));
  }
}