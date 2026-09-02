import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';
import '../../data/local/app_seed.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  late final List<Map<String, dynamic>> deliveryTasks;

  @override
  void initState() {
    super.initState();
    deliveryTasks = (appSeed['delivery_tasks'] as List).cast<Map<String, dynamic>>();
  }

  void _updateStatus(int index) {
    setState(() {
      final currentStatus = deliveryTasks[index]['status'];

      if (currentStatus == 'Pending') {
        deliveryTasks[index]['status'] = 'Delivering';
      } else if (currentStatus == 'Delivering') {
        deliveryTasks[index]['status'] = 'Delivered';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pending = deliveryTasks
        .where((task) => task['status'] == 'Pending')
        .length;

    final delivering = deliveryTasks
        .where((task) => task['status'] == 'Delivering')
        .length;

    final delivered = deliveryTasks
        .where((task) => task['status'] == 'Delivered')
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Tasks',
                  style: TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage today\'s delivery operations',
                  style: TextStyle(
                    color: BatKittyTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            _buildDateBadge(),
          ],
        ),

        const SizedBox(height: 24),

        // SUMMARY
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Pending',
                pending.toString(),
                Icons.schedule_rounded,
                Colors.amberAccent,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildSummaryCard(
                'Delivering',
                delivering.toString(),
                Icons.local_shipping_rounded,
                BatKittyTheme.hotPink,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildSummaryCard(
                'Completed',
                delivered.toString(),
                Icons.check_circle_outline_rounded,
                Colors.greenAccent,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // TASK HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s Deliveries',
              style: TextStyle(
                color: BatKittyTheme.textMain,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '${deliveryTasks.length} orders',
              style: const TextStyle(
                color: BatKittyTheme.textSubtle,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // TASK LIST
        ...List.generate(
          deliveryTasks.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildDeliveryTask(
              deliveryTasks[index],
              () => _updateStatus(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 14,
            color: BatKittyTheme.pinkGlow,
          ),
          SizedBox(width: 8),
          Text(
            'Today · 05 Jun 2026',
            style: TextStyle(
              color: BatKittyTheme.textMain,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: BatKittyTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: BatKittyTheme.textMain,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTask(
    Map<String, dynamic> task,
    VoidCallback onAction,
  ) {
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
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          // ORDER ID
          Container(
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Text(
                  'ORDER',
                  style: TextStyle(
                    color: BatKittyTheme.textSubtle,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task['id'].replaceAll('#ORD-', ''),
                  style: const TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 18),

          // CUSTOMER
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['customer'],
                  style: const TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 12,
                      color: BatKittyTheme.textSubtle,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      task['phone'],
                      style: const TextStyle(
                        color: BatKittyTheme.textSubtle,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ADDRESS
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: BatKittyTheme.pinkGlow,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task['address'],
                    style: const TextStyle(
                      color: BatKittyTheme.textMuted,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // TIME
          SizedBox(
            width: 65,
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: BatKittyTheme.textSubtle,
                ),
                const SizedBox(width: 5),
                Text(
                  task['time'],
                  style: const TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // STATUS
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: statusColor.withOpacity(.25),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  statusIcon,
                  size: 12,
                  color: statusColor,
                ),
                const SizedBox(width: 5),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // ACTION
          SizedBox(
            width: 110,
            child: status == 'Delivered'
                ? const Text(
                    'Completed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: BatKittyTheme.textSubtle,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : ElevatedButton(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BatKittyTheme.hotPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      status == 'Pending'
                          ? 'Start Delivery'
                          : 'Mark Delivered',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}