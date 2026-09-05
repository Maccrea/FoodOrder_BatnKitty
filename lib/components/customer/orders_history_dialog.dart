import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import 'customer_order_card.dart';

class OrdersHistoryDialog extends StatefulWidget {
  final List<Map<String, dynamic>> orders;
  final ValueChanged<Map<String, dynamic>> onCancelOrder;

  const OrdersHistoryDialog({
    super.key,
    required this.orders,
    required this.onCancelOrder,
  });

  static Future<void> show(
    BuildContext context, {
    required List<Map<String, dynamic>> orders,
    required ValueChanged<Map<String, dynamic>> onCancelOrder,
  }) {
    return showDialog(
      context: context,
      builder: (_) => OrdersHistoryDialog(
        orders: orders,
        onCancelOrder: onCancelOrder,
      ),
    );
  }

  @override
  State<OrdersHistoryDialog> createState() => _OrdersHistoryDialogState();
}

class _OrdersHistoryDialogState extends State<OrdersHistoryDialog> {
  String selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final filteredOrders = widget.orders.where((o) {
      if (selectedFilter == 'all') return true;
      return o['status_pesanan'] == selectedFilter;
    }).toList();

    return Dialog(
      backgroundColor: BatKittyTheme.bgDark,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: BatKittyTheme.borderSubtle),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 620),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat & Status Pesanan',
                      style: TextStyle(
                        color: BatKittyTheme.textMain,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Total ${widget.orders.length} pesanan tercatat',
                      style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: BatKittyTheme.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip('Semua (${widget.orders.length})', 'all'),
                  const SizedBox(width: 8),
                  _filterChip('Menunggu Konfirmasi', 'waiting_approve'),
                  const SizedBox(width: 8),
                  _filterChip('Dikonfirmasi', 'approved'),
                  const SizedBox(width: 8),
                  _filterChip('Diproses', 'processing'),
                  const SizedBox(width: 8),
                  _filterChip('Selesai', 'completed'),
                  const SizedBox(width: 8),
                  _filterChip('Dibatalkan', 'cancelled'),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: BatKittyTheme.borderSubtle, height: 1),
            const SizedBox(height: 16),

            Expanded(
              child: filteredOrders.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada pesanan di kategori ini.',
                        style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 12),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (_, i) => CustomerOrderCard(
                        order: filteredOrders[i],
                        onCancel: () {
                          Navigator.pop(context);
                          widget.onCancelOrder(filteredOrders[i]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final bool active = selectedFilter == value;
    return InkWell(
      onTap: () => setState(() => selectedFilter = value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? BatKittyTheme.hotPink : BatKittyTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? BatKittyTheme.hotPink : BatKittyTheme.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : BatKittyTheme.textMuted,
            fontSize: 11,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}