import 'package:batnkitty_food/components/customer/checkout_order_sheet.dart';
import 'package:batnkitty_food/components/customer/customer_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/theme.dart';
import '../../logic/customer/customer_catalog_bloc.dart';
import '../../logic/customer/customer_catalog_state.dart';
import '/components/customer/operational_banner.dart';
import '/components/customer/customer_order_card.dart';
import '/components/customer/customer_menu_card.dart';
import '/components/customer/checkout_order_sheet.dart';

class CustomerCatalogPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const CustomerCatalogPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerCatalogBloc()..add(LoadCustomerCatalogEvent(user['phone'] ?? '')),
      child: _CustomerCatalogView(user: user),
    );
  }
}

class _CustomerCatalogView extends StatelessWidget {
  final Map<String, dynamic> user;

  const _CustomerCatalogView({required this.user});

  Future<void> _hubungiAdminWA(String pesan) async {
    const adminPhone = '6281234567890';
    final uri = Uri.parse('https://wa.me/$adminPhone?text=${Uri.encodeComponent(pesan)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: error ? Colors.redAccent : BatKittyTheme.surfaceDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: Row(
            children: [
              Icon(error ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      );
  }

  void _openCancelModal(BuildContext context, Map<String, dynamic> order) {
    final schedule = DateTime.parse(order['tanggal_pengambilan']);
    if (DateTime.now().isAfter(schedule.subtract(const Duration(hours: 4)))) {
      _showSnackBar(context, 'Pembatalan hanya dapat dilakukan maksimal 4 jam sebelum jadwal.', error: true);
      return;
    }

    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BatKittyTheme.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Batalkan Pesanan?', style: TextStyle(color: BatKittyTheme.textMain, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order['menu_name'] ?? 'Pesanan', style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 13)),
            const SizedBox(height: 18),
            TextField(
              controller: reasonController,
              maxLines: 3,
              style: const TextStyle(color: BatKittyTheme.textMain),
              decoration: InputDecoration(
                hintText: 'Tuliskan alasan pembatalan...',
                hintStyle: const TextStyle(color: BatKittyTheme.textMuted),
                filled: true,
                fillColor: BatKittyTheme.bgDark,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Kembali', style: TextStyle(color: BatKittyTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (reasonController.text.trim().isEmpty) return;
              context.read<CustomerCatalogBloc>().add(
                CancelCustomerOrderEvent(orderId: order['id'], reason: reasonController.text.trim()),
              );
              Navigator.pop(ctx);
            },
            child: const Text('Batalkan', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _openCheckoutModal(BuildContext context, Map<String, dynamic> menu) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CheckoutOrderSheet(
        menu: menu,
        userName: user['name'] ?? 'Pelanggan',
        onConfirm: (newOrder) {
          context.read<CustomerCatalogBloc>().add(CreateCustomerOrderEvent(newOrder));
          _hubungiAdminWA(
            'Halo Admin BatKitty, saya ${user['name']} membuat pesanan PO:\n\n'
            'Menu: ${menu['name']}\n'
            'Jumlah: ${newOrder['quantity']}\n'
            'Tipe: ${newOrder['delivery_type']}\n'
            'Mohon konfirmasinya.',
          );
        },
      ),
    );
  }

  // Modal Riwayat Pesanan Lengkap (All Order & All Status)
  void _openOrdersHistoryDialog(BuildContext context, List<Map<String, dynamic>> orders) {
    String selectedFilter = 'all';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (modalContext, setModalState) {
          final filteredOrders = orders.where((o) {
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
                            'Total ${orders.length} pesanan tercatat',
                            style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, color: BatKittyTheme.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Semua (${orders.length})', 'all', selectedFilter, (val) => setModalState(() => selectedFilter = val)),
                        const SizedBox(width: 8),
                        _buildFilterChip('Menunggu Konfirmasi', 'waiting_approve', selectedFilter, (val) => setModalState(() => selectedFilter = val)),
                        const SizedBox(width: 8),
                        _buildFilterChip('Dikonfirmasi', 'approved', selectedFilter, (val) => setModalState(() => selectedFilter = val)),
                        const SizedBox(width: 8),
                        _buildFilterChip('Diproses', 'processing', selectedFilter, (val) => setModalState(() => selectedFilter = val)),
                        const SizedBox(width: 8),
                        _buildFilterChip('Selesai', 'completed', selectedFilter, (val) => setModalState(() => selectedFilter = val)),
                        const SizedBox(width: 8),
                        _buildFilterChip('Dibatalkan', 'cancelled', selectedFilter, (val) => setModalState(() => selectedFilter = val)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: BatKittyTheme.borderSubtle, height: 1),
                  const SizedBox(height: 16),

                  // Daftar Pesanan
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
                                Navigator.pop(ctx);
                                _openCancelModal(context, filteredOrders[i]);
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String current, ValueChanged<String> onSelected) {
    final bool active = current == value;
    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? BatKittyTheme.hotPink : BatKittyTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? BatKittyTheme.hotPink : BatKittyTheme.borderSubtle),
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

  @override
  Widget build(BuildContext context) {
    final userName = user['name']?.toString().trim() ?? 'Pelanggan';
    final firstName = userName.split(' ').first;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return BlocConsumer<CustomerCatalogBloc, CustomerCatalogState>(
      listener: (context, state) {
        if (state.message != null) {
          _showSnackBar(context, state.message!, error: state.isError);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: BatKittyTheme.bgDark,
          appBar: AppBar(
            backgroundColor: BatKittyTheme.bgDark,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 20,
            title: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [BatKittyTheme.hotPink, Colors.deepPurpleAccent]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 19),
                ),
                const SizedBox(width: 11),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BatKitty',
                      style: TextStyle(
                        color: BatKittyTheme.textMain,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.3,
                      ),
                    ),
                    Text(
                      'Food Experience',
                      style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 9),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Tombol Riwayat Pesanan di Pojok Atas
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton.icon(
                  onPressed: () => _openOrdersHistoryDialog(context, state.myOrders),
                  style: TextButton.styleFrom(
                    backgroundColor: BatKittyTheme.surfaceDark,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: BatKittyTheme.borderSubtle),
                    ),
                  ),
                  icon: const Icon(Icons.receipt_long_rounded, size: 17, color: BatKittyTheme.hotPink),
                  label: Row(
                    children: [
                      const Text(
                        'Pesanan Saya',
                        style: TextStyle(
                          color: BatKittyTheme.textMain,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (state.myOrders.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: BatKittyTheme.hotPink,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${state.myOrders.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // // Tombol Bantuan WA
              // Padding(
              //   padding: const EdgeInsets.only(right: 14),
              //   child: IconButton(
              //     tooltip: 'Hubungi Admin',
              //     onPressed: () => _hubungiAdminWA('Halo Admin BatKitty, saya ingin bertanya seputar pesanan.'),
              //     icon: Container(
              //       width: 38,
              //       height: 38,
              //       decoration: BoxDecoration(
              //         color: BatKittyTheme.surfaceDark,
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(color: BatKittyTheme.borderSubtle),
              //       ),
              //       child: const Icon(Icons.chat_bubble_outline_rounded, size: 17, color: BatKittyTheme.textMain),
              //     ),
              //   ),
              // ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good day, $firstName 👋',
                              style: const TextStyle(
                                color: BatKittyTheme.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'What are you craving today?',
                              style: TextStyle(
                                color: BatKittyTheme.textMain,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -.8,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Fresh meals, made for your day.',
                              style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                        child: OperationalBanner(state: state),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Explore Menu',
                                    style: TextStyle(
                                      color: BatKittyTheme.textMain,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -.4,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Pilihan menu terbaik BatKitty',
                                    style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 10.5),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.tune_rounded, color: BatKittyTheme.textMuted, size: 19),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => CustomerMenuCard(
                            menu: state.activeMenus[index],
                            canOrder: state.canOrder,
                            onOrder: () => _openCheckoutModal(context, state.activeMenus[index]),
                          ),
                          childCount: state.activeMenus.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 4 : 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: isDesktop ? 1.35 : 0.95,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _hubungiAdminWA('Halo Admin BatKitty, saya ingin bertanya seputar menu/pesanan.'),
            backgroundColor: BatKittyTheme.surfaceDark,
            foregroundColor: BatKittyTheme.textMain,
            elevation: 8,
            icon: const Icon(Icons.support_agent_rounded, size: 19),
            label: const Text('Need help?', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        );
      },
    );
  }
}