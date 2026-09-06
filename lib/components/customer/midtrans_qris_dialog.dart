import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/formatters.dart';

class MidtransQrisDialog extends StatefulWidget {
  final Map<String, dynamic> order;
  final VoidCallback onPaymentSuccess;

  const MidtransQrisDialog({
    super.key,
    required this.order,
    required this.onPaymentSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required Map<String, dynamic> order,
    required VoidCallback onPaymentSuccess,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MidtransQrisDialog(
        order: order,
        onPaymentSuccess: onPaymentSuccess,
      ),
    );
  }

  @override
  State<MidtransQrisDialog> createState() => _MidtransQrisDialogState();
}

class _MidtransQrisDialogState extends State<MidtransQrisDialog> {
  late Timer _timer;
  int _secondsRemaining = 15 * 60; // 15 Menit batas bayar QRIS
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _simulateCheckPayment() async {
    setState(() => _isChecking = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isChecking = false);

    Navigator.pop(context);
    widget.onPaymentSuccess();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
            SizedBox(width: 10),
            Text('Pembayaran Berhasil Diverifikasi! Status: Lunas'),
          ],
        ),
        backgroundColor: Color(0xFF141720),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int orderId = widget.order['id'] ?? 0;
    final num totalBill = widget.order['total_price'] ?? 0;
    // Skema Fee QRIS Midtrans 0.7%
    final num fee = (totalBill * 0.007).round();
    final String qrisPayload = '00020101021226680016ID.MIDTRANS.WWW0118936009110000000000520458125802ID5913BATKITTY_FOOD6008SEMARANG62070703A016304';

    return Dialog(
      backgroundColor: const Color(0xFF141720),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF222634)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Dialog
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: BatKittyTheme.hotPink.withOpacity(.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.qr_code_2_rounded, color: BatKittyTheme.hotPink, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pembayaran QRIS',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'Midtrans Powered • Order #ORD-$orderId',
                          style: const TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Banner Countdown Timer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orangeAccent.withOpacity(.25)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: Colors.orangeAccent),
                  const SizedBox(width: 8),
                  Text(
                    'Selesaikan pembayaran dalam: ${_formatDuration(_secondsRemaining)}',
                    style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Container Barcode QRIS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: BatKittyTheme.hotPink.withOpacity(.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo Banner QRIS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_scanner_rounded, color: Colors.black87, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'QRIS STANDAR PEMBAYARAN NASIONAL',
                        style: TextStyle(color: Colors.grey.shade800, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // QR Image Generator
                  QrImageView(
                    data: qrisPayload,
                    version: QrVersions.auto,
                    size: 190.0,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'NMID: ID102638849204 • BatKitty Food',
                    style: TextStyle(color: Colors.black54, fontSize: 9.5, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Rincian Pembayaran
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0F15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E2230)),
              ),
              child: Column(
                children: [
                  _priceRow('Total Pesanan', formatRupiah(totalBill.toInt())),
                  const SizedBox(height: 6),
                  _priceRow('Biaya Layanan QRIS (0.7%)', formatRupiah(fee.toInt())),
                  const Divider(color: Color(0xFF1E2230), height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total yang Dipindai', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(
                        formatRupiah(totalBill.toInt()),
                        style: const TextStyle(color: Colors.greenAccent, fontSize: 15, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tombol Cek Bayar
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BatKittyTheme.hotPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: _isChecking ? null : _simulateCheckPayment,
                child: _isChecking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Saya Sudah Membayar (Cek Status)',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11.5)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
      ],
    );
  }
}