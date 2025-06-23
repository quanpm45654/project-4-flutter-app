import 'package:flutter/material.dart';

class CustomTheme {
  static final lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF3F51B5),
    onPrimary: Colors.white,
    secondary: const Color(0xFFFF7043),
    onSecondary: Colors.white,
    error: Colors.red.shade700,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black87,
    surfaceContainer: const Color(0xFFFAFAFA),
  );

  static final darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF9FA8DA),
    onPrimary: Colors.black,
    secondary: const Color(0xFFFFAB91),
    onSecondary: Colors.black,
    error: Colors.red.shade400,
    onError: Colors.black,
    surface: const Color(0xFF1E1E1E),
    onSurface: Colors.white,
    surfaceContainer: const Color(0xFF252525),
  );

  static final lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: lightColorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightColorScheme.surface,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: lightColorScheme.primary,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: lightColorScheme.primary, size: 32);
        }
        return IconThemeData(color: Colors.grey[600], size: 24);
      }),
      height: 72,
    ),
    cardTheme: CardThemeData(
      color: lightColorScheme.surfaceContainer,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: lightColorScheme.surfaceContainer,
    ),
  );

  static final darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: darkColorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkColorScheme.surface,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: darkColorScheme.primary,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: darkColorScheme.primary, size: 32);
        }
        return IconThemeData(color: Colors.grey[400], size: 24);
      }),
      height: 72,
    ),
    cardTheme: CardThemeData(
      color: darkColorScheme.surfaceContainer,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: darkColorScheme.surfaceContainer,
    )
  );
}
