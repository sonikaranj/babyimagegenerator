import 'package:babyimage/const/color/color.dart';
import 'package:flutter/material.dart';


class AppThemes {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: LightThemeColors.primary,
      // backgroundColor: LightThemeColors.background,
      scaffoldBackgroundColor: LightThemeColors.background,
      // textTheme: TextTheme(
      //   bodyText1: TextStyle(color: LightThemeColors.textPrimary),
      //   bodyText2: TextStyle(color: LightThemeColors.textSecondary),
      // ),
      colorScheme: const ColorScheme.light(
        primary: LightThemeColors.primary,
        secondary: LightThemeColors.secondary,
      ),
      // errorColor: LightThemeColors.error,
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: DarkThemeColors.primary,
      // backgroundColor: DarkThemeColors.background,
      scaffoldBackgroundColor: DarkThemeColors.background,
      // textTheme: TextTheme(
      //   bodyText1: TextStyle(color: DarkThemeColors.textPrimary),
      //   bodyText2: TextStyle(color: DarkThemeColors.textSecondary),
      // ),
      colorScheme: const ColorScheme.dark(
        primary: DarkThemeColors.primary,
        secondary: DarkThemeColors.secondary,
      ),
      // errorColor: DarkThemeColors.error,
    );
  }
}
