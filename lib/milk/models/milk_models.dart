import 'package:flutter/foundation.dart';

@immutable
class MonthMetrics {
  final double totalLitres;
  final double unitPrice;
  final double totalAmount;
  final double carriedBalance;
  final double netPayable;
  final int loggedDays;
  final int skippedDays;

  const MonthMetrics({
    required this.totalLitres,
    required this.unitPrice,
    required this.totalAmount,
    required this.carriedBalance,
    required this.netPayable,
    required this.loggedDays,
    required this.skippedDays,
  });

  factory MonthMetrics.zero(double unitPrice, double carriedBalance) {
    return MonthMetrics(
      totalLitres: 0.0,
      unitPrice: unitPrice,
      totalAmount: 0.0,
      carriedBalance: carriedBalance,
      netPayable: carriedBalance,
      loggedDays: 0,
      skippedDays: 0,
    );
  }
}

@immutable
class MonthlyTrendPoint {
  final String label; // e.g., 'Oct', 'Nov'
  final String yearMonth;
  final double totalLitres;
  final double totalAmount;

  const MonthlyTrendPoint({
    required this.label,
    required this.yearMonth,
    required this.totalLitres,
    required this.totalAmount,
  });
}
