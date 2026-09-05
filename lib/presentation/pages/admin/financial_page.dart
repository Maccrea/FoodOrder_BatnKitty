import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../logic/admin/admin_bloc.dart';
import '../../../../logic/admin/admin_state.dart';
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

  Future<void> _openGoogleMaps(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Gagal membuka maps: $e');
    }
  }

  Future<void> _sendWhatsAppFollowUp(Map<String, dynamic> detail) async {
    String phone = detail['customer_phone'] ?? '';
    phone = phone.replaceAll(RegExp(r'\D'), '');
    if (phone.startsWith('0')) {
      phone = '62${phone.substring(1)}';
    } else if (!phone.startsWith('62') && phone.isNotEmpty) {
      phone = '62$phone';
    }

    final String name = detail['customer'] ?? 'Kak';
    final String menu = detail['menu_name'] ?? 'Menu Bat-Kitty';
    final int qty = detail['quantity'] ?? 1;
    final int total = detail['total_price_raw'] ?? 0;
    final String type = detail['delivery_type'] ?? 'Delivery';

    final String intro = type == 'Pickup'
        ? 'Tengkyu ya udah mampir dan ambil langsung pesanan di BatnKitty hari ini!'
        : 'Tengkyu ya udah jajan di BatnKitty hari ini. Semoga aman sampai tujuan!';

    final message = '''Heyyow $name! 

$intro Semoga masakannya cocok di lidah kamu! 

* Detail Orderan:
- $qty porsi $menu
Total: ${formatRupiah(total)}

Kami bakal seneng banget kalau kamu mau drop honest review di chat ini. Kalau difoto juga boleh banget di-share ke IG Story dan tag @batn.kitty! 

Biar gampang untuk next order, jangan lupa save nomor ini ya. Kalo besok-besok tiba-tiba laper, mager, atau craving lagi, tinggal chat aja okayy

Enjoy your food! 

~batn.kitty ^^''';

    final encodedMessage = Uri.encodeComponent(message);
    final url = Uri.parse('https://wa.me/$phone?text=$encodedMessage');

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Gagal membuka WhatsApp: $e');
    }
  }

  void _showAddExpenseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: BatKittyTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: BatKittyTheme.borderSubtle),
          ),
          title: const Text(
            'Tambah Pengeluaran Operasional',
            style: TextStyle(color: BatKittyTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: 'Keterangan Pengeluaran',
                  labelStyle: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  labelStyle: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: BatKittyTheme.textSubtle)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: BatKittyTheme.hotPink),
              onPressed: () {
                final title = titleController.text.trim();
                final amount = num.tryParse(amountController.text) ?? 0;

                if (title.isNotEmpty && amount > 0) {
                  context.read<AdminBloc>().add(AddExpenseEvent(title: title, amount: amount));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showExpenseDetailModal(BuildContext context, List<Map<String, dynamic>> expensesList) {
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
              const Text(
                'Rincian Detail Pengeluaran',
                style: TextStyle(color: BatKittyTheme.textMain, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (expensesList.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  alignment: Alignment.center,
                  child: const Text(
                    'Belum ada catatan pengeluaran operasional.',
                    style: TextStyle(color: BatKittyTheme.textSubtle, fontSize: 12),
                  ),
                )
              else
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    itemCount: expensesList.length,
                    itemBuilder: (context, index) {
                      final exp = expensesList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: BatKittyTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exp['title'] ?? '-',
                                  style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  exp['date'] ?? 'Hari Ini',
                                  style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9),
                                ),
                              ],
                            ),
                            Text(
                              formatRupiah((exp['amount'] as num?)?.toInt() ?? 0),
                              style: const TextStyle(color: BatKittyTheme.hotPink, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
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
    final bool isDelivery = detail['delivery_type'] == 'Delivery';
    final String deliveryAddress = detail['delivery_address'] ?? 'Semarang';
    final bool isCompleted = detail['status'] == 'Completed';

    showModalBottomSheet(
      context: context,
      backgroundColor: BatKittyTheme.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(32),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Transaksi ${detail['id']}',
                      style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (isCompleted ? Colors.greenAccent : Colors.orangeAccent).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        detail['status'],
                        style: TextStyle(
                          color: isCompleted ? Colors.greenAccent : Colors.orangeAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isCompleted) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _sendWhatsAppFollowUp(detail),
                      icon: const Icon(Icons.chat_rounded, size: 16, color: Colors.white),
                      label: const Text(
                        'Kirim WA Follow-up Pelanggan',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _buildDetailRow('Nama Pemesan (Customer)', detail['customer']),
                _buildDetailRow('Tanggal Order', detail['tanggal_order']),
                _buildDetailRow('Tanggal Pengambilan', detail['tanggal_pengambilan']),
                _buildDetailRow('Tipe Layanan', detail['delivery_type']),
                if (isDelivery) ...[
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _openGoogleMaps(deliveryAddress),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.map_rounded, size: 14, color: BatKittyTheme.pinkGlow),
                              SizedBox(width: 6),
                              Text(
                                'Alamat Pengiriman (Cek Maps)',
                                style: TextStyle(color: BatKittyTheme.pinkGlow, fontSize: 11.5, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            deliveryAddress,
                            style: const TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 11.5,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                _buildDetailRow('Detail Menu Pesanan', '${detail['menu_name']} (${detail['quantity']} porsi)'),
                _buildDetailRow('Catatan Khusus / Keterangan', detail['custom_notes']),
                _buildDetailRow('Diskon / Voucher', detail['discount_info']),
                _buildDetailRow(
                  'Ongkos Kirim (Ongkir)',
                  detail['delivery_fee_raw'] > 0 ? formatRupiah(detail['delivery_fee_raw']) : 'Rp 0 (Pickup)',
                ),
                _buildDetailRow('Total Pembayaran', formatRupiah(detail['total_price_raw'])),
                const Divider(color: BatKittyTheme.borderSubtle, height: 28),
                const Text(
                  'Ulasan / Review Pelanggan',
                  style: TextStyle(color: BatKittyTheme.pinkGlow, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: BatKittyTheme.surfaceElevated, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    detail['review_text'] ?? 'Belum ada ulasan.',
                    style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11.5, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 12)),
          Text(value, style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        final totalFoodRevenue = state.totalRevenue;
        final totalExpenses = state.totalExpensesAmount;
        final netProfit = state.netProfit;

        final Map<String, num> monthlyRevenue = {};
        for (var order in state.allOrders) {
          if (order['status_bayar'] == 'paid' || order['status_pesanan'] == 'completed') {
            final num price = (order['total_price'] as num?) ?? 0;
            final num delivery = (order['delivery_fee'] as num?) ?? 0;
            final String pickupDateStr = order['tanggal_pengambilan'] ?? '2026-08-01';
            final String monthKey = pickupDateStr.length >= 7 ? pickupDateStr.substring(0, 7) : '2026-08';
            monthlyRevenue[monthKey] = (monthlyRevenue[monthKey] ?? 0) + price + delivery;
          }
        }

        final Map<String, int> menuQtyMap = {};
        for (var order in state.allOrders) {
          final items = (order['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          if (items.isNotEmpty) {
            for (var item in items) {
              final String mName = item['menu_name'] ?? 'Menu Bat-Kitty';
              final int qty = (item['quantity'] as num?)?.toInt() ?? 1;
              menuQtyMap[mName] = (menuQtyMap[mName] ?? 0) + qty;
            }
          } else {
            final String mName = order['menu_name'] ?? 'Menu Bat-Kitty';
            final int qty = (order['quantity'] as num?)?.toInt() ?? 1;
            menuQtyMap[mName] = (menuQtyMap[mName] ?? 0) + qty;
          }
        }

        String topMenuName = 'Tidak ada data';
        if (menuQtyMap.isNotEmpty) {
          final topEntry = menuQtyMap.entries.reduce((a, b) => a.value > b.value ? a : b);
          topMenuName = '${topEntry.key} (${topEntry.value} porsi)';
        }

        final allTransactions = state.allOrders.map((order) {
          final items = (order['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          final firstItem = items.isNotEmpty
              ? items.first
              : {'menu_name': order['menu_name'] ?? 'Menu Bat-Kitty', 'quantity': order['quantity'] ?? 1};

          num foodPriceOnly = (firstItem['unit_price'] as num? ?? 0) * ((firstItem['quantity'] as num? ?? 1).toInt());
          if (foodPriceOnly == 0) {
            foodPriceOnly = ((order['total_price'] as num?) ?? 0) - ((order['delivery_fee'] as num?) ?? 0);
          }

          final num deliveryFee = (order['delivery_fee'] as num?) ?? 0;
          final num totalWithDelivery = foodPriceOnly + deliveryFee;
          final String statusStr = order['status_pesanan'] == 'completed' ? 'Completed' : 'Proses';

          return {
            'id': '#ORD-09${order['id'] ?? '0'}',
            'customer': order['customer_name'] ?? 'Pelanggan',
            'customer_phone': order['customer_phone'] ?? '',
            'tanggal_order': order['tanggal_order'] ?? '-',
            'tanggal_pengambilan': order['tanggal_pengambilan'] ?? '-',
            'delivery_type': order['delivery_type'] ?? 'Pickup',
            'delivery_address': order['delivery_address'],
            'menu_name': firstItem['menu_name'] ?? 'Menu Bat-Kitty',
            'quantity': (firstItem['quantity'] as num?)?.toInt() ?? (order['quantity'] as num?)?.toInt() ?? 1,
            'custom_notes': firstItem['custom_notes'] ?? order['custom_notes'] ?? 'Tidak ada catatan',
            'discount_info': order['id'] == 1 ? 'Pelanggan Pertama' : 'Standar',
            'food': formatRupiah(foodPriceOnly.toInt()),
            'delivery': deliveryFee > 0 ? formatRupiah(deliveryFee.toInt()) : 'Pickup',
            'status': statusStr,
            'delivery_fee_raw': deliveryFee,
            'total_price_raw': totalWithDelivery,
            'review_text': order['review'],
          };
        }).toList();

        final filteredTransactions = allTransactions.where((tx) {
          if (selectedStatusFilter == 'All') return true;
          return tx['status'] == selectedStatusFilter;
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial Overview & Ledger',
                        style: TextStyle(color: BatKittyTheme.textMain, fontSize: 24, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Monitor revenue, monthly performance, and operating expenses',
                        style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 12.5),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BatKittyTheme.hotPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _showAddExpenseDialog(context),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Catat Pengeluaran', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              FinancialMetricsGrid(
                totalFoodRevenue: totalFoodRevenue,
                netProfit: netProfit,
                totalExpenses: totalExpenses,
                topMenuName: topMenuName,
                onExpenseTap: () => _showExpenseDetailModal(context, state.expenses),
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
      },
    );
  }
}