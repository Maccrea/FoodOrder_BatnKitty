import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';
import '../../data/local/app_seed.dart';
import '/components/delivery/delivery_header.dart';
import '/components/delivery/delivery_summary_cards.dart';
import '/components/delivery/delivery_task_card.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  late List<Map<String, dynamic>> allDeliveryTasks;
  String selectedFilter = 'All';
  
  DateTime selectedDate = DateTime(2026, 9, 4);

  @override
  void initState() {
    super.initState();
    _loadDeliveryTasks();
  }

  void _loadDeliveryTasks() {
    final rawCustomers = (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    List<Map<String, dynamic>> deliveryOrders = [];
    for (var cust in rawCustomers) {
      final custOrders = (cust['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (var ord in custOrders) {
        if (ord['delivery_type'] == 'Delivery') {
          deliveryOrders.add({
            ...ord,
            'customer_name': cust['name'],
            'customer_phone': cust['phone'],
          });
        }
      }
    }

    allDeliveryTasks = deliveryOrders.map((order) {
      String statusMasak = order['status_masak'] == 'Selesai' ? 'Delivered' : 'Pending';

      return {
        'id': '#ORD-09${order['id'] ?? '000'}',
        'customer': order['customer_name'],
        'phone': order['customer_phone'],
        'address': order['delivery_address'] ?? 'Jl. Prof. Sudharto No.12, Tembalang',
        'scheduled_date': order['tanggal_pengambilan'] ?? '2026-09-04',
        'time': '10:30',
        'status': statusMasak,
      };
    }).toList();
  }
  
  void _updateStatus(String orderId) {
    setState(() {
      final task = allDeliveryTasks.firstWhere((t) => t['id'] == orderId);
      if (task['status'] == 'Pending') {
        task['status'] = 'Delivering';
      } else if (task['status'] == 'Delivering') {
        task['status'] = 'Delivered';
        // Murni hanya mengubah status di kurir, tidak memicu WA lagi di sini.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String targetDateStr = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    
    final targetTasks = allDeliveryTasks.where((task) => task['scheduled_date'] == targetDateStr).toList();
    final filteredTasks = targetTasks.where((task) {
      if (selectedFilter == 'All') return true;
      return task['status'] == selectedFilter;
    }).toList();

    final pendingCount = targetTasks.where((task) => task['status'] == 'Pending').length;
    final deliveringCount = targetTasks.where((task) => task['status'] == 'Delivering').length;
    final deliveredCount = targetTasks.where((task) => task['status'] == 'Delivered').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DeliveryHeader(
            selectedDate: selectedDate,
            onDateSelected: (newDate) => setState(() => selectedDate = newDate),
          ),
          const SizedBox(height: 24),
          DeliverySummaryCards(
            pendingCount: pendingCount,
            deliveringCount: deliveringCount,
            deliveredCount: deliveredCount,
            selectedFilter: selectedFilter,
            onFilterChanged: (filter) => setState(() => selectedFilter = filter),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Deliveries ($selectedFilter)', style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 15, fontWeight: FontWeight.w800)),
                  if (selectedFilter != 'All') ...[
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => setState(() => selectedFilter = 'All'),
                      child: const Text('(Reset Filter)', style: TextStyle(color: BatKittyTheme.pinkGlow, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
              Text('${filteredTasks.length} orders shown', style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          if (filteredTasks.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: BatKittyTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: BatKittyTheme.borderSubtle)),
              child: const Text("Tidak ada tugas pengantaran pada tanggal ini.", style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 12)),
            )
          else
            ...List.generate(
              filteredTasks.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DeliveryTaskCard(
                  task: filteredTasks[index],
                  onAction: () => _updateStatus(filteredTasks[index]['id']),
                ),
              ),
            ),
        ],
      ),
    );
  }
}