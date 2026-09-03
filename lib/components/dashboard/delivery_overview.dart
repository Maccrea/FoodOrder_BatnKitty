import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../../data/local/app_seed.dart';

class DeliveryOverview extends StatelessWidget {
  const DeliveryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final rawCustomers = (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    
    List<Map<String, dynamic>> deliveryOrders = [];
    for (var cust in rawCustomers) {
      final custOrders = (cust['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (var ord in custOrders) {
        if (ord['delivery_type'] == 'Delivery') {
          deliveryOrders.add(ord);
        }
      }
    }

    int totalDelivery = deliveryOrders.isEmpty ? 1 : deliveryOrders.length;
    int pendingCount = deliveryOrders.where((o) => o['status_masak'] == 'Proses').length;
    int deliveringCount = 0; 
    int deliveredCount = deliveryOrders.where((o) => o['status_masak'] == 'Selesai').length;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.local_shipping_rounded, color: BatKittyTheme.hotPink, size: 17),
                  SizedBox(width: 9),
                  Text(
                    'Delivery Overview',
                    style: TextStyle(color: BatKittyTheme.textMain, fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Text(
                'Manage',
                style: TextStyle(color: BatKittyTheme.pinkGlow, fontSize: 9.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressRow('Pending', pendingCount, totalDelivery, Colors.amberAccent),
          const SizedBox(height: 14),
          _buildProgressRow('Delivering', deliveringCount, totalDelivery, BatKittyTheme.hotPink),
          const SizedBox(height: 14),
          _buildProgressRow('Delivered', deliveredCount, totalDelivery, Colors.greenAccent),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.access_time_rounded, size: 14, color: BatKittyTheme.textSubtle),
                SizedBox(width: 8),
                Text(
                  'Next route update at 07:00 WIB',
                  style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, int count, int total, Color color) {
    double progress = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
            Text('$count / $total', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: BatKittyTheme.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}