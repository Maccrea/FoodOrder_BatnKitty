import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/local/app_seed.dart';
import '/components/financial/financial_metrics_grid.dart';
import '/components/financial/monthly_revenue_card.dart';
import '/components/financial/recent_transactions_table.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  String selectedStatusFilter = 'All';
  late List<Map<String, dynamic>> _expensesList;

  @override
  void initState() {
    super.initState();
    _expensesList = List<Map<String, dynamic>>.from(appSeed['expenses'] ?? []);
  }

  void _showAddExpenseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: BatKittyTheme.surfaceDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: BatKittyTheme.borderSubtle)),
          title: const Text('Tambah Pengeluaran Operasional', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12),
                decoration: const InputDecoration(labelText: 'Keterangan Pengeluaran', labelStyle: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12),
                decoration: const InputDecoration(labelText: 'Nominal (Rp)', labelStyle: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: BatKittyTheme.textSubtle)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: BatKittyTheme.hotPink),
              onPressed: () {
                if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  setState(() {
                    _expensesList.add({
                      'title': titleController.text,
                      'amount': num.tryParse(amountController.text) ?? 0,
                      'date': 'Hari Ini',
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showExpenseDetailModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: BatKittyTheme.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rincian Detail Pengeluaran', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _expensesList.length,
                  itemBuilder: (context, index) {
                    final exp = _expensesList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: BatKittyTheme.surfaceElevated, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exp['title'], style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12, fontWeight: FontWeight.bold)),
                              Text(exp['date'], style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9)),
                            ],
                          ),
                          Text(formatRupiah((exp['amount'] as num).toInt()), style: const TextStyle(color: BatKittyTheme.hotPink, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOrderDetailModal(BuildContext context, Map<String, dynamic> detail) {
    showModalBottomSheet(
      context: context,
      backgroundColor: BatKittyTheme.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(28),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Detail Transaksi ${detail['id']}', style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 16, fontWeight: FontWeight.w900)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (detail['status'] == 'Completed' ? Colors.greenAccent : Colors.orangeAccent).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(detail['status'], style: TextStyle(color: detail['status'] == 'Completed' ? Colors.greenAccent : Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow('Nama Pemesan (Customer)', detail['customer']),
              _buildDetailRow('Tanggal Order', detail['tanggal_order']),
              _buildDetailRow('Tanggal Pengambilan', detail['tanggal_pengambilan']),
              _buildDetailRow('Tipe Layanan', detail['delivery_type']),
              _buildDetailRow('Detail Menu Pesanan', '${detail['menu_name']} (${detail['quantity']} porsi)'),
              _buildDetailRow('Catatan Khusus / Keterangan', detail['custom_notes']),
              _buildDetailRow('Diskon / Voucher', detail['discount_info']),
              _buildDetailRow('Ongkos Kirim (Ongkir)', detail['delivery_fee_raw'] > 0 ? formatRupiah(detail['delivery_fee_raw']) : 'Rp 0 (Pickup)'),
              _buildDetailRow('Total Pembayaran', formatRupiah(detail['total_price_raw'])),
              const Divider(color: BatKittyTheme.borderSubtle, height: 24),
              const Text('Ulasan / Review Pelanggan', style: TextStyle(color: BatKittyTheme.pinkGlow, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: BatKittyTheme.surfaceElevated, borderRadius: BorderRadius.circular(10)),
                child: Text(detail['review_text'] ?? 'Belum ada ulasan.', style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11)),
          Text(value, style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawCustomers = (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final rawVouchers = (appSeed['vouchers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final rawMenus = (appSeed['menus'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    List<Map<String, dynamic>> rawOrders = [];
    for (var cust in rawCustomers) {
      final custOrders = (cust['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (var ord in custOrders) {
        rawOrders.add({
          ...ord,
          'customer_name': cust['name'],
        });
      }
    }

    num totalFoodRevenue = 0;
    num totalLogisticsCost = 0;
    num totalPromoSubsidy = 0;
    Map<String, num> monthlyRevenue = {};

    for (var order in rawOrders) {
      num price = (order['total_price'] as num?) ?? 0;
      num delivery = (order['delivery_fee'] as num?) ?? 0;
      totalFoodRevenue += price;
      totalLogisticsCost += delivery;

      String dateStr = order['tanggal_order'] ?? '2026-08-01';
      String monthKey = dateStr.length >= 7 ? dateStr.substring(0, 7) : '2026-08';
      monthlyRevenue[monthKey] = (monthlyRevenue[monthKey] ?? 0) + price;
    }

    for (var voucher in rawVouchers) {
      if (voucher['is_redeemed'] == true) {
        totalPromoSubsidy += (voucher['discount_amount'] as num?) ?? 0;
      }
    }

    num totalExpenses = _expensesList.fold<num>(0, (sum, item) => sum + ((item['amount'] as num?) ?? 0));
    num netProfit = totalFoodRevenue - totalExpenses;

    Map<String, int> menuQtyMap = {};
    for (var order in rawOrders) {
      final items = (order['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (var item in items) {
        String mName = item['menu_name'] ?? 'Unknown';
        int qty = (item['quantity'] as num?)?.toInt() ?? 1;
        menuQtyMap[mName] = (menuQtyMap[mName] ?? 0) + qty;
      }
    }

    String topMenuName = 'Tidak ada data';
    if (menuQtyMap.isNotEmpty) {
      var topEntry = menuQtyMap.entries.reduce((a, b) => a.value > b.value ? a : b);
      topMenuName = "${topEntry.key} (${topEntry.value} porsi)";
    }

    final allTransactions = rawOrders.map((order) {
      final items = (order['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final firstItem = items.isNotEmpty ? items.first : {'menu_name': '-', 'quantity': 1, 'custom_notes': '-'};

      num foodPrice = (order['total_price'] as num?) ?? 0;
      num deliveryFee = (order['delivery_fee'] as num?) ?? 0;
      String statusStr = order['status_masak'] == 'Selesai' ? 'Completed' : 'Proses';

      return {
        'id': '#ORD-09${order['id']}',
        'customer': order['customer_name'],
        'tanggal_order': order['tanggal_order'] ?? '-',
        'tanggal_pengambilan': order['tanggal_pengambilan'] ?? '-',
        'delivery_type': order['delivery_type'] ?? 'Pickup',
        'menu_name': firstItem['menu_name'],
        'quantity': firstItem['quantity'] ?? 1,
        'custom_notes': firstItem['custom_notes'] ?? 'Tidak ada catatan',
        'discount_info': order['id'] == 1 ? 'Pelanggan Pertama' : 'Standar',
        'food': formatRupiah(foodPrice.toInt()),
        'delivery': deliveryFee > 0 ? formatRupiah(deliveryFee.toInt()) : 'Pickup',
        'status': statusStr,
        'delivery_fee_raw': deliveryFee,
        'total_price_raw': foodPrice,
        'review_text': order['review'],
      };
    }).toList();

    final filteredTransactions = allTransactions.where((tx) {
      if (selectedStatusFilter == 'All') return true;
      return tx['status'] == selectedStatusFilter;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Financial Overview & Ledger', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 22, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('Monitor revenue, monthly performance, and operating expenses', style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 12)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: BatKittyTheme.hotPink, foregroundColor: Colors.white),
                onPressed: () => _showAddExpenseDialog(context),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Catat Pengeluaran', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FinancialMetricsGrid(
            totalFoodRevenue: totalFoodRevenue,
            netProfit: netProfit,
            totalExpenses: totalExpenses,
            topMenuName: topMenuName,
            onExpenseTap: () => _showExpenseDetailModal(context),
          ),
          const SizedBox(height: 24),
          MonthlyRevenueCard(monthlyRevenue: monthlyRevenue),
          const SizedBox(height: 24),
          RecentTransactionsTable(
            selectedStatusFilter: selectedStatusFilter,
            filteredTransactions: filteredTransactions,
            onFilterSelected: (val) => setState(() => selectedStatusFilter = val),
            onRowTap: (tx) => _showOrderDetailModal(context, tx),
          ),
        ],
      ),
    );
  }
}