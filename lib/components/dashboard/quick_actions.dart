import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.flash_on_rounded, color: BatKittyTheme.hotPink, size: 17),
              SizedBox(width: 9),
              Text(
                'Quick Actions',
                style: TextStyle(color: BatKittyTheme.textMain, fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _quickAction(icon: Icons.add_shopping_cart_rounded, label: 'New Order')),
              const SizedBox(width: 10),
              Expanded(child: _quickAction(icon: Icons.local_shipping_rounded, label: 'Delivery')),
              const SizedBox(width: 10),
              Expanded(child: _quickAction(icon: Icons.bar_chart_rounded, label: 'Finance')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Column(
        children: [
          Icon(icon, color: BatKittyTheme.hotPink, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 9.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}