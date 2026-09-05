import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/milk_providers.dart';

class QuickLogCard extends ConsumerWidget {
  final VoidCallback onOpenCustom;

  const QuickLogCard({super.key, required this.onOpenCustom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final db = ref.watch(databaseProvider);
    final logStream = db.watchLogForDate(todayStr);
    final unitPrice = ref.watch(unitPriceProvider).value ?? 65.0;

    return StreamBuilder(
      stream: logStream,
      builder: (context, snapshot) {
        final currentEntry = snapshot.data;
        final currentQty = currentEntry?.isSkipped == true
            ? 0.0
            : currentEntry?.quantity;
        final isSkipped = currentEntry?.isSkipped ?? false;

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          color: Colors.lightBlueAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "TODAY'S LOG",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  _StatusChip(qty: currentQty, isSkipped: isSkipped),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _PresetButton(
                    label: '1.0 L',
                    isSelected: currentQty == 1.0 && !isSkipped,
                    onTap: () => db.setMilkEntry(
                      dateStr: todayStr,
                      qty: 1.0,
                      price: unitPrice,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _PresetButton(
                    label: '1.5 L',
                    isSelected: currentQty == 1.5 && !isSkipped,
                    onTap: () => db.setMilkEntry(
                      dateStr: todayStr,
                      qty: 1.5,
                      price: unitPrice,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _PresetButton(
                    label: '2.0 L',
                    isSelected: currentQty == 2.0 && !isSkipped,
                    onTap: () => db.setMilkEntry(
                      dateStr: todayStr,
                      qty: 2.0,
                      price: unitPrice,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ActionIconButton(
                    icon: Icons.edit_calendar_rounded,
                    onTap: onOpenCustom,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final double? qty;
  final bool isSkipped;

  const _StatusChip({required this.qty, required this.isSkipped});

  @override
  Widget build(BuildContext context) {
    if (isSkipped) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.accentWarning.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Skipped',
          style: TextStyle(
            color: AppColors.accentWarning,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      );
    }
    if (qty != null && qty! > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.accentSuccess.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${qty}L Done',
          style: const TextStyle(
            color: AppColors.accentSuccess,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Not Logged',
        style: TextStyle(color: Colors.white70, fontSize: 11),
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white24,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white24),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
