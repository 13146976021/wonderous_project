import 'package:flutter/material.dart';
import 'package:wonders/logic/common/color_untils.dart';

class AppColors {

  /// Common
  final Color accent1 = Color(0xFFE4935D);
  final Color accent2 = Color(0xFFBEABA1);
  final Color offWhite = Color(0xFFF8ECE5);
  final Color caption = const Color(0xFF7D7873);
  final Color body = const Color(0xFF514F4D);
  final Color greyStrong = const Color(0xFF272625);
  final Color greyMedium = const Color(0xFF9D9995);
  final Color white = Colors.white;

  // NOTE: If this color is changed, also change it in
  // - web/manifest.json
  // - web/index.html -
  final Color black = const Color(0xFF1E1B18);

  final bool isDark = false;

  Color shift(Color c, double d) => ColorUtils.shiftHsl(c, d * (isDark ? -1 : 1));


  ThemeData toThemeData() {
    TextTheme txtTheme = (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    Color txtColor = white;
    ColorScheme colorScheme = ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: accent1,
        onPrimary: Colors.white,
        secondary: accent1,
        onSecondary: Colors.white,
        error: Colors.red.shade400,
        onError: Colors.white,
        surface: offWhite,
        onSurface:txtColor);

    var t = ThemeData.from(colorScheme: colorScheme,textTheme: txtTheme).copyWith(
      textSelectionTheme: TextSelectionThemeData(cursorColor: accent1),
      highlightColor: accent1
    );
    return t;
  }

}