import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/local/app_seed.dart';

class DashboardKpi extends StatelessWidget {
  const DashboardKpi({super.key});

  @override
  Widget build(BuildContext context) {
    final rawCustomers = (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    num totalRevenue = 0;
    int totalOrdersCount = 0;
    int completedDeliveries = 0;
    int pendingTasksCount = 0;

    for (var cust in rawCustomers) {
      final orders = (cust['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      totalOrdersCount += orders.length;
      for (var o in orders) {
        totalRevenue += (o['total_price'] as num?) ?? 0;
        if (o['delivery_type'] == 'Delivery' && o['status_masak'] == 'Selesai') {
          completedDeliveries++;
        }
        if (o['status_masak'] == 'Proses') {
          pendingTasksCount++;
        }
      }
    }

    return Row(
      children: [
        Expanded(
          child: _metricCard(
            title: 'Total Revenue',
            value: formatRupiah(totalRevenue.toInt()),
            subtitle: 'Akumulasi omzet data',
            icon: Icons.payments_rounded,
            accent: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _metricCard(
            title: 'Orders',
            value: totalOrdersCount.toString(),
            subtitle: 'Total transaksi',
            icon: Icons.receipt_long_rounded,
            accent: BatKittyTheme.hotPink,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _metricCard(
            title: 'Deliveries Done',
            value: completedDeliveries.toString(),
            subtitle: 'Pengiriman selesai',
            icon: Icons.local_shipping_rounded,
            accent: Colors.orangeAccent,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _metricCard(
            title: 'Pending Tasks',
            value: pendingTasksCount.toString(),
            subtitle: 'Butuh penanganan',
            icon: Icons.pending_actions_rounded,
            accent: Colors.amberAccent,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({required String title, required String value, required String subtitle, required IconData icon, required Color accent}) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(color: BatKittyTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: BatKittyTheme.borderSubtle)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title.toUpperCase(), style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .8)),
              Icon(icon, color: accent, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Text(value, style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 7),
          Text(subtitle, style: TextStyle(color: accent, fontSize: 9.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}