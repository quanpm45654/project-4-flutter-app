import 'package:flutter/material.dart';

class CustomTheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF306ED0),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFD09230),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFF800000),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFE6E6E6),
    onSurface: Color(0xFF000000),
    surfaceContainer: Color(0xFFF2F2F2),
  );

  static final lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surfaceContainer,
      foregroundColor: lightColorScheme.onSurface,
      scrolledUnderElevation: 0.0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightColorScheme.surfaceContainer,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: lightColorScheme.primary,
          );
        }
        return const TextStyle(
          color: Color(0xFF404040),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: lightColorScheme.primary,
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
      color: lightColorScheme.surfaceContainer,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF404040),
    ),
  );
}
