import 'package:flutter/material.dart';

class NavStyles {
  static TextStyle base(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle active(BuildContext context) => base(context).copyWith(
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.bold,
      );
}
