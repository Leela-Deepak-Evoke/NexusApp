import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/theme/app_theme.dart';

final StateProvider<ThemeMode> themeModeProvider =
    StateProvider<ThemeMode>((StateProviderRef<ThemeMode> ref) {
  return ThemeMode.light;
});

final StateProvider<ThemeData> lightThemeProvider =
    StateProvider<ThemeData>((StateProviderRef<ThemeData> ref) {
  return appTheme(isDark: false);
});

final StateProvider<ThemeData> darkThemeProvider =
    StateProvider<ThemeData>((StateProviderRef<ThemeData> ref) {
  return appTheme(isDark: true);
});
