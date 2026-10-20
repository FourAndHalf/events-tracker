import 'package:flutter/material.dart';

import '../charts/series.dart';
import '../theme/app_theme.dart';
import '../theme/pearl_colors.dart';
import 'pearl_widgets.dart';

/// Thin vertical bars in light gray with the current (last) period in
/// charcoal under a dark callout pill. No gridlines; a muted axis of labels
/// with the current one in ink. An optional [goal] draws a dashed line, and
/// bars that reach it get a small champagne marker.
class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    required this.bars,
    this.height = 160,
    this.goal,
    this.formatValue,
    this.semanticsLabel,
  });

  final List<ChartBar> bars;
  final double height;
  final double? goal;
  final String Function(double)? formatValue;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final axis = Theme.of(context).textTheme.labelSmall;
    return Semantics(
      label: semanticsLabel,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _BarPainter(
            bars: bars,
            goal: goal,
            formatValue: formatValue,
            axis: axis ?? const TextStyle(fontSize: 10),
            colors: c,
          ),
        ),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter({
    required this.bars,
    required this.goal,
    required this.formatValue,
    required this.axis,
    required this.colors,
  });

  final List<ChartBar> bars;
  final double? goal;
  final String Function(double)? formatValue;
  final TextStyle axis;
  final PearlColors colors;

  TextPainter _text(String s, TextStyle style, {double? maxWidth}) =>
      TextPainter(
        text: TextSpan(text: s, style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(maxWidth: maxWidth ?? double.infinity);

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;
    const labelH = 18.0;
    const topPad = 26.0; // room for the callout pill
    final plotH = size.height - labelH - topPad;
    var maxV = bars
        .map((b) => b.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    if (goal != null && goal! > maxV) maxV = goal!;
    if (maxV <= 0) maxV = 1;

    final slot = size.width / bars.length;
    final barW = (slot * 0.28).clamp(3.0, 10.0);
    final base = topPad + plotH;
    final current = bars.length - 1;

    for (var i = 0; i < bars.length; i++) {
      final b = bars[i];
      final h = plotH * (b.value / maxV);
      final cx = slot * i + slot / 2;
      if (b.value > 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - barW / 2, base - h, barW, h),
            Radius.circular(barW / 2),
          ),
          Paint()..color = i == current ? colors.anchor : colors.barIdle,
        );
        if (goal != null && b.value >= goal!) {
          canvas.drawCircle(
            Offset(cx, base - h - 5),
            2,
            Paint()..color = colors.champagne,
          );
        }
      }
      if (b.label.isNotEmpty) {
        final tp = _text(
          b.label,
          axis.copyWith(color: i == current ? colors.ink : colors.muted),
          maxWidth: slot * 2,
        );
        tp.paint(canvas, Offset(cx - tp.width / 2, base + 4));
      }
    }

    if (goal != null) {
      final y = base - plotH * (goal! / maxV);
      final paint = Paint()
        ..color = colors.outline
        ..strokeWidth = 1;
      for (double x = 0; x < size.width; x += 6) {
        canvas.drawLine(Offset(x, y), Offset(x + 3, y), paint);
      }
    }

    // Dark callout over the current bar.
    final last = bars[current];
    if (formatValue != null && last.value > 0) {
      final h = plotH * (last.value / maxV);
      final tp = _text(
        formatValue!(last.value),
        PearlType.metricDelta.copyWith(color: colors.onAnchor),
      );
      final w = tp.width + 12;
      final cx = (slot * current + slot / 2).clamp(w / 2, size.width - w / 2);
      final top = (base - h - 24).clamp(0.0, size.height);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - w / 2, top, w, 18),
          const Radius.circular(9),
        ),
        Paint()..color = colors.anchor,
      );
      tp.paint(canvas, Offset(cx - tp.width / 2, top + (18 - tp.height) / 2));
    }
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
      old.bars != bars || old.goal != goal || old.colors != colors;
}

/// A 1.5px charcoal line with a faint area fill fading to transparent, min/max
/// labels on the left and first/last labels underneath. An optional
/// [secondary] series is drawn dashed and muted on the same scale.
class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.points,
    this.secondary,
    this.height = 160,
    this.formatValue,
    this.semanticsLabel,
  });

  final List<ChartPoint> points;
  final List<ChartPoint>? secondary;
  final double height;
  final String Function(double)? formatValue;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final axis = Theme.of(context).textTheme.labelSmall;
    return Semantics(
      label: semanticsLabel,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _LinePainter(
            points,
            secondary,
            formatValue,
            axis ?? const TextStyle(fontSize: 10),
            context.pearl,
          ),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(
    this.points,
    this.secondary,
    this.formatValue,
    this.style,
    this.colors,
  );

  final List<ChartPoint> points;
  final List<ChartPoint>? secondary;
  final String Function(double)? formatValue;
  final TextStyle style;
  final PearlColors colors;

  TextPainter _text(String s) => TextPainter(
    text: TextSpan(text: s, style: style),
    textDirection: TextDirection.ltr,
  )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final all = [...points, ...?secondary].map((p) => p.value);
    var minV = all.reduce((a, b) => a < b ? a : b);
    var maxV = all.reduce((a, b) => a > b ? a : b);
    if (maxV == minV) {
      maxV += 1;
      minV -= 1;
    }
    final fmt = formatValue ?? (v) => v.toStringAsFixed(0);
    final maxL = _text(fmt(maxV));
    final minL = _text(fmt(minV));
    final left = (maxL.width > minL.width ? maxL.width : minL.width) + 8;
    const top = 8.0;
    const bottom = 20.0;
    final plotW = size.width - left;
    final plotH = size.height - top - bottom;

    Offset at(int i, int n, double v) => Offset(
      left + (n == 1 ? plotW / 2 : plotW * i / (n - 1)),
      top + plotH * (1 - (v - minV) / (maxV - minV)),
    );

    maxL.paint(canvas, const Offset(0, top - 6));
    minL.paint(canvas, Offset(0, top + plotH - 6));

    Path pathOf(List<ChartPoint> pts) {
      final path = Path();
      for (var i = 0; i < pts.length; i++) {
        final o = at(i, pts.length, pts[i].value);
        i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      }
      return path;
    }

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    if (secondary != null && secondary!.length > 1) {
      final metric = pathOf(secondary!).computeMetrics();
      final dashed = Path();
      for (final m in metric) {
        for (double d = 0; d < m.length; d += 8) {
          dashed.addPath(m.extractPath(d, d + 4), Offset.zero);
        }
      }
      canvas.drawPath(dashed, stroke..color = colors.outline);
    }

    final line = pathOf(points);
    if (points.length > 1) {
      final first = at(0, points.length, points.first.value);
      final last = at(points.length - 1, points.length, points.last.value);
      final area = Path.from(line)
        ..lineTo(last.dx, top + plotH)
        ..lineTo(first.dx, top + plotH)
        ..close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.anchor.withValues(alpha: 0.08),
              colors.anchor.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromLTWH(0, top, size.width, plotH)),
      );
    }
    canvas.drawPath(line, stroke..color = colors.anchor);
    // Mark the latest point.
    canvas.drawCircle(
      at(points.length - 1, points.length, points.last.value),
      3,
      Paint()..color = colors.anchor,
    );

    final firstL = _text(points.first.label);
    firstL.paint(canvas, Offset(left, size.height - 14));
    if (points.length > 1) {
      final lastL = _text(points.last.label);
      lastL.paint(canvas, Offset(size.width - lastL.width, size.height - 14));
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.points != points ||
      old.secondary != secondary ||
      old.colors != colors;
}

/// Week / Month (7 or 30 days) switch used above the charts.
class RangeToggle extends StatelessWidget {
  const RangeToggle({super.key, required this.days, required this.onChanged});

  final int days;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Segmented<int>(
    segments: const [(7, 'Week'), (30, 'Month')],
    selected: days,
    onChanged: onChanged,
  );
}

/// A module holding a chart, titled in headline-md with a muted subtitle.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Module(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModuleHeader(title: title, subtitle: subtitle),
        const SizedBox(height: Pearl.spaceMd),
        child,
      ],
    ),
  );
}
