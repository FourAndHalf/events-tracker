import 'package:flutter/material.dart';

import '../theme/aura_colors.dart';

/// Level-1 surface: slate card with a 1px rim and rounded-lg corners.
class AuraCard extends StatelessWidget {
  const AuraCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor = Aura.rim,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(Aura.cardRadius);
    return Material(
      color: Aura.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
    );
  }
}

/// Full-pill button. Filled with an accent, or a ghost variant.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = Aura.sleep,
    this.ghost = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final bool ghost;

  @override
  Widget build(BuildContext context) {
    final fg = ghost ? Aura.text : Aura.canvas;
    return Material(
      color: ghost ? Aura.surface : color,
      shape: StadiumBorder(side: ghost ? const BorderSide(color: Aura.rim) : BorderSide.none),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 20, color: fg), const SizedBox(width: 8)],
              Text(label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small status pill: accent at 12% background, dot, accent text.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: const StadiumBorder(),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
      ]),
    );
  }
}

/// 8px track with a rounded fill. [value] is clamped to 0..1.
class AuraProgressBar extends StatelessWidget {
  const AuraProgressBar({super.key, required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 8,
        backgroundColor: Aura.raised,
        color: color,
      ),
    );
  }
}

/// Small uppercase overline label.
class Overline extends StatelessWidget {
  const Overline(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      );
}

/// Round icon badge tinted with an accent.
class IconBadge extends StatelessWidget {
  const IconBadge({super.key, required this.icon, required this.color, this.size = 40});

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.18), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: size * 0.5),
      );
}
