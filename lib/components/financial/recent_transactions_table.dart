import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class RecentTransactionsTable extends StatelessWidget {
  final String selectedStatusFilter;
  final List<Map<String, dynamic>> filteredTransactions;
  final ValueChanged<String> onFilterSelected;
  final ValueChanged<Map<String, dynamic>> onRowTap;

  const RecentTransactionsTable({
    super.key,
    required this.selectedStatusFilter,
    required this.filteredTransactions,
    required this.onFilterSelected,
    required this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: BatKittyTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: BatKittyTheme.borderSubtle)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Transactions ($selectedStatusFilter)', style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Klik pada baris pesanan untuk melihat detail lengkap', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 10)),
                  ],
                ),
                _buildFilterButton(context),
              ],
            ),
          ),
          const Divider(height: 1, color: BatKittyTheme.borderSubtle),
          _buildTableHeader(),
          if (filteredTransactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              alignment: Alignment.center,
              child: const Text('Tidak ada transaksi untuk filter ini.', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11)),
            )
          else
            ...filteredTransactions.map((tx) {
              return InkWell(
                onTap: () => onRowTap(tx),
                child: _buildTransactionRow(
                  tx['id']!,
                  tx['customer']!,
                  tx['food']!,
                  tx['delivery']!,
                  tx['status']!,
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onFilterSelected,
      color: BatKittyTheme.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: BatKittyTheme.borderSubtle)),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'All', child: Text('Semua Status (All)', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 11))),
        const PopupMenuItem(value: 'Completed', child: Text('Completed (Selesai)', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 11))),
        const PopupMenuItem(value: 'Proses', child: Text('Proses', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 11))),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: BatKittyTheme.surfaceElevated, borderRadius: BorderRadius.circular(8), border: Border.all(color: BatKittyTheme.borderSubtle)),
        child: Row(
          children: [
            const Icon(Icons.tune_rounded, size: 13, color: BatKittyTheme.textMuted),
            const SizedBox(width: 6),
            Text('Filter ($selectedStatusFilter)', style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('ORDER', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9, fontWeight: FontWeight.w800))),
          Expanded(flex: 3, child: Text('CUSTOMER', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9, fontWeight: FontWeight.w800))),
          Expanded(flex: 2, child: Text('FOOD', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9, fontWeight: FontWeight.w800))),
          Expanded(flex: 2, child: Text('DELIVERY', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9, fontWeight: FontWeight.w800))),
          Expanded(flex: 2, child: Text('STATUS', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(String id, String customer, String food, String delivery, String status) {
    final bool isCompleted = status == 'Completed';
    final statusColor = isCompleted ? Colors.greenAccent : Colors.orangeAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: BatKittyTheme.borderSubtle))),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(id, style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
          Expanded(flex: 3, child: Text(customer, style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11))),
          Expanded(flex: 2, child: Text(food, style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11, fontWeight: FontWeight.w700))),
          Expanded(flex: 2, child: Text(delivery, style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11))),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(color: statusColor.withOpacity(.10), borderRadius: BorderRadius.circular(7)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w800)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}