import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'investing_repository.dart';
import 'portfolio.dart';

final portfolioProvider = Provider<Portfolio>((ref) {
  final stocks = ref.watch(stocksProvider).value ?? const [];
  final trades = ref.watch(tradesProvider).value ?? const [];
  return buildPortfolio(stocks, trades, DateTime.now());
});
