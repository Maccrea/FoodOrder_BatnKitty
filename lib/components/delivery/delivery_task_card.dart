import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class DeliveryTaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onAction;

  const DeliveryTaskCard({
    super.key,
    required this.task,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final status = task['status'];
    final Color statusColor = status == 'Delivered'
        ? Colors.greenAccent
        : status == 'Delivering'
            ? BatKittyTheme.hotPink
            : Colors.amberAccent;

    final IconData statusIcon = status == 'Delivered'
        ? Icons.check_circle_rounded
        : status == 'Delivering'
            ? Icons.local_shipping_rounded
            : Icons.schedule_rounded;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Text('ORDER', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 8, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  task['id'].replaceAll('#ORD-', ''),
                  style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['customer'], style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 12, color: BatKittyTheme.textSubtle),
                    const SizedBox(width: 5),
                    Text(task['phone'], style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: BatKittyTheme.pinkGlow),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task['address'],
                    style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 65,
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: BatKittyTheme.textSubtle),
                const SizedBox(width: 5),
                Text(task['time'], style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(.25)),
            ),
            child: Row(
              children: [
                Icon(statusIcon, size: 12, color: statusColor),
                const SizedBox(width: 5),
                Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 110,
            child: status == 'Delivered'
                ? const Text('Completed', textAlign: TextAlign.center, style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10, fontWeight: FontWeight.w600))
                : ElevatedButton(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BatKittyTheme.hotPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                    ),
                    child: Text(
                      status == 'Pending' ? 'Start Delivery' : 'Mark Delivered',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}