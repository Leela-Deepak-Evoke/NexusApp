import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evoke_nexus_app/app/theme/theme_constants.dart';
import 'package:evoke_nexus_app/app/theme/color_scheme.dart' as colors;

ThemeData appTheme({bool isDark = false}) {
  return ThemeData(
    colorScheme: isDark ? colors.colorSchemeDark : colors.colorSchemeLight,
    fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 96.0, fontWeight: fontWeightLight),
      displayMedium: TextStyle(fontSize: 60.0, fontWeight: fontWeightLight),
      displaySmall: TextStyle(fontSize: 48.0, fontWeight: fontWeightRegular),
      headlineMedium: TextStyle(fontSize: 34.0, fontWeight: fontWeightRegular),
      headlineSmall: TextStyle(fontSize: 24.0, fontWeight: fontWeightRegular),
      titleLarge: TextStyle(fontSize: 20.0, fontWeight: fontWeightMedium),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: fontWeightRegular),
      titleSmall: TextStyle(fontSize: 14.0, fontWeight: fontWeightMedium),
      bodyLarge: TextStyle(fontSize: 16.0, fontWeight: fontWeightRegular),
      bodyMedium: TextStyle(fontSize: 14.0, fontWeight: fontWeightRegular),
      labelLarge: TextStyle(fontSize: 14.0, fontWeight: fontWeightMedium),
      bodySmall: TextStyle(fontSize: 12.0, fontWeight: fontWeightRegular),
      labelSmall: TextStyle(fontSize: 10.0, fontWeight: fontWeightRegular),
    ),
  );
}
