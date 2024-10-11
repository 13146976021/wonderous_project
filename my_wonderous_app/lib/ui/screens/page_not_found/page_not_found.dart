import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:wonders/main.dart';
import 'package:wonders/router.dart';
import 'package:wonders/ui/common/controls/buttons.dart';
import 'package:wonders/ui/common/themed_text.dart';
import 'package:wonders/ui/common/wonderous_logo.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key, required this.url});
  final String url;



  @override
  Widget build(BuildContext context) {
    void handleHomePress() => context.go(ScreenPaths.home);

    return Scaffold(
      backgroundColor: $styles.colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WonderousLogo(),
            Gap(10),
            Text('Wonderous',
            style: $styles.text.wonderTitle.copyWith(color: $styles.colors.accent1,fontSize: 28,),
            ),
            Gap(70),
            AppBtn(
                minimumSize: Size(200, 0),
                bgColor: $styles.colors.white,
                onPressed: handleHomePress,
                semanticLabel: "back",
              child: DrakText(child: Text(
                $strings.pageNotFoundBackButton,
                style: $styles.text.btn.copyWith(fontSize: 12),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
