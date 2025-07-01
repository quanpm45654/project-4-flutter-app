import 'package:flutter/material.dart';

class CustomTheme {
  static const _blue = Color(0xFF306ED0);
  static const _gold = Color(0xFFD09230);
  static const _darkerRed = Color(0xFF800000);
  static const _white = Color(0xFFE6E6E6);
  static const _darkerWhite = Color(0xFFDADADA);
  static const _black = Color(0xFF1A1A1A);
  static const _gray = Color(0xFF808080);
  static const _darkerGray = Color(0xFF404040);

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _blue,
    onPrimary: _white,
    secondary: _gold,
    onSecondary: _white,
    error: _darkerRed,
    onError: _white,
    surface: _darkerWhite,
    onSurface: _black,
    surfaceContainer: _white,
    outline: _darkerGray,
    outlineVariant: _gray,
    shadow: _black,
  );

  static final lightTheme = ThemeData(
    colorScheme: _lightColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColorScheme.surfaceContainer,
      foregroundColor: _lightColorScheme.onSurface,
      scrolledUnderElevation: 2.0,
      elevation: 2.0,
      shadowColor: _lightColorScheme.shadow,
      surfaceTintColor: Colors.transparent,
    ),
    tabBarTheme: TabBarThemeData(
      dividerColor: _lightColorScheme.outlineVariant,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _lightColorScheme.primary,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: _lightColorScheme.surfaceContainer,
            fontSize: 16.0,
          );
        }
        return TextStyle(
          color: _lightColorScheme.outlineVariant,
          fontSize: 16.0,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: _lightColorScheme.surfaceContainer,
          );
        }
        return IconThemeData(
          color: _lightColorScheme.outlineVariant,
        );
      }),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: _lightColorScheme.surfaceContainer,
    ),
    dividerTheme: DividerThemeData(
      color: _lightColorScheme.outlineVariant,
    ),
  );
}
