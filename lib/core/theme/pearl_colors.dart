import 'package:flutter/material.dart';

/// Pearl Ledger colour roles (see design/DESIGN.md), one set per brightness.
/// Read them with `context.pearl`.
@immutable
class PearlColors extends ThemeExtension<PearlColors> {
  const PearlColors({
    required this.canvas,
    required this.module,
    required this.inner,
    required this.high,
    required this.raised,
    required this.ink,
    required this.muted,
    required this.outline,
    required this.hairline,
    required this.divider,
    required this.anchor,
    required this.onAnchor,
    required this.anchorPressed,
    required this.champagne,
    required this.champagneContainer,
    required this.positive,
    required this.positiveContainer,
    required this.negative,
    required this.negativeContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.barIdle,
    required this.dotEmpty,
    required this.highlight,
    required this.shadow,
    required this.scrim,
    required this.heroStart,
    required this.heroEnd,
  });

  /// Page background behind the modules.
  final Color canvas;

  /// Resting module (card) surface.
  final Color module;

  /// Inner panel: a module inside a module.
  final Color inner;
  final Color high;

  /// Raised controls, inputs, sheets and dialogs (white in light).
  final Color raised;

  final Color ink;
  final Color muted;
  final Color outline;

  /// 1px borders on raised controls and inputs, track of gauges.
  final Color hairline;

  /// List row dividers.
  final Color divider;

  /// The single strong tone: primary button, selected nav, active bar.
  final Color anchor;
  final Color onAnchor;
  final Color anchorPressed;

  /// Premium moments only; at most one per screen.
  final Color champagne;
  final Color champagneContainer;

  final Color positive;
  final Color positiveContainer;
  final Color negative;
  final Color negativeContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color infoContainer;

  /// Chart bars that are not the current period.
  final Color barIdle;

  /// Empty dots in dot-matrix visuals.
  final Color dotEmpty;

  /// Top-left highlight edge on modules.
  final Color highlight;

  /// Base colour for the soft shadows.
  final Color shadow;
  final Color scrim;

  /// Soft pearl wash for the one hero module on a screen.
  final Color heroStart;
  final Color heroEnd;

  LinearGradient get heroGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [heroStart, heroEnd],
  );

  static const light = PearlColors(
    canvas: Color(0xFFE8E8EA),
    module: Color(0xFFF1F1F3),
    inner: Color(0xFFECECEE),
    high: Color(0xFFE6E6E9),
    raised: Color(0xFFFFFFFF),
    ink: Color(0xFF1C1C1E),
    muted: Color(0xFF626267),
    outline: Color(0xFFA1A1A6),
    hairline: Color(0xFFDADADD),
    divider: Color(0xFFE0E0E3),
    anchor: Color(0xFF2A2A2D),
    onAnchor: Color(0xFFFFFFFF),
    anchorPressed: Color(0xFF3A3A3D),
    champagne: Color(0xFF7A6A47),
    champagneContainer: Color(0xFFEDE6D6),
    positive: Color(0xFF23784A),
    positiveContainer: Color(0xFFDDF0E4),
    negative: Color(0xFFB33A35),
    negativeContainer: Color(0xFFF9DEDC),
    warning: Color(0xFF8A5A0F),
    warningContainer: Color(0xFFF6E7CC),
    info: Color(0xFF3F5F80),
    infoContainer: Color(0xFFDFE8F1),
    barIdle: Color(0xFFC9C9CD),
    dotEmpty: Color(0xFFD4D4D8),
    highlight: Color(0xB3FFFFFF),
    shadow: Color(0xFF141419),
    scrim: Color(0x471C1C1E),
    heroStart: Color(0xFFF6F4EF),
    heroEnd: Color(0xFFE9E6DE),
  );

  static const dark = PearlColors(
    canvas: Color(0xFF0F0F11),
    module: Color(0xFF161618),
    inner: Color(0xFF1C1C1F),
    high: Color(0xFF232326),
    raised: Color(0xFF1C1C1F),
    ink: Color(0xFFECECEE),
    muted: Color(0xFFA0A0A6),
    outline: Color(0xFF5A5A60),
    hairline: Color(0xFF2C2C30),
    divider: Color(0xFF2C2C30),
    anchor: Color(0xFFECECEE),
    onAnchor: Color(0xFF161618),
    anchorPressed: Color(0xFFD6D6DA),
    champagne: Color(0xFFCDBB92),
    champagneContainer: Color(0xFF2A261D),
    positive: Color(0xFF5BBF86),
    positiveContainer: Color(0xFF1B2B21),
    negative: Color(0xFFE5726B),
    negativeContainer: Color(0xFF2E1C1B),
    warning: Color(0xFFD9A54A),
    warningContainer: Color(0xFF2D2516),
    info: Color(0xFF8FB0D3),
    infoContainer: Color(0xFF1A2430),
    barIdle: Color(0xFF3A3A3F),
    dotEmpty: Color(0xFF2C2C30),
    highlight: Color(0x0AFFFFFF),
    shadow: Color(0xFF000000),
    scrim: Color(0x8C000000),
    heroStart: Color(0xFF1E1E21),
    heroEnd: Color(0xFF161618),
  );

  @override
  PearlColors copyWith() => this;

  @override
  PearlColors lerp(PearlColors? other, double t) =>
      other == null || t < 0.5 ? this : other;
}

extension PearlContext on BuildContext {
  PearlColors get pearl =>
      Theme.of(this).extension<PearlColors>() ?? PearlColors.light;
}

/// Shape and spacing scale.
abstract final class Pearl {
  static const radiusSm = 8.0;
  static const radiusMd = 14.0;
  static const radiusLg = 20.0;
  static const radiusXl = 28.0;

  static const margin = 16.0;
  static const gutter = 10.0;
  static const cardPadding = 16.0;
  static const spaceXs = 4.0;
  static const spaceSm = 8.0;
  static const spaceMd = 16.0;
  static const spaceLg = 24.0;

  static const motion = Duration(milliseconds: 220);
}
