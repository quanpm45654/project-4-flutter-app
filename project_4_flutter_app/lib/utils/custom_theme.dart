import 'package:flutter/material.dart';

class CustomTheme {
  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF306ED0),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFD09230),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFF800000),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFDADADA),
    onSurface: Color(0xFF000000),
    surfaceContainer: Color(0xFFE6E6E6),
  );

  static final lightTheme = ThemeData(
    colorScheme: _lightColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColorScheme.surfaceContainer,
      foregroundColor: _lightColorScheme.onSurface,
      scrolledUnderElevation: 0.0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _lightColorScheme.surfaceContainer,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: _lightColorScheme.primary,
            fontSize: 16.0,
          );
        }
        return const TextStyle(
          color: Color(0xFF404040),
          fontSize: 16.0,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: _lightColorScheme.primary,
          );
        }
        return const IconThemeData(
          color: Color(0xFF404040),
        );
      }),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: _lightColorScheme.surfaceContainer,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF404040),
    ),
  );
}
