import 'package:flutter/material.dart';

class ThemeDataConfig {
  static final primaryTheme = ThemeData(
    splashColor: XkcdColors.turquoiseGreen,
    scaffoldBackgroundColor: XkcdColors.gallery,
    primarySwatch: XkcdColors.turquoiseGreen.toMaterialColor(),
  );
}

class XkcdColors {
  static const Color gallery = Color(0xFFEBEBEB);
  static const Color turquoiseGreen = Color(0xFFA5D5A7);
  static const Color celadon = Color(0xFFc0f2ba);
  static const Color sandyBrown = Color(0xFFf3a850);
}

extension ColorExtension on Color {
  MaterialColor toMaterialColor() => MaterialColor(value, _color);

  static final Map<int, Color> _color = {
    50: const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };
}
