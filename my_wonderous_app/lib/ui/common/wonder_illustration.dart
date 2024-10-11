import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/ui/common/wonder_illustration_config.dart';
import 'package:wonders/ui/wonder_illustrations/chichen_itza_illustration.dart';


class WonderIllustration extends StatelessWidget {
  const WonderIllustration(this.type,{super.key,required this.config});
  final WonderType type;
  final WonderIllustrationConfig config;

  @override
  Widget build(BuildContext context) {

    return switch(type) {
      WonderType.chichenItza => ChichenItzaIllustration(config: config),
      // TODO: Handle this case.
      WonderType.christRedeemer => throw UnimplementedError(),
      // TODO: Handle this case.
      WonderType.colosseum => throw UnimplementedError(),
      // TODO: Handle this case.
      WonderType.greatWall => throw UnimplementedError(),
      // TODO: Handle this case.
      WonderType.machuPicchu => throw UnimplementedError(),
      // TODO: Handle this case.
      WonderType.petra => throw UnimplementedError(),
      // TODO: Handle this case.
      WonderType.pyramidsGiza => throw UnimplementedError(),
      // TODO: Handle this case.
      WonderType.tajMahal => throw UnimplementedError(),
    };

  }
}
