import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/pearl_colors.dart';

/// A gently raised tile on the canvas: module surface, a light top-left edge
/// and a soft two-layer shadow. [large] uses the xl radius for hero modules.
class Module extends StatelessWidget {
  const Module({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Pearl.cardPadding),
    this.onTap,
    this.large = false,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool large;

  /// The one decorative surface allowed on a screen.
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final radius = BorderRadius.circular(
      large ? Pearl.radiusXl : Pearl.radiusLg,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.module,
        gradient: gradient,
        borderRadius: radius,
        border: Border.all(color: c.highlight),
        boxShadow: [
          BoxShadow(
            color: c.shadow.withValues(alpha: 0.04),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
          BoxShadow(
            color: c.shadow.withValues(alpha: 0.06),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// A module inside a module: one tone darker, no shadow.
class InnerPanel extends StatelessWidget {
  const InnerPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: context.pearl.inner,
      borderRadius: BorderRadius.circular(Pearl.radiusMd),
    ),
    child: child,
  );
}

/// Module title in headline-md with an optional muted subtitle and a trailing
/// action (a "View all" pill or an icon button).
class ModuleHeader extends StatelessWidget {
  const ModuleHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.titleMedium),
              if (subtitle != null) Text(subtitle!, style: text.bodySmall),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Sentence-case heading for a group of modules or rows on a page.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: Pearl.spaceSm),
    child: Row(
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleMedium),
        ),
        ?trailing,
      ],
    ),
  );
}

enum PillVariant { primary, secondary, destructive }

/// 48px full-pill button: charcoal primary, white secondary, or white with a
/// red border for destructive actions.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = PillVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PillVariant variant;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final enabled = onPressed != null;
    final primary = variant == PillVariant.primary;
    final fg = !enabled
        ? c.outline
        : switch (variant) {
            PillVariant.primary => c.onAnchor,
            PillVariant.secondary => c.ink,
            PillVariant.destructive => c.negative,
          };
    final bg = primary ? (enabled ? c.anchor : c.hairline) : c.raised;
    final border = switch (variant) {
      PillVariant.primary => BorderSide.none,
      PillVariant.secondary => BorderSide(color: c.hairline),
      PillVariant.destructive => BorderSide(
        color: enabled ? c.negative : c.hairline,
      ),
    };
    return Material(
      color: bg,
      shape: StadiumBorder(side: border),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        highlightColor: primary ? c.anchorPressed : c.module,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: fg),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: fg),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 44px white circle with a hairline border and a 20px ink icon.
class PearlIconButton extends StatelessWidget {
  const PearlIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.selected = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  /// Charcoal fill with a white icon, e.g. a running timer or a checked habit.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final button = Material(
      color: selected ? c.anchor : c.raised,
      shape: CircleBorder(
        side: BorderSide(color: selected ? c.anchor : c.hairline),
      ),
      shadowColor: c.shadow.withValues(alpha: 0.06),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 20,
            color: onPressed == null
                ? c.outline
                : (selected ? c.onAnchor : c.ink),
          ),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip, child: button);
  }
}

enum BadgeTone { neutral, positive, negative, warning, info, champagne, dark }

/// 22px status pill: container colour plus text colour from the semantic set.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.tone = BadgeTone.neutral,
    this.icon,
  });

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final (bg, fg) = switch (tone) {
      BadgeTone.neutral => (c.inner, c.muted),
      BadgeTone.positive => (c.positiveContainer, c.positive),
      BadgeTone.negative => (c.negativeContainer, c.negative),
      BadgeTone.warning => (c.warningContainer, c.warning),
      BadgeTone.info => (c.infoContainer, c.info),
      BadgeTone.champagne => (c.champagneContainer, c.champagne),
      BadgeTone.dark => (c.anchor, c.onAnchor),
    };
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Pearl.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(label, style: PearlType.metricDelta.copyWith(color: fg)),
        ],
      ),
    );
  }
}

/// 36px circular icon chip: white fill, hairline border, ink icon.
class IconChip extends StatelessWidget {
  const IconChip({super.key, required this.icon, this.size = 36});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.raised,
        shape: BoxShape.circle,
        border: Border.all(color: c.hairline),
      ),
      child: Icon(icon, color: c.ink, size: size * 0.5),
    );
  }
}

/// Thin progress track: hairline track, charcoal fill. [value] is 0..1.
class Meter extends StatelessWidget {
  const Meter({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: LinearProgressIndicator(
      value: value.clamp(0.0, 1.0),
      minHeight: 6,
      backgroundColor: context.pearl.hairline,
      color: context.pearl.anchor,
    ),
  );
}

/// 270° arc with the value centred and a muted caption. [value] is 0..1.
class Gauge extends StatelessWidget {
  const Gauge({
    super.key,
    required this.value,
    required this.label,
    this.caption,
    this.size = 120,
  });

  final double value;
  final String label;
  final String? caption;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final text = Theme.of(context).textTheme;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _GaugePainter(value.clamp(0.0, 1.0), c.hairline, c.anchor),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: PearlType.metricCard),
              if (caption != null) Text(caption!, style: text.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter(this.value, this.track, this.fill);

  final double value;
  final Color track;
  final Color fill;

  static const _start = math.pi * 0.75;
  static const _sweep = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 10.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    Paint p(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _start, _sweep, false, p(track));
    if (value > 0) {
      canvas.drawArc(rect, _start, _sweep * value, false, p(fill));
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.track != track || old.fill != fill;
}

/// A row of 2-4 metrics in one module, split by hairline dividers.
class KpiStrip extends StatelessWidget {
  const KpiStrip({super.key, required this.items, this.leading});

  final List<({String label, String value})> items;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final text = Theme.of(context).textTheme;
    return Module(
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                VerticalDivider(width: 24, thickness: 1, color: c.hairline),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(items[i].label, style: text.bodySmall),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(items[i].value, style: PearlType.metricCard),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 56px navigation row: icon chip, label, optional trailing value and chevron.
class NavRow extends StatelessWidget {
  const NavRow({
    super.key,
    required this.label,
    this.icon,
    this.value,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final String? value;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Pearl.radiusMd),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Row(
          children: [
            if (icon != null) ...[
              IconChip(icon: icon!),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label, style: text.bodyMedium),
                    if (subtitle != null)
                      Text(subtitle!, style: text.bodySmall),
                  ],
                ),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: PearlType.metricTable.copyWith(color: c.muted),
              ),
            ?trailing,
            if (onTap != null && trailing == null) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 18, color: c.muted),
            ],
          ],
        ),
      ),
    );
  }
}

/// Stacks rows with 1px dividers inset past the icon chip.
class RowGroup extends StatelessWidget {
  const RowGroup({super.key, required this.children, this.inset = 48});

  final List<Widget> children;
  final double inset;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) Divider(indent: inset, height: 1),
        children[i],
      ],
    ],
  );
}

/// Pill segmented control: the selected segment is a white pill with a soft
/// shadow; the rest are muted text.
class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.expand = false,
  });

  final List<(T, String)> segments;
  final T selected;

  /// Null disables the control.
  final ValueChanged<T>? onChanged;

  /// Stretch segments to fill the width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.pearl;
    final text = Theme.of(context).textTheme;
    Widget segment((T, String) s) {
      final on = s.$1 == selected;
      final child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : () => onChanged!(s.$1),
        child: AnimatedContainer(
          duration: Pearl.motion,
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on ? c.raised : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: on
                ? [
                    BoxShadow(
                      color: c.shadow.withValues(alpha: 0.08),
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: Text(
            s.$2,
            textAlign: TextAlign.center,
            style: text.labelLarge?.copyWith(
              color: onChanged == null ? c.outline : (on ? c.ink : c.muted),
            ),
          ),
        ),
      );
      return expand ? Expanded(child: child) : child;
    }

    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: c.inner,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          children: [for (final s in segments) segment(s)],
        ),
      ),
    );
  }
}

/// Asks to confirm an action. A [destructive] confirm button is red.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = 'Delete',
  bool destructive = true,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: destructive
              ? TextButton.styleFrom(foregroundColor: ctx.pearl.negative)
              : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return ok == true;
}

/// Red swipe-to-delete background for a Dismissible row.
class DeleteSwipeBackground extends StatelessWidget {
  const DeleteSwipeBackground({super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.pearl.negativeContainer,
      borderRadius: BorderRadius.circular(Pearl.radiusMd),
    ),
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 16),
    child: Icon(Icons.delete_outline, color: context.pearl.negative),
  );
}
