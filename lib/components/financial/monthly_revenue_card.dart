import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/formatters.dart';

class MonthlyRevenueCard extends StatelessWidget {
  final Map<String, num> monthlyRevenue;

  const MonthlyRevenueCard({super.key, required this.monthlyRevenue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: BatKittyTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: BatKittyTheme.borderSubtle)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rekap Pemasukan Per Bulan', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: monthlyRevenue.entries.map((entry) {
              String monthLabel = entry.key == '2026-08' ? 'Agustus 2026' : entry.key;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: BatKittyTheme.surfaceElevated, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(monthLabel, style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10)),
                      const SizedBox(height: 6),
                      Text(formatRupiah(entry.value.toInt()), style: const TextStyle(color: Colors.greenAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}