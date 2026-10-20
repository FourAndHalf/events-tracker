import 'package:flutter/material.dart';

import 'pearl_colors.dart';

const _font = 'JetBrainsMono';

TextStyle _t(double size, double height, FontWeight w, double spacingEm) =>
    TextStyle(
      fontFamily: _font,
      fontSize: size,
      height: height / size,
      fontWeight: w,
      letterSpacing: size * spacingEm,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

/// Pearl Ledger type styles that have no Material text-theme slot. They carry
/// no colour, so they take the surrounding ink.
abstract final class PearlType {
  static final metricHero = _t(32, 38, FontWeight.w500, -0.045);
  static final metricCard = _t(18, 24, FontWeight.w500, -0.03);
  static final metricTable = _t(13, 18, FontWeight.w500, -0.01);
  static final metricDelta = _t(10, 12, FontWeight.w600, 0);
  static final ledger = _t(12, 18, FontWeight.w400, 0);
  static final labelUppercase = _t(10, 12, FontWeight.w600, 0.08);
}

final pearlLightTheme = _build(PearlColors.light, Brightness.light);
final pearlDarkTheme = _build(PearlColors.dark, Brightness.dark);

ThemeData _build(PearlColors c, Brightness brightness) {
  TextStyle ink(TextStyle s) => s.copyWith(color: c.ink);
  TextStyle muted(TextStyle s) => s.copyWith(color: c.muted);

  final text = TextTheme(
    displaySmall: ink(PearlType.metricHero),
    headlineMedium: ink(_t(22, 28, FontWeight.w500, -0.03)),
    headlineSmall: ink(_t(18, 24, FontWeight.w500, -0.02)),
    titleLarge: ink(_t(18, 24, FontWeight.w500, -0.02)),
    titleMedium: ink(_t(14, 20, FontWeight.w600, -0.01)),
    titleSmall: ink(_t(13, 19, FontWeight.w500, 0)),
    bodyLarge: ink(_t(15, 22, FontWeight.w400, 0)),
    bodyMedium: ink(_t(13, 19, FontWeight.w400, 0)),
    bodySmall: muted(_t(11, 15, FontWeight.w400, 0)),
    labelLarge: ink(_t(13, 18, FontWeight.w500, 0)),
    labelMedium: muted(_t(11, 14, FontWeight.w500, 0)),
    labelSmall: muted(_t(10, 12, FontWeight.w600, 0)),
  );

  final scheme = ColorScheme(
    brightness: brightness,
    surface: c.canvas,
    onSurface: c.ink,
    onSurfaceVariant: c.muted,
    surfaceContainerLowest: c.raised,
    surfaceContainerLow: c.module,
    surfaceContainer: c.inner,
    surfaceContainerHigh: c.high,
    surfaceContainerHighest: c.high,
    primary: c.anchor,
    onPrimary: c.onAnchor,
    primaryContainer: c.anchorPressed,
    onPrimaryContainer: c.onAnchor,
    secondary: c.muted,
    onSecondary: c.onAnchor,
    secondaryContainer: c.inner,
    onSecondaryContainer: c.ink,
    tertiary: c.champagne,
    onTertiary: c.onAnchor,
    tertiaryContainer: c.champagneContainer,
    onTertiaryContainer: c.champagne,
    error: c.negative,
    onError: c.onAnchor,
    errorContainer: c.negativeContainer,
    onErrorContainer: c.negative,
    outline: c.outline,
    outlineVariant: c.hairline,
    inverseSurface: c.anchor,
    onInverseSurface: c.onAnchor,
    shadow: c.shadow,
    scrim: c.scrim,
    surfaceTint: Colors.transparent,
  );

  OutlineInputBorder field(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(Pearl.radiusMd),
        borderSide: BorderSide(color: color, width: width),
      );

  const pill = StadiumBorder();
  final buttonText = WidgetStatePropertyAll(text.labelLarge);
  const buttonSize = WidgetStatePropertyAll(Size(64, 48));
  const buttonPadding = WidgetStatePropertyAll(
    EdgeInsets.symmetric(horizontal: 20),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: _font,
    colorScheme: scheme,
    textTheme: text,
    scaffoldBackgroundColor: c.canvas,
    canvasColor: c.canvas,
    extensions: [c],
    dividerTheme: DividerThemeData(color: c.divider, thickness: 1, space: 1),
    iconTheme: IconThemeData(color: c.ink, size: 20),
    appBarTheme: AppBarTheme(
      backgroundColor: c.canvas,
      foregroundColor: c.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge,
      actionsPadding: const EdgeInsets.only(right: 8),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(pill),
        minimumSize: buttonSize,
        padding: buttonPadding,
        textStyle: buttonText,
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled)
              ? c.hairline
              : s.contains(WidgetState.pressed)
              ? c.anchorPressed
              : c.anchor,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? c.muted : c.onAnchor,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(pill),
        minimumSize: buttonSize,
        padding: buttonPadding,
        textStyle: buttonText,
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.pressed) ? c.module : c.raised,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? c.outline : c.ink,
        ),
        side: WidgetStatePropertyAll(BorderSide(color: c.hairline)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(pill),
        textStyle: buttonText,
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? c.outline : c.ink,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled) ? c.outline : c.ink,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: c.anchor,
      foregroundColor: c.onAnchor,
      elevation: 2,
      focusElevation: 2,
      hoverElevation: 2,
      highlightElevation: 2,
      shape: const CircleBorder(),
      sizeConstraints: const BoxConstraints.tightFor(width: 56, height: 56),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: c.raised,
      selectedColor: c.anchor,
      disabledColor: c.inner,
      checkmarkColor: c.onAnchor,
      showCheckmark: false,
      side: BorderSide(color: c.hairline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Pearl.radiusSm),
      ),
      labelStyle: text.labelLarge,
      secondaryLabelStyle: text.labelLarge?.copyWith(color: c.onAnchor),
      iconTheme: IconThemeData(color: c.ink, size: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(pill),
        textStyle: buttonText,
        side: WidgetStatePropertyAll(BorderSide(color: c.hairline)),
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.raised : c.inner,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.ink : c.muted,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.raised,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: text.labelMedium,
      floatingLabelStyle: text.labelMedium,
      hintStyle: text.bodyMedium?.copyWith(color: c.outline),
      helperStyle: text.bodySmall,
      prefixIconColor: c.muted,
      suffixIconColor: c.muted,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: field(c.hairline),
      enabledBorder: field(c.hairline),
      disabledBorder: field(c.divider),
      focusedBorder: field(c.anchor, 1.5),
      errorBorder: field(c.negative),
      focusedErrorBorder: field(c.negative, 1.5),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.onAnchor : c.raised,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.anchor : c.hairline,
      ),
      trackOutlineColor: WidgetStatePropertyAll(c.hairline),
    ),
    listTileTheme: ListTileThemeData(
      minTileHeight: 56,
      iconColor: c.ink,
      textColor: c.ink,
      titleTextStyle: text.bodyMedium,
      subtitleTextStyle: text.bodySmall,
      leadingAndTrailingTextStyle: PearlType.metricTable.copyWith(color: c.ink),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Pearl.radiusMd),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.anchor,
      linearTrackColor: c.hairline,
      circularTrackColor: c.hairline,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.raised,
      surfaceTintColor: Colors.transparent,
      barrierColor: c.scrim,
      elevation: 24,
      shadowColor: c.shadow.withValues(alpha: 0.35),
      titleTextStyle: text.titleLarge,
      contentTextStyle: text.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Pearl.radiusXl),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.raised,
      surfaceTintColor: Colors.transparent,
      modalBarrierColor: c.scrim,
      showDragHandle: true,
      dragHandleColor: c.hairline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Pearl.radiusXl),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.anchor,
      contentTextStyle: text.bodyMedium?.copyWith(color: c.onAnchor),
      actionTextColor: c.onAnchor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Pearl.radiusMd),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: c.anchor,
        borderRadius: BorderRadius.circular(Pearl.radiusSm),
      ),
      textStyle: text.labelMedium?.copyWith(color: c.onAnchor),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: c.raised,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: c.raised,
      headerForegroundColor: c.ink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Pearl.radiusXl),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: c.raised,
      dialBackgroundColor: c.inner,
      hourMinuteColor: c.inner,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Pearl.radiusXl),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: c.raised,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Pearl.radiusMd),
      ),
    ),
  );
}
