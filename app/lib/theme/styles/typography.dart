import 'colors.dart';
import 'package:flutter/material.dart';

/// Fuente principal usada en toda la app
const String kFontFamily = 'Playfair Display';

/// Tamaños de texto
class _FontSizes {
  static const double headlineLarge = 32;
  static const double titleLarge = 20;
  static const double titleMedium = 18;
  static const double bodyLarge = 16;
  static const double bodyMedium = 14;
  static const double label = 14;
}

/// Pesos de fuente
class _FontWeights {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight bold = FontWeight.w600;
}

class LumbraTextStyles {
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: _FontSizes.headlineLarge,
      fontWeight: _FontWeights.bold,
      color: LumbraColors.darkbrown,
      fontFamily: kFontFamily,
    ),
    titleLarge: TextStyle(
      fontSize: _FontSizes.titleLarge,
      fontWeight: _FontWeights.bold,
      color: LumbraColors.brown,
      fontFamily: kFontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: _FontSizes.titleMedium,
      fontWeight: _FontWeights.bold,
      color: LumbraColors.brown,
      fontFamily: kFontFamily,
    ),
    bodyLarge: TextStyle(
      fontSize: _FontSizes.bodyLarge,
      fontWeight: _FontWeights.regular,
      color: LumbraColors.text,
      fontFamily: kFontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: _FontSizes.bodyMedium,
      fontWeight: _FontWeights.regular,
      color: LumbraColors.text,
      fontFamily: kFontFamily,
    ),
    labelSmall: TextStyle(
      fontSize: _FontSizes.label,
      fontWeight: _FontWeights.bold,
      color: LumbraColors.darkbrown,
      fontFamily: kFontFamily,
      letterSpacing: 0.5,
      fontFeatures: [FontFeature.enable('smcp')], // small-caps
    )
  );
}