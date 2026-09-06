import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/theme.dart';
import '../../../logic/customer/customer_catalog_bloc.dart';
import 'midtrans_qris_dialog.dart';

class CustomerOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onCancel;

  const CustomerOrderCard({
    super.key,
    required this.order,
    required this.onCancel,
  });

  String _formatRupiah(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;
    final formatted = number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
    return 'Rp $formatted';
  }

  String _formatDate(dynamic value) {
    try {
      final date = DateTime.parse(value.toString());
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return value?.toString() ?? '-';
    }
  }

  String _humanizeStatus(String status) {
    switch (status) {
      case 'waiting_approve':
        return 'Menunggu Konfirmasi';
      case 'approved':
        return 'Dikonfirmasi';
      case 'processing':
        return 'Diproses Dapur';
      case 'ready':
        return 'Siap Diambil';
      case 'delivering':
        return 'Sedang Diantar';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status.replaceAll('_', ' ');
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
      case 'ready':
      case 'completed':
        return Colors.greenAccent;
      case 'processing':
      case 'delivering':
        return Colors.blueAccent;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle_outline_rounded;
      case 'processing':
        return Icons.restaurant_rounded;
      case 'ready':
        return Icons.inventory_2_outlined;
      case 'delivering':
        return Icons.delivery_dining_rounded;
      case 'completed':
        return Icons.verified_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int orderId = order['id'] ?? 0;
    final status = order['status_pesanan'] ?? 'waiting_approve';
    final statusBayar = (order['status_bayar'] ?? 'unpaid').toString().toLowerCase();
    final bool isPaid = statusBayar == 'lunas' || statusBayar == 'paid';
    final isCancelled = status == 'cancelled';
    final color = _statusColor(status);
    final isDelivery = order['delivery_type'] == 'Delivery';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#ORD-$orderId',
                          style: const TextStyle(
                            color: BatKittyTheme.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge Status Pembayaran
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (isPaid ? Colors.greenAccent : Colors.orangeAccent).withOpacity(.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: (isPaid ? Colors.greenAccent : Colors.orangeAccent).withOpacity(.3),
                            ),
                          ),
                          child: Text(
                            isPaid ? 'LUNAS' : 'BELUM BAYAR',
                            style: TextStyle(
                              color: isPaid ? Colors.greenAccent : Colors.orangeAccent,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['menu_name'] ?? 'Pesanan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: BatKittyTheme.textMain,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _formatRupiah((order['total_price'] as num?)?.toInt() ?? 0),
                style: const TextStyle(
                  color: BatKittyTheme.hotPink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: BatKittyTheme.borderSubtle, height: 1),
          const SizedBox(height: 12),

          Row(
            children: [
              // Info Porsi & Tipe Pengantaran
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: BatKittyTheme.bgDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDelivery ? Icons.delivery_dining_rounded : Icons.storefront_outlined,
                      size: 13,
                      color: BatKittyTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${order['quantity'] ?? 1} porsi • ${order['delivery_type'] ?? '-'}',
                      style: const TextStyle(
                        color: BatKittyTheme.textMuted,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Tanggal Pengambilan
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: BatKittyTheme.textMuted),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        _formatDate(order['tanggal_pengambilan']),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: BatKittyTheme.textMain,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Status Alur Pesanan
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon(status), size: 12, color: color),
                    const SizedBox(width: 4),
                    Text(
                      _humanizeStatus(status),
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Batal (Jika Masih Menunggu Konfirmasi)
              if (!isCancelled && status == 'waiting_approve') ...[
                const SizedBox(width: 8),
                SizedBox(
                  height: 26,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: BorderSide(color: Colors.redAccent.withOpacity(.4)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Batal', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],

              // Tombol Bayar QRIS (Jika Dikonfirmasi & Belum Lunas)
              if (status == 'approved' && !isPaid) ...[
                const SizedBox(width: 8),
                SizedBox(
                  height: 26,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      MidtransQrisDialog.show(
                        context,
                        order: order,
                        onPaymentSuccess: () {
                          context.read<CustomerCatalogBloc>().add(
                                MarkOrderPaidEvent(
                                  orderId: orderId,
                                  transactionId: 'TRX-SIMULATED-$orderId',
                                ),
                              );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BatKittyTheme.hotPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.qr_code_2_rounded, size: 13),
                    label: const Text('Bayar QRIS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}