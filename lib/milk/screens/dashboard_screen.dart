import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/milk_providers.dart';
import '../widgets/quick_log_card.dart';
import '../widgets/monthly_trend_chart.dart';
import 'calendar_billing_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final ym = DateFormat('yyyy-MM').format(now);
    final metrics = ref.watch(monthMetricsProvider(ym));
    final currency = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Milk Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            tooltip: 'Open Calendar & Billing',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalendarBillingScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          QuickLogCard(
            onOpenCustom: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CalendarBillingScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 18),

          // Overview KPI Grid
          Row(
            children: [
              Expanded(
                child: _KpiMetricCard(
                  title: 'This Month Milk',
                  value: '${metrics.totalLitres.toStringAsFixed(1)} L',
                  sub: '${metrics.loggedDays} deliveries logged',
                  icon: Icons.local_drink_rounded,
                  iconColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiMetricCard(
                  title: 'Estimated Total',
                  value: currency.format(metrics.totalAmount),
                  sub: 'Rate: ₹${metrics.unitPrice.toStringAsFixed(0)}/L',
                  icon: Icons.receipt_long_rounded,
                  iconColor: AppColors.accentSuccess,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _KpiMetricCard(
                  title: 'Carried Balance',
                  value: metrics.carriedBalance >= 0
                      ? '+₹${metrics.carriedBalance.toStringAsFixed(0)}'
                      : '-₹${metrics.carriedBalance.abs().toStringAsFixed(0)}',
                  sub: metrics.carriedBalance >= 0
                      ? 'Pending dues'
                      : 'Advance balance',
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: metrics.carriedBalance >= 0
                      ? AppColors.accentError
                      : AppColors.accentSuccess,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiMetricCard(
                  title: 'Net Payable',
                  value: currency.format(metrics.netPayable),
                  sub: 'Till end of month',
                  icon: Icons.payment_rounded,
                  iconColor: AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 6-Month Concise Trend Chart
          const MonthlyTrendChart(),
        ],
      ),
    );
  }
}

class _KpiMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  final IconData icon;
  final Color iconColor;

  const _KpiMetricCard({
    required this.title,
    required this.value,
    required this.sub,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(icon, size: 18, color: iconColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
