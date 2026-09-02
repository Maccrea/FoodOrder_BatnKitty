import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class DeliveryOverview extends StatelessWidget {
  const DeliveryOverview({super.key});

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
              Icon(Icons.local_shipping_rounded, color: BatKittyTheme.hotPink, size: 17),
              SizedBox(width: 9),
              Text(
                'Delivery Overview',
                style: TextStyle(color: BatKittyTheme.textMain, fontSize: 13, fontWeight: FontWeight.w800),
              ),
              Spacer(),
              Text(
                'Manage',
                style: TextStyle(color: BatKittyTheme.pinkGlow, fontSize: 9.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _operationProgress(label: 'Pending', value: 2, total: 8, color: Colors.amberAccent),
          const SizedBox(height: 18),
          _operationProgress(label: 'Delivering', value: 3, total: 8, color: BatKittyTheme.hotPink),
          const SizedBox(height: 18),
          _operationProgress(label: 'Delivered', value: 3, total: 8, color: Colors.greenAccent),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.schedule_rounded, color: BatKittyTheme.textMuted, size: 16),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Next route update at 07:00 WIB',
                    style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _operationProgress({required String label, required int value, required int total, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 10.5, fontWeight: FontWeight.w600)),
            Text('$value / $total', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value / total,
            minHeight: 6,
            backgroundColor: BatKittyTheme.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}