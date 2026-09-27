import 'dart:async';

import 'package:flutter/material.dart';

/// Live elapsed time of a running timer ("0h 12m 05″"), refreshed every second.
class ElapsedText extends StatefulWidget {
  const ElapsedText({super.key, required this.start, this.style});

  final DateTime start;
  final TextStyle? style;

  @override
  State<ElapsedText> createState() => _ElapsedTextState();
}

class _ElapsedTextState extends State<ElapsedText> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var d = DateTime.now().difference(widget.start);
    if (d.isNegative) d = Duration.zero;
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return Text('${d.inHours}h $m′ $s″', style: widget.style);
  }
}
