import 'package:flutter/material.dart';
import 'styles/buttons.dart';
import 'styles/colors.dart';
import 'styles/typography.dart';

class LumbraTheme {
  static final ThemeData light = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: LumbraColors.darkbrown,
      onPrimary: Colors.white,
      secondary: LumbraColors.highlight,
      onSecondary: Colors.white,
      surface: LumbraColors.lightbrown,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: LumbraColors.lightbrown,
    textTheme: LumbraTextStyles.textTheme,
    elevatedButtonTheme: LumbraButtonStyles.ebTheme
  );

  //Para extender a futuro una posibilidad de tener una versión oscura de la web
  static final ThemeData dark = ThemeData();
}