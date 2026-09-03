import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/formatters.dart';

class FinancialMetricsGrid extends StatelessWidget {
  final num totalFoodRevenue;
  final num netProfit;
  final num totalExpenses;
  final String topMenuName;
  final VoidCallback onExpenseTap;

  const FinancialMetricsGrid({
    super.key,
    required this.totalFoodRevenue,
    required this.netProfit,
    required this.totalExpenses,
    required this.topMenuName,
    required this.onExpenseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Food Revenue',
            value: formatRupiah(totalFoodRevenue.toInt()),
            label: 'Top: $topMenuName',
            icon: Icons.restaurant_rounded,
            color: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: GestureDetector(
            onTap: onExpenseTap,
            child: _buildMetricCard(
              title: 'Net Profit (Uang Bersih)',
              value: formatRupiah(netProfit.toInt()),
              label: 'Omzet dikurangi pengeluaran',
              icon: Icons.account_balance_wallet_rounded,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: GestureDetector(
            onTap: onExpenseTap,
            child: _buildMetricCard(
              title: 'Total Expenses',
              value: formatRupiah(totalExpenses.toInt()),
              label: 'Klik rincian biaya',
              icon: Icons.money_off_rounded,
              color: BatKittyTheme.hotPink,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({required String title, required String value, required String label, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: BatKittyTheme.surfaceDark, borderRadius: BorderRadius.circular(14), border: Border.all(color: BatKittyTheme.borderSubtle)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(value, style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}