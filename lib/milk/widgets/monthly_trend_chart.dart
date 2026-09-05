import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../models/milk_models.dart';
import '../providers/milk_providers.dart';

class MonthlyTrendChart extends ConsumerWidget {
  const MonthlyTrendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(trendHistoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '6-Month Consumption Trend',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(trendHistoryProvider),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Refresh', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            historyAsync.when(
              data: (points) => SizedBox(
                height: 140,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _BarChartPainter(points),
                ),
              ),
              loading: () => const SizedBox(
                height: 140,
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (err, _) => const SizedBox(
                height: 140,
                child: Center(
                  child: Text(
                    'Unable to load chart data',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<MonthlyTrendPoint> points;

  _BarChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final maxLitres = points.map((e) => e.totalLitres).fold(1.0, max);
    final barWidth = (size.width / points.length) * 0.45;
    final spacing = size.width / points.length;

    final paintBar = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primaryLight, AppColors.primary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final xCenter = (i * spacing) + (spacing / 2);
      final barHeight = maxLitres > 0
          ? (p.totalLitres / maxLitres) * (size.height - 35)
          : 0.0;
      final top = (size.height - 25) - barHeight;

      // Draw rounded bar
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(xCenter - (barWidth / 2), top, barWidth, barHeight + 2),
        const Radius.circular(6),
      );
      canvas.drawRRect(rect, paintBar);

      // Litres label on top of bar
      if (p.totalLitres > 0) {
        textPainter.text = TextSpan(
          text: '${p.totalLitres.toStringAsFixed(0)}L',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(xCenter - (textPainter.width / 2), top - 15),
        );
      }

      // Month Label at bottom
      textPainter.text = TextSpan(
        text: p.label,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(xCenter - (textPainter.width / 2), size.height - 18),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) =>
      oldDelegate.points != points;
}
