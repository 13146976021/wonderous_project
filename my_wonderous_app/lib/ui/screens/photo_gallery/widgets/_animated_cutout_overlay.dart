part of '../photo_gallery.dart';
class _AnimatedCutoutOverlay extends StatelessWidget {
  const _AnimatedCutoutOverlay({
    super.key,
    required this.child,
    required this.cutoutSize,
    required this.animationKey,
    this.duration,
    required this.swipeDir,
    required this.opacity,
    required this.enable
  });

  final Widget child;
  final Size cutoutSize;
  final Offset swipeDir;
  final Duration? duration;
  final Key animationKey;

  final double opacity;
  final bool enable;


  @override
  Widget build(BuildContext context) {

    if(!enable) return child;
    return Stack(
      children: [
        child,
        Animate(
          effects: [CustomEffect(builder: _buildAnimatedCutout,curve: Curves.easeOut,duration: duration)],
        )
      ],
    );
  }

  Widget _buildAnimatedCutout(BuildContext context, double anim, Widget child) {
    const scaleAmt = .25;
    final size = Size(
      cutoutSize.width * (1 - scaleAmt * anim * swipeDir.dx.abs()),
      cutoutSize.height * (1 - scaleAmt * anim * swipeDir.dy.abs())
    );

    return ClipPath(clipper: _CutoutClipper(size));
  }
}


class _CutoutClipper extends CustomClipper<Path> {
  _CutoutClipper(this.cutoutSize);
  final Size cutoutSize;

  @override
  Path getClip(Size size) {
    double padX = (size.width - cutoutSize.width) / 2;
    double padY = (size.height - cutoutSize.height) / 2;
    return Path.combine(PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
        ..addRect(
            RRect.fromLTRBR(
                padX,
                padY,
                size.width - padX,
                size.height - padY, Radius.circular(6)
            ) as Rect
        )
        ..close(),
    );


    }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw UnimplementedError();
  }


}

















