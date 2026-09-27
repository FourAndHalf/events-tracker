import 'package:flutter/material.dart';

import '../charts/series.dart';
import '../theme/aura_colors.dart';

/// Vertical bars with labels underneath and an optional dashed goal line.
class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    required this.bars,
    this.color = Aura.sleep,
    this.height = 160,
    this.goal,
    this.formatValue,
    this.semanticsLabel,
  });

  final List<ChartBar> bars;
  final Color color;
  final double height;
  final double? goal;
  final String Function(double)? formatValue;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: Aura.textSecondary);
    return Semantics(
      label: semanticsLabel,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _BarPainter(
            bars,
            color,
            goal,
            formatValue,
            style ?? const TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter(this.bars, this.color, this.goal, this.formatValue, this.style);

  final List<ChartBar> bars;
  final Color color;
  final double? goal;
  final String Function(double)? formatValue;
  final TextStyle style;

  TextPainter _text(String s, {double? maxWidth}) => TextPainter(
    text: TextSpan(text: s, style: style),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout(maxWidth: maxWidth ?? double.infinity);

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;
    const labelH = 18.0;
    const topPad = 16.0;
    final plotH = size.height - labelH - topPad;
    var maxV = bars
        .map((b) => b.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    if (goal != null && goal! > maxV) maxV = goal!;
    if (maxV <= 0) maxV = 1;

    final slot = size.width / bars.length;
    final barW = (slot * 0.62).clamp(3.0, 40.0);
    final base = topPad + plotH;
    canvas.drawLine(
      Offset(0, base),
      Offset(size.width, base),
      Paint()..color = Aura.rim,
    );

    for (var i = 0; i < bars.length; i++) {
      final b = bars[i];
      final h = plotH * (b.value / maxV);
      final x = slot * i + (slot - barW) / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, base - h, barW, h),
        const Radius.circular(4),
      );
      if (b.value > 0) {
        canvas.drawRRect(rect, Paint()..color = (b.color as Color?) ?? color);
      }
      if (b.label.isNotEmpty) {
        final tp = _text(b.label, maxWidth: slot * 2);
        tp.paint(canvas, Offset(slot * i + (slot - tp.width) / 2, base + 3));
      }
      // Value labels only when there is room for them.
      if (formatValue != null && b.value > 0 && slot >= 34) {
        final tp = _text(formatValue!(b.value), maxWidth: slot);
        tp.paint(
          canvas,
          Offset(slot * i + (slot - tp.width) / 2, base - h - 14),
        );
      }
    }

    if (goal != null) {
      final y = base - plotH * (goal! / maxV);
      final paint = Paint()
        ..color = Aura.money
        ..strokeWidth = 1;
      for (double x = 0; x < size.width; x += 8) {
        canvas.drawLine(Offset(x, y), Offset(x + 4, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
      old.bars != bars || old.color != color || old.goal != goal;
}

/// A polyline through [points] with dots and min/max labels on the left.
class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.points,
    this.color = Aura.invest,
    this.secondary,
    this.secondaryColor = Aura.textMuted,
    this.height = 160,
    this.formatValue,
    this.semanticsLabel,
  });

  final List<ChartPoint> points;
  final Color color;

  /// Optional second series drawn behind, on the same scale (e.g. amount invested).
  final List<ChartPoint>? secondary;
  final Color secondaryColor;
  final double height;
  final String Function(double)? formatValue;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: Aura.textSecondary);
    return Semantics(
      label: semanticsLabel,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _LinePainter(
            points,
            secondary,
            color,
            secondaryColor,
            formatValue,
            style ?? const TextStyle(fontSize: 10),
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
    this.color,
    this.secondaryColor,
    this.formatValue,
    this.style,
  );

  final List<ChartPoint> points;
  final List<ChartPoint>? secondary;
  final Color color;
  final Color secondaryColor;
  final String Function(double)? formatValue;
  final TextStyle style;

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
    canvas.drawLine(
      Offset(left, top + plotH),
      Offset(size.width, top + plotH),
      Paint()..color = Aura.rim,
    );

    void draw(List<ChartPoint> pts, Color c) {
      final line = Paint()
        ..color = c
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;
      final path = Path();
      for (var i = 0; i < pts.length; i++) {
        final o = at(i, pts.length, pts[i].value);
        if (i == 0) {
          path.moveTo(o.dx, o.dy);
        } else {
          path.lineTo(o.dx, o.dy);
        }
      }
      canvas.drawPath(path, line);
      for (var i = 0; i < pts.length; i++) {
        canvas.drawCircle(
          at(i, pts.length, pts[i].value),
          3,
          Paint()..color = c,
        );
      }
    }

    if (secondary != null && secondary!.isNotEmpty) {
      draw(secondary!, secondaryColor);
    }
    draw(points, color);

    // First and last x labels.
    final first = _text(points.first.label);
    first.paint(canvas, Offset(left, size.height - 14));
    if (points.length > 1) {
      final last = _text(points.last.label);
      last.paint(canvas, Offset(size.width - last.width, size.height - 14));
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.points != points || old.secondary != secondary;
}

/// Week / Month (7 or 30 days) switch used above the charts.
class RangeToggle extends StatelessWidget {
  const RangeToggle({super.key, required this.days, required this.onChanged});

  final int days;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<int>(
    showSelectedIcon: false,
    segments: const [
      ButtonSegment(value: 7, label: Text('Week')),
      ButtonSegment(value: 30, label: Text('Month')),
    ],
    selected: {days},
    onSelectionChanged: (s) => onChanged(s.first),
  );
}

/// A titled card holding a chart.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.color,
  });

  final String title;
  final String? subtitle;
  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Aura.surface,
        borderRadius: BorderRadius.circular(Aura.cardRadius),
        border: Border.all(color: Aura.rim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: text.labelSmall?.copyWith(color: color),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: text.bodySmall),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
