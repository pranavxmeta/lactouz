import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/database/database.dart';
// import '../models/milk_models.dart';
import '../providers/milk_providers.dart';

class CalendarBillingScreen extends ConsumerWidget {
  const CalendarBillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final ym = DateFormat('yyyy-MM').format(selectedMonth);
    final metrics = ref.watch(monthMetricsProvider(ym));
    final logsAsync = ref.watch(monthlyLogsProvider(ym));
    final currency = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar & Billing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Rate & Balance Settings',
            onPressed: () => _showSettingsSheet(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Month Selector Header
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      ref.read(selectedMonthProvider.notifier).state = DateTime(
                        selectedMonth.year,
                        selectedMonth.month - 1,
                      );
                    },
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(selectedMonth),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      ref.read(selectedMonthProvider.notifier).state = DateTime(
                        selectedMonth.year,
                        selectedMonth.month + 1,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Calendar Grid Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: logsAsync.when(
                data: (logs) => _CalendarView(
                  month: selectedMonth,
                  logs: {for (var log in logs) log.date: log},
                ),
                loading: () => const SizedBox(
                  height: 250,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Billing Breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Billing Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _BillRow(
                    label: 'Monthly Consumption',
                    value: '${metrics.totalLitres.toStringAsFixed(1)} Litres',
                    sub:
                        '${metrics.loggedDays} logged • ${metrics.skippedDays} skipped',
                  ),
                  const Divider(height: 22),
                  _BillRow(
                    label: 'Milk Rate',
                    value: '₹${metrics.unitPrice.toStringAsFixed(0)} / Litre',
                  ),
                  const Divider(height: 22),
                  _BillRow(
                    label: 'Current Month Total',
                    value: currency.format(metrics.totalAmount),
                    sub:
                        '${metrics.totalLitres.toStringAsFixed(1)} L × ₹${metrics.unitPrice.toStringAsFixed(0)}',
                  ),
                  const Divider(height: 22),
                  _BillRow(
                    label: 'Previous Balance (Debit/Credit)',
                    value: metrics.carriedBalance >= 0
                        ? '+₹${metrics.carriedBalance.toStringAsFixed(0)}'
                        : '-₹${metrics.carriedBalance.abs().toStringAsFixed(0)}',
                    sub: metrics.carriedBalance >= 0
                        ? 'Pending dues from last month'
                        : 'Advance carried forward',
                    valueColor: metrics.carriedBalance >= 0
                        ? AppColors.accentError
                        : AppColors.accentSuccess,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Net Payable:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          currency.format(metrics.netPayable),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final currentPrice = ref.read(unitPriceProvider).value ?? 65.0;
    final currentBalance = ref.read(carriedBalanceProvider).value ?? 0.0;

    final priceCtrl = TextEditingController(
      text: currentPrice.toStringAsFixed(0),
    );
    final balanceCtrl = TextEditingController(
      text: currentBalance.toStringAsFixed(0),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configure Pricing & Balance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Unit Price (₹ per Litre)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: balanceCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Carried Balance (Debit: +, Credit: -)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () async {
                  final newPrice =
                      double.tryParse(priceCtrl.text) ?? currentPrice;
                  final newBal =
                      double.tryParse(balanceCtrl.text) ?? currentBalance;
                  await db.setConfig('unit_price', newPrice.toString());
                  await db.setConfig('carried_balance', newBal.toString());
                  ref.invalidate(unitPriceProvider);
                  ref.invalidate(carriedBalanceProvider);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarView extends ConsumerWidget {
  final DateTime month;
  final Map<String, MilkLog> logs;

  const _CalendarView({required this.month, required this.logs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstWeekday = DateTime(month.year, month.month, 1).weekday % 7;
    const weekHeaders = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekHeaders
              .map(
                (d) => Text(
                  d,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: daysInMonth + firstWeekday,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.85,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox.shrink();
            final day = index - firstWeekday + 1;
            final dateKey =
                '${month.year}-${month.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
            final entry = logs[dateKey];
            final isToday = dateKey == today;

            return InkWell(
              onTap: () => _openDayEditor(context, ref, dateKey, entry),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: isToday
                      ? AppColors.primaryContainer.withValues(alpha: 0.4)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: isToday
                      ? Border.all(color: AppColors.primaryLight, width: 1.2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                        color: isToday
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (entry?.isSkipped == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentWarning.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '0L',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentWarning,
                          ),
                        ),
                      )
                    else if (entry != null && entry.quantity > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${entry.quantity}L',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    else
                      const Text(
                        '-',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _openDayEditor(
    BuildContext context,
    WidgetRef ref,
    String dateStr,
    MilkLog? log,
  ) {
    double qty = log?.quantity ?? 1.5;
    bool skipped = log?.isSkipped ?? false;
    final db = ref.read(databaseProvider);
    final unitPrice = ref.read(unitPriceProvider).value ?? 65.0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Edit: $dateStr'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('No milk delivered (Skip)'),
                value: skipped,
                onChanged: (val) => setDialogState(() => skipped = val),
              ),
              if (!skipped) ...[
                const SizedBox(height: 10),
                Text(
                  '${qty.toStringAsFixed(1)} Litres',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: qty,
                  min: 0.5,
                  max: 5.0,
                  divisions: 9,
                  label: '$qty L',
                  onChanged: (val) => setDialogState(() => qty = val),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                await db.setMilkEntry(
                  dateStr: dateStr,
                  qty: qty,
                  price: unitPrice,
                  isSkipped: skipped,
                );
                ref.invalidate(trendHistoryProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final Color? valueColor;

  const _BillRow({
    required this.label,
    required this.value,
    this.sub,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            if (sub != null)
              Text(
                sub!,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
