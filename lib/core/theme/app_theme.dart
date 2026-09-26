import 'package:flutter/material.dart';

import 'aura_colors.dart';

const _font = 'PlusJakartaSans';

TextStyle _t(double size, double height, FontWeight w, double spacingEm,
        [Color color = Aura.text]) =>
    TextStyle(
      fontFamily: _font,
      fontSize: size,
      height: height / size,
      fontWeight: w,
      letterSpacing: size * spacingEm,
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

final auraTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: _font,
  scaffoldBackgroundColor: Aura.canvas,
  colorScheme: const ColorScheme.dark(
    surface: Aura.canvas,
    primary: Aura.sleep,
    onPrimary: Aura.canvas,
    secondary: Aura.habit,
    tertiary: Aura.money,
    error: Aura.danger,
    onSurface: Aura.text,
    outline: Aura.rim,
    surfaceContainerHighest: Aura.raised,
  ),
  textTheme: TextTheme(
    headlineMedium: _t(28, 36, FontWeight.w700, -0.02),
    titleLarge: _t(22, 30, FontWeight.w600, -0.015),
    titleMedium: _t(18, 26, FontWeight.w600, -0.01),
    bodyLarge: _t(16, 24, FontWeight.w400, -0.005),
    bodyMedium: _t(14, 22, FontWeight.w400, 0),
    bodySmall: _t(12, 18, FontWeight.w400, 0.01, Aura.textSecondary),
    labelLarge: _t(14, 20, FontWeight.w600, 0.01),
    labelMedium: _t(12, 16, FontWeight.w600, 0.02),
    labelSmall: _t(10, 14, FontWeight.w700, 0.06, Aura.textSecondary),
    displaySmall: _t(32, 38, FontWeight.w700, -0.03),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Aura.canvas,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Aura.canvas,
    indicatorColor: Aura.raised,
    surfaceTintColor: Colors.transparent,
    labelTextStyle: WidgetStatePropertyAll(_t(11, 14, FontWeight.w600, 0.02)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Aura.input,
    hintStyle: const TextStyle(color: Aura.textMuted),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Aura.innerRadius),
      borderSide: const BorderSide(color: Aura.rim),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Aura.innerRadius),
      borderSide: const BorderSide(color: Aura.rim),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Aura.innerRadius),
      borderSide: const BorderSide(color: Aura.sleep),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: Aura.raised,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Aura.raised,
    surfaceTintColor: Colors.transparent,
  ),
);
