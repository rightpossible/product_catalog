import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const FlexScheme usedScheme = FlexScheme.deepBlue;
  static bool useMaterial3 = true;

  static ThemeData get light => FlexThemeData.light(
        scheme: usedScheme,
        appBarElevation: 0.5,
        useMaterial3: useMaterial3,
        typography: Typography.material2021(platform: defaultTargetPlatform),
        textTheme: GoogleFonts.latoTextTheme(),
      );

  static ThemeData get dark => FlexThemeData.dark(
        scheme: usedScheme,
        appBarElevation: 2,
        useMaterial3: useMaterial3,
        typography: Typography.material2021(platform: defaultTargetPlatform),
        textTheme: GoogleFonts.latoTextTheme(),
      );

  static ThemeMode get themeMode => ThemeMode.system;
}
