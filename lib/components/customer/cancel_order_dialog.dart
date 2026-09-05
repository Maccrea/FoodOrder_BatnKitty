import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class CancelOrderDialog extends StatelessWidget {
  final Map<String, dynamic> order;
  final ValueChanged<String> onConfirmCancel;

  const CancelOrderDialog({
    super.key,
    required this.order,
    required this.onConfirmCancel,
  });

  static void show(
    BuildContext context, {
    required Map<String, dynamic> order,
    required ValueChanged<String> onConfirmCancel,
    required VoidCallback onExceededDeadline,
  }) {
    final scheduleStr = order['tanggal_pengambilan'];
    if (scheduleStr != null) {
      final schedule = DateTime.tryParse(scheduleStr.toString());
      if (schedule != null && DateTime.now().isAfter(schedule.subtract(const Duration(hours: 4)))) {
        onExceededDeadline();
        return;
      }
    }

    showDialog(
      context: context,
      builder: (_) => CancelOrderDialog(
        order: order,
        onConfirmCancel: onConfirmCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reasonController = TextEditingController();

    return AlertDialog(
      backgroundColor: BatKittyTheme.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(
        'Batalkan Pesanan?',
        style: TextStyle(color: BatKittyTheme.textMain, fontWeight: FontWeight.w800),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order['menu_name'] ?? 'Pesanan',
            style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 13),
          ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kembali', style: TextStyle(color: BatKittyTheme.textMuted)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            final reason = reasonController.text.trim();
            if (reason.isEmpty) return;
            Navigator.pop(context);
            onConfirmCancel(reason);
          },
          child: const Text('Batalkan', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}