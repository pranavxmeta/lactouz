import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/database.dart';

import '../models/milk_models.dart';

// Single instance of Drift database
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// App Settings: Default unit price & previous balance
final unitPriceProvider = StreamProvider<double>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .watchConfig('unit_price')
      .map((val) => double.tryParse(val ?? '') ?? 65.0);
});

final carriedBalanceProvider = StreamProvider<double>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .watchConfig('carried_balance')
      .map((val) => double.tryParse(val ?? '') ?? 0.0);
});

// Selected calendar month for browsing
final selectedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Logs for selected month
final monthlyLogsProvider = StreamProvider.family<List<MilkLog>, String>((
  ref,
  yearMonth,
) {
  final db = ref.watch(databaseProvider);
  return db.watchMonthLogs(yearMonth);
});

// Calculated Month Metrics
final monthMetricsProvider = Provider.family<MonthMetrics, String>((
  ref,
  yearMonth,
) {
  final logsAsync = ref.watch(monthlyLogsProvider(yearMonth));
  final unitPrice = ref.watch(unitPriceProvider).value ?? 65.0;
  final carriedBalance = ref.watch(carriedBalanceProvider).value ?? 0.0;

  return logsAsync.when(
    data: (logs) {
      double litres = 0;
      int logged = 0;
      int skipped = 0;

      for (final item in logs) {
        if (item.isSkipped) {
          skipped++;
        } else {
          litres += item.quantity;
          if (item.quantity > 0) logged++;
        }
      }

      final totalCost = litres * unitPrice;
      return MonthMetrics(
        totalLitres: litres,
        unitPrice: unitPrice,
        totalAmount: totalCost,
        carriedBalance: carriedBalance,
        netPayable: totalCost + carriedBalance,
        loggedDays: logged,
        skippedDays: skipped,
      );
    },
    loading: () => MonthMetrics.zero(unitPrice, carriedBalance),
    error: (_, _) => MonthMetrics.zero(unitPrice, carriedBalance),
  );
});

// Multi-month summary for Trend Chart (Last 6 Months)
final trendHistoryProvider = FutureProvider<List<MonthlyTrendPoint>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final list = <MonthlyTrendPoint>[];

  for (int i = 5; i >= 0; i--) {
    final targetMonth = DateTime(now.year, now.month - i, 1);
    final ym = DateFormat('yyyy-MM').format(targetMonth);
    final label = DateFormat('MMM').format(targetMonth);

    final logs = await (db.select(
      db.milkLogs,
    )..where((tbl) => tbl.date.like('$ym%'))).get();
    double litres = 0;
    double cost = 0;
    for (final l in logs) {
      if (!l.isSkipped) {
        litres += l.quantity;
        cost += (l.quantity * l.unitPrice);
      }
    }
    list.add(
      MonthlyTrendPoint(
        label: label,
        yearMonth: ym,
        totalLitres: litres,
        totalAmount: cost,
      ),
    );
  }
  return list;
});
