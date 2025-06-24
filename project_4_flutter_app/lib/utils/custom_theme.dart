import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';

class CustomTheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0080FF),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFFF8000),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFFF0000),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    surfaceContainer: Color(0xFFFAFAFA),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF80C0FF),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFFFFC080),
    onSecondary: Color(0xFF000000),
    error: Color(0xFFFF8080),
    onError: Color(0xFF000000),
    surface: Color(0xFF343434),
    onSurface: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFF404040),
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
            fontSize: CustomFontSize.extraSmall,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: Color(0xFF808080),
          fontSize: CustomFontSize.extraSmall,
          fontWeight: FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: lightColorScheme.primary,
            size: CustomIconSize.large,
          );
        }
        return const IconThemeData(
          color: Color(0xFF808080),
          size: CustomIconSize.medium,
        );
      }),
      height: 72,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomRadius.medium),
      ),
      color: lightColorScheme.surfaceContainer,
    ),
    dividerTheme: DividerThemeData(
      color: const Color(0xFF808080),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surfaceContainer,
      foregroundColor: darkColorScheme.onSurface,
      scrolledUnderElevation: 0.0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkColorScheme.surfaceContainer,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: darkColorScheme.primary,
            fontSize: CustomFontSize.extraSmall,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: Color(0xFFBEBEBE),
          fontSize: CustomFontSize.extraSmall,
          fontWeight: FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: darkColorScheme.primary,
            size: CustomIconSize.large,
          );
        }
        return const IconThemeData(
          color: Color(0xFFBEBEBE),
          size: CustomIconSize.medium,
        );
      }),
      height: 72,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomRadius.medium),
      ),
      color: darkColorScheme.surfaceContainer,
    ),
    dividerTheme: DividerThemeData(
      color: const Color(0xFFBEBEBE),
    ),
  );
}
