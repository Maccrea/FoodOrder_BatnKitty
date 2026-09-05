import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';

class RecentTransactionsTable extends StatelessWidget {
  final String selectedStatusFilter;
  final List<Map<String, dynamic>> filteredTransactions;
  final Function(String) onFilterSelected;
  final Function(Map<String, dynamic>) onRowTap;

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
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Transactions (Ledger)',
                      style: TextStyle(color: BatKittyTheme.textMain, fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Klik pada baris pesanan untuk melihat detail lengkap & kirim WA',
                      style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: BatKittyTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: BatKittyTheme.borderSubtle),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedStatusFilter,
                      dropdownColor: BatKittyTheme.surfaceDark,
                      style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11.5, fontWeight: FontWeight.bold),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: BatKittyTheme.textSubtle, size: 18),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('Filter: Semua Status')),
                        DropdownMenuItem(value: 'Completed', child: Text('Status: Completed')),
                        DropdownMenuItem(value: 'Proses', child: Text('Status: Proses')),
                      ],
                      onChanged: (val) {
                        if (val != null) onFilterSelected(val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: BatKittyTheme.borderSubtle),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('ORDER', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                Expanded(flex: 3, child: Text('CUSTOMER', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                Expanded(flex: 3, child: Text('DETAIL MENU', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                Expanded(flex: 2, child: Text('FOOD PRICE', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                Expanded(flex: 2, child: Text('DELIVERY', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
                Expanded(flex: 2, child: Text('STATUS', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: .5))),
              ],
            ),
          ),
          const Divider(height: 1, color: BatKittyTheme.borderSubtle),

          if (filteredTransactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(50),
              alignment: Alignment.center,
              child: const Text('Tidak ada transaksi yang sesuai dengan filter.', style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 12)),
            )
          else
            ...List.generate(filteredTransactions.length, (index) {
              final tx = filteredTransactions[index];
              final bool isCompleted = tx['status'] == 'Completed';

              return InkWell(
                onTap: () => onRowTap(tx),
                hoverColor: BatKittyTheme.surfaceElevated.withOpacity(0.5),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: BatKittyTheme.borderSubtle)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          tx['id'],
                          style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11.5, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          tx['customer'],
                          style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          tx['menu_name'],
                          style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          tx['food'],
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 11.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          tx['delivery'],
                          style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (isCompleted ? Colors.greenAccent : Colors.orangeAccent).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tx['status'],
                              style: TextStyle(
                                color: isCompleted ? Colors.greenAccent : Colors.orangeAccent,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}