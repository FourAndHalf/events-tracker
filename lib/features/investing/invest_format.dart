import 'package:flutter/material.dart';

import '../../core/money/money_format.dart';
import '../../core/theme/aura_colors.dart';

/// "+$12.50" / "-$3.00" / "$0.00".
String formatSigned(int cents, String symbol) =>
    cents > 0 ? '+${formatMoney(cents, symbol)}' : formatMoney(cents, symbol);

String formatPercent(double? p) =>
    p == null ? '–' : '${p >= 0 ? '+' : ''}${p.toStringAsFixed(1)}%';

Color plColor(int? cents) => cents == null || cents == 0
    ? Aura.textSecondary
    : (cents > 0 ? Aura.gain : Aura.loss);

String formatDays(int days) => days == 1 ? '1 day' : '$days days';

String holdText(int min, int max) =>
    min == max ? formatDays(min) : '$min–$max days';
