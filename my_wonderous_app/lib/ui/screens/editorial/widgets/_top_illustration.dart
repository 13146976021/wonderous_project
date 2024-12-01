part of '../editorial_screen.dart';


class _TopIllustration extends StatelessWidget {
  const _TopIllustration(this.type, {super.key, this.fgOffset = Offset.zero});

  final WonderType type;
  final Offset fgOffset;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WonderIllustration(type , config: WonderIllustrationConfig(enableAnims: false, shortMode: true)),
        Transform.translate(
          offset: fgOffset + Offset(0, 10),
          child: WonderIllustration(
            type,
            config: WonderIllustrationConfig.mg(enableAnims: false, shortMode: true),
          ),

        )
      ],
    );
  }
}
