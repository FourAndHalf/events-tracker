import 'package:flutter/material.dart';

import '../theme/aura_colors.dart';

/// Shows the app icon centred on the canvas, then fades and scales it away to
/// reveal [child] (the home page). Matches the native splash, so there is no jump.
class SplashOverlay extends StatefulWidget {
  const SplashOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<SplashOverlay> createState() => _SplashOverlayState();
}

class _SplashOverlayState extends State<SplashOverlay>
    with SingleTickerProviderStateMixin {
  static const _hold = Duration(milliseconds: 900);
  static const _exit = Duration(milliseconds: 600);

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: _hold + _exit,
  );
  late final Animation<double> _pulse = CurvedAnimation(
    parent: _c,
    curve: Interval(
      0,
      _hold.inMilliseconds / _c.duration!.inMilliseconds,
      curve: Curves.easeInOut,
    ),
  );
  late final Animation<double> _out = CurvedAnimation(
    parent: _c,
    curve: Interval(
      _hold.inMilliseconds / _c.duration!.inMilliseconds,
      1,
      curve: Curves.easeInOutCubic,
    ),
  );

  @override
  void initState() {
    super.initState();
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            if (_c.isCompleted) return const SizedBox.shrink();
            final t = _out.value;
            final scale = (1 + 0.06 * _pulse.value) * (1 + 0.5 * t);
            return IgnorePointer(
              ignoring: t > 0.5,
              child: Opacity(
                opacity: 1 - t,
                child: ColoredBox(
                  color: Aura.canvas,
                  child: Center(
                    child: Transform.scale(
                      scale: scale,
                      child: Image.asset(
                        'assets/icon/splash_logo.png',
                        width: 160,
                        height: 160,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
