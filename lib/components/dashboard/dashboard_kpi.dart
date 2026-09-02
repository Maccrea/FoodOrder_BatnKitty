import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/formatters.dart';

class DashboardKpi extends StatelessWidget {
  const DashboardKpi({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _metricCard(
            title: 'Today Revenue',
            value: formatRupiah(4850000),
            subtitle: '+12.8% from yesterday',
            icon: Icons.payments_rounded,
            accent: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _metricCard(
            title: 'Orders',
            value: '24',
            subtitle: '18 completed today',
            icon: Icons.receipt_long_rounded,
            accent: BatKittyTheme.hotPink,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _metricCard(
            title: 'Deliveries',
            value: '08',
            subtitle: '3 currently on route',
            icon: Icons.local_shipping_rounded,
            accent: Colors.orangeAccent,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _metricCard(
            title: 'Pending Tasks',
            value: '06',
            subtitle: 'Requires attention',
            icon: Icons.pending_actions_rounded,
            accent: Colors.amberAccent,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: BatKittyTheme.textSubtle,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              Icon(icon, color: accent, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: BatKittyTheme.textMain,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            style: TextStyle(
              color: accent,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}