import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../logic/admin/admin_bloc.dart';
import '../../../../logic/admin/admin_state.dart';

class AdminOrderPage extends StatelessWidget {
  const AdminOrderPage({super.key});

  void _openGoogleMaps(String address) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _hubungiWA(String phone, String name, int orderId) async {
    String cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.startsWith('0')) cleanPhone = '62${cleanPhone.substring(1)}';
    final text = Uri.encodeComponent('Halo Kak $name, kurir BatKitty ingin konfirmasi pesanan PO #ORD-$orderId...');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$text');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        final orders = state.filteredOrders;
        final selected = state.selectedOrder ?? (orders.isNotEmpty ? orders.first : null);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pusat Verifikasi & Operasional PO',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kelola status pesanan masuk, verifikasi dapur, dan kontrol rute kurir dalam satu tempat.',
                          style: TextStyle(color: Colors.white.withOpacity(.35), fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 260,
                      height: 38,
                      child: TextField(
                        onChanged: (q) => context.read<AdminBloc>().add(FilterAdminOrdersEvent(query: q)),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Cari order / pelanggan...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(.3), fontSize: 11),
                          prefixIcon: Icon(Icons.search, size: 16, color: Colors.white.withOpacity(.4)),
                          filled: true,
                          fillColor: const Color(0xFF141720),
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1F2433))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: BatKittyTheme.hotPink)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFF1F2433))),
                  ),
                  child: Row(
                    children: [
                      _buildCleanTab(context, state, 'all', 'Semua (${state.allOrders.length})', null, null),
                      _buildCleanTab(context, state, 'waiting_approve', 'Perlu Verifikasi', state.totalWaiting, Colors.orangeAccent),
                      _buildCleanTab(context, state, 'processing', 'Dapur & Kurir', state.totalKitchen, BatKittyTheme.hotPink),
                      _buildCleanTab(context, state, 'completed', 'Selesai', state.totalCompleted, Colors.greenAccent),
                      const Spacer(),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.fulfillmentFilter,
                          dropdownColor: const Color(0xFF141720),
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('Semua Metode')),
                            DropdownMenuItem(value: 'Delivery', child: Text('Hanya Delivery')),
                            DropdownMenuItem(value: 'Pickup', child: Text('Hanya Pickup')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              context.read<AdminBloc>().add(FilterAdminOrdersEvent(fulfillmentFilter: val));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: orders.isEmpty
                            ? Center(
                                child: Text('Tidak ada pesanan di filter ini.', style: TextStyle(color: Colors.white.withOpacity(.3), fontSize: 13)),
                              )
                            : ListView.separated(
                                itemCount: orders.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final item = orders[index];
                                  final isSelected = selected != null && selected['id'] == item['id'];
                                  return _buildOrderListItem(context, item, isSelected);
                                },
                              ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        flex: 4,
                        child: selected == null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF141720),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF1F2433)),
                                ),
                                alignment: Alignment.center,
                                child: Text('Pilih pesanan untuk melihat detail', style: TextStyle(color: Colors.white.withOpacity(.3), fontSize: 12)),
                              )
                            : _buildUnifiedOrderInspector(context, selected),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCleanTab(BuildContext context, AdminState state, String key, String title, int? badgeCount, Color? badgeColor) {
    final isSelected = state.statusFilter == key;
    return InkWell(
      onTap: () => context.read<AdminBloc>().add(FilterAdminOrdersEvent(statusFilter: key)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? BatKittyTheme.hotPink : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(.45),
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (badgeCount != null && badgeCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? BatKittyTheme.hotPink).withOpacity(.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('$badgeCount', style: TextStyle(color: badgeColor ?? BatKittyTheme.hotPink, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderListItem(BuildContext context, Map<String, dynamic> item, bool isSelected) {
    final id = item['id'] ?? 0;
    final isDelivery = item['delivery_type'] == 'Delivery';
    final menuName = item['menu_name'] ?? 'Menu PO';
    final qty = item['quantity'] ?? 1;

    return InkWell(
      onTap: () => context.read<AdminBloc>().add(SelectOrderForDetailEvent(item)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B1F2D) : const Color(0xFF141720),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? BatKittyTheme.hotPink : const Color(0xFF1F2433),
          ),
        ),
        child: Row(
          children: [
            Text('#ORD-$id', style: const TextStyle(color: BatKittyTheme.hotPink, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$menuName ($qty Porsi)',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item['customer_name']} • ${item['tanggal_pengambilan'] ?? '-'}',
                    style: TextStyle(color: Colors.white.withOpacity(.4), fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(isDelivery ? Icons.delivery_dining_rounded : Icons.storefront_outlined, size: 15, color: Colors.white.withOpacity(.4)),
            const SizedBox(width: 16),
            Text(
              formatRupiah(((item['total_price'] as num?) ?? 0).toInt()),
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

Future<void> _updateOrderStatusAPI(
  BuildContext context, 
  int orderId, 
  String targetStatus, {
  String? reason,
}) async {
  context.read<AdminBloc>().add(
    UpdateAdminOrderStatusEvent(
      orderId: orderId,
      newStatus: targetStatus,
      reason: reason,
    ),
  );
}
Widget _buildUnifiedOrderInspector(BuildContext context, Map<String, dynamic> item) {
  final int id = item['id'] ?? 0;
  final status = item['status_pesanan'] ?? 'processing';
  final isWaiting = status == 'waiting_approve';
  final isProcessing = status == 'processing';
  final isDelivering = status == 'delivering';
  final isCompleted = status == 'completed';
  final isDelivery = item['delivery_type'] == 'Delivery';
  final notes = (item['custom_notes'] ?? '').toString();
  final address = item['delivery_address'] ?? 'Semarang';
  final menuName = item['menu_name'] ?? 'Menu PO';
  final qty = item['quantity'] ?? 1;

  return Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: const Color(0xFF141720),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFF1F2433)),
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detail Pesanan #ORD-$id', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(item['customer_name'] ?? 'Pelanggan', style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 12)),
                ],
              ),
              IconButton(
                tooltip: 'Chat WhatsApp Pelanggan',
                onPressed: () => _hubungiWA(item['customer_phone'] ?? '', item['customer_name'] ?? '', id),
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.greenAccent, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF1F2433), height: 1),
          const SizedBox(height: 16),

          if (notes.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withOpacity(.25)),
              ),
              child: Text('Instruksi Dapur: "$notes"', style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 16),
          ],

          _buildInspectorRow('Menu Dipesan', '$menuName ($qty Porsi)'),
          _buildInspectorRow('Jadwal Antar/Ambil', item['tanggal_pengambilan'] ?? '-'),
          _buildInspectorRow('Metode Pemenuhan', item['delivery_type'] ?? '-'),
          _buildInspectorRow('Status Pembayaran', (item['status_bayar'] ?? 'Lunas').toUpperCase()),
          _buildInspectorRow('Total Tagihan', formatRupiah(((item['total_price'] as num?) ?? 0).toInt())),

          if (isDelivery) ...[
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _openGoogleMaps(address),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF1A1F2C), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: BatKittyTheme.hotPink),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(address, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 11)),
                    ),
                    const Icon(Icons.open_in_new_rounded, size: 12, color: Colors.white54),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          if (isWaiting) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _updateOrderStatusAPI(context, id, 'cancelled', reason: 'Ditolak admin');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: BorderSide(color: Colors.redAccent.withOpacity(.4)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Tolak', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      _updateOrderStatusAPI(context, id, 'approved');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BatKittyTheme.hotPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Setujui Pesanan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ] else if (isProcessing && isDelivery) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _updateOrderStatusAPI(context, id, 'delivering');
                },
                icon: const Icon(Icons.two_wheeler_rounded, size: 16),
                label: const Text('Kurir Berangkat Antar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ] else if (isDelivering) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _updateOrderStatusAPI(context, id, 'completed', );
                },
                icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                label: const Text('Tandai Sampai / Selesai'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ] else if (isProcessing && !isDelivery) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _updateOrderStatusAPI(context, id, 'completed', );
                },
                icon: const Icon(Icons.storefront_outlined, size: 16),
                label: const Text('Tandai Telah Diambil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.green.withOpacity(.1), borderRadius: BorderRadius.circular(8)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'PESANAN TELAH SELESAI',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

Widget _buildInspectorRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(.4), fontSize: 11.5)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

  
}