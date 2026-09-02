import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/local/app_seed.dart';

class RecentOrders extends StatelessWidget {
  const RecentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = (appSeed['recent_orders'] as List).cast<Map<String, dynamic>>();

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
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: BatKittyTheme.hotPink, size: 17),
              const SizedBox(width: 9),
              const Text(
                'Recent Orders',
                style: TextStyle(color: BatKittyTheme.textMain, fontSize: 13, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                'View all',
                style: TextStyle(color: BatKittyTheme.pinkGlow, fontSize: 9.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: orders.map((order) {
              return _orderRow(
                id: order['id'] as String,
                customer: order['customer'] as String,
                type: order['type'] as String,
                amount: order['amount'] as int,
                status: order['status'] as String,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _orderRow({
    required String id,
    required String customer,
    required String type,
    required int amount,
    required String status,
  }) {
    final statusColor = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BatKittyTheme.borderSubtle)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              type == 'Pickup' ? Icons.storefront_rounded : Icons.local_shipping_outlined,
              color: BatKittyTheme.textMuted,
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('$customer · $type', style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 9.5)),
              ],
            ),
          ),
          Text(formatRupiah(amount), style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(width: 18),
          _statusBadge(status, statusColor),
        ],
      ),
    );
  }

  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withOpacity(.18)),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 8.5, fontWeight: FontWeight.w700)),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed': return Colors.greenAccent;
      case 'Delivering': return BatKittyTheme.hotPink;
      case 'Preparing': return Colors.orangeAccent;
      default: return Colors.amberAccent;
    }
  }
}