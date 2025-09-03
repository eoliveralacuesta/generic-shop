import 'package:app/theme/styles/typography.dart';
import 'package:flutter/material.dart';
import './colors.dart';

class LumbraButtonStyles {
  static final ElevatedButtonThemeData ebTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.hovered)) {
            return LumbraColors.brown; // hover → fondo marrón fuerte
          }
          return LumbraColors.lightbrown; // normal
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.white; // hover → texto e ícono blancos
          }
          return LumbraColors.darkbrown; // normal → marrón oscuro
        },
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      ),
      textStyle: WidgetStateProperty.all(
        LumbraTextStyles.textTheme.bodyLarge,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    ),
  );
}
