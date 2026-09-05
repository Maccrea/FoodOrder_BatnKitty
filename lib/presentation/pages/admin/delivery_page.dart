import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/theme.dart';
import '../../../../logic/admin/admin_bloc.dart';
import '../../../../logic/admin/admin_state.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  void _openGoogleMaps(String address) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _hubungiWA(String phone, String name) async {
    String cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.startsWith('0')) cleanPhone = '62${cleanPhone.substring(1)}';
    final text = Uri.encodeComponent('Halo Kak $name, kurir BatKitty sedang mengantar pesanan katering ke alamat Kakak ya!');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$text');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        final tasks = state.deliveryTasksOnDate;
        final selectedDate = state.selectedDeliveryDate;

        final pendingCount = tasks.where((o) => o['status_pesanan'] != 'delivering' && o['status_pesanan'] != 'completed').length;
        final deliveringCount = tasks.where((o) => o['status_pesanan'] == 'delivering').length;
        final completedCount = tasks.where((o) => o['status_pesanan'] == 'completed').length;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
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
                        'Manifes Pengiriman Kurir',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rute antar pesanan katering dan pemantauan kurir harian.',
                        style: TextStyle(color: Colors.white.withOpacity(.35), fontSize: 12),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2030),
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: BatKittyTheme.hotPink,
                              surface: Color(0xFF141720),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        context.read<AdminBloc>().add(ChangeDeliveryDateEvent(picked));
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141720),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF1F2433)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: BatKittyTheme.hotPink, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Tanggal: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white38, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  _buildMetricBox('Belum Berangkat', '$pendingCount', Icons.schedule_rounded, Colors.orangeAccent),
                  const SizedBox(width: 14),
                  _buildMetricBox('Sedang Dijalan', '$deliveringCount', Icons.two_wheeler_rounded, Colors.tealAccent),
                  const SizedBox(width: 14),
                  _buildMetricBox('Terkirim', '$completedCount', Icons.check_circle_outline_rounded, Colors.greenAccent),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Daftar Tugas Antar', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('${tasks.length} alamat tercatat', style: TextStyle(color: Colors.white.withOpacity(.35), fontSize: 12)),
                ],
              ),

              const SizedBox(height: 12),

              if (tasks.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF141720),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1F2433)),
                  ),
                  child: Text('Tidak ada jadwal pengiriman kurir untuk tanggal ini.', style: TextStyle(color: Colors.white.withOpacity(.3), fontSize: 12)),
                )
              else
                ...tasks.map((task) => _buildDeliveryTaskCard(context, task)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricBox(String label, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141720),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1F2433)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.white.withOpacity(.4), fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(count, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTaskCard(BuildContext context, Map<String, dynamic> task) {
    final int id = task['id'] ?? 0;
    final String status = task['status_pesanan'] ?? 'processing';
    final String address = task['delivery_address'] ?? 'Binus University Semarang, POJ City';
    final String customerName = task['customer_name'] ?? 'Pelanggan';
    final String phone = task['customer_phone'] ?? '';
    final isDelivering = status == 'delivering';
    final isCompleted = status == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDelivering ? Colors.tealAccent.withOpacity(.3) : const Color(0xFF1F2433),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF0D0F15), borderRadius: BorderRadius.circular(8)),
            child: Text('#ORD-$id', style: const TextStyle(color: BatKittyTheme.hotPink, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
          const SizedBox(width: 18),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customerName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 3),
                InkWell(
                  onTap: () => _hubungiWA(phone, customerName),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, size: 12, color: Colors.greenAccent),
                      const SizedBox(width: 4),
                      Text(phone.isEmpty ? '-' : phone, style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => _openGoogleMaps(address),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 15, color: Colors.tealAccent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 11.5, decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.open_in_new_rounded, size: 12, color: Colors.white38),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (isCompleted ? Colors.greenAccent : isDelivering ? Colors.tealAccent : Colors.orangeAccent).withOpacity(.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isCompleted ? 'Terkirim' : isDelivering ? 'Sedang Antar' : 'Menunggu',
              style: TextStyle(
                color: isCompleted ? Colors.greenAccent : isDelivering ? Colors.tealAccent : Colors.orangeAccent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          if (!isCompleted) ...[
            SizedBox(
              height: 34,
              child: ElevatedButton(
                onPressed: () {
                  final nextStatus = isDelivering ? 'Delivered' : 'Delivering';
                  context.read<AdminBloc>().add(UpdateDeliveryStatusEvent(orderId: id, nextStatus: nextStatus));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDelivering ? Colors.green : BatKittyTheme.hotPink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  isDelivering ? 'Tandai Sampai' : 'Berangkat Antar',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ] else ...[
            const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 22),
          ],
        ],
      ),
    );
  }
}