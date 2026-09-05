import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class CheckoutOrderSheet extends StatefulWidget {
  final Map<String, dynamic> menu;
  final String userName;
  final Function(Map<String, dynamic> order) onConfirm;

  const CheckoutOrderSheet({
    super.key,
    required this.menu,
    required this.userName,
    required this.onConfirm,
  });

  @override
  State<CheckoutOrderSheet> createState() => _CheckoutOrderSheetState();
}

class _CheckoutOrderSheetState extends State<CheckoutOrderSheet> {
  DateTime? selectedSchedule;
  final notesController = TextEditingController();
  final addressController = TextEditingController();
  String deliveryType = 'Delivery';
  int qty = 1;

  bool _isKitchenOperationalHours(TimeOfDay time) {
    const int openHour = 8;
    const int closeHour = 17;

    if (time.hour < openHour || time.hour > closeHour) {
      return false;
    }
    if (time.hour == closeHour && time.minute > 0) {
      return false;
    }
    return true;
  }

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

  void _showNotification(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: isError ? Colors.redAccent : Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final int basePrice = (widget.menu['base_price'] as num?)?.toInt() ?? 0;
    final int subtotal = basePrice * qty;
    final int deliveryFee = deliveryType == 'Delivery' ? 5000 : 0;
    final int total = subtotal + deliveryFee;

    return Container(
      decoration: const BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22, 12, 22, MediaQuery.of(context).viewInsets.bottom + 22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: BatKittyTheme.textMuted.withOpacity(.35),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Complete Your Order',
                          style: TextStyle(
                            color: BatKittyTheme.textMain,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.4,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Atur detail pesanan kamu', style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: BatKittyTheme.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BatKittyTheme.surfaceHighlight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: widget.menu['image_url'] != null && widget.menu['image_url'].toString().isNotEmpty
                          ? Image.network(
                              widget.menu['image_url'],
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                color: BatKittyTheme.bgDark,
                                child: const Icon(Icons.restaurant, color: BatKittyTheme.textMuted),
                              ),
                            )
                          : Container(
                              width: 72,
                              height: 72,
                              color: BatKittyTheme.bgDark,
                              child: const Icon(Icons.restaurant, color: BatKittyTheme.textMuted),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.menu['name'] ?? 'Menu',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: BatKittyTheme.textMain,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatRupiah(basePrice),
                            style: const TextStyle(
                              color: BatKittyTheme.hotPink,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: BatKittyTheme.bgDark,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: qty > 1 ? () => setState(() => qty--) : null,
                            icon: const Icon(Icons.remove_rounded, size: 18),
                            color: BatKittyTheme.textMain,
                          ),
                          Text('$qty', style: const TextStyle(color: BatKittyTheme.textMain, fontWeight: FontWeight.w800)),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => setState(() => qty++),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            color: BatKittyTheme.hotPink,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text('Fulfillment', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: BatKittyTheme.bgDark, borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => deliveryType = 'Delivery'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: deliveryType == 'Delivery' ? BatKittyTheme.hotPink.withOpacity(.14) : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: deliveryType == 'Delivery' ? BatKittyTheme.hotPink : Colors.transparent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delivery_dining, size: 17, color: deliveryType == 'Delivery' ? BatKittyTheme.hotPink : BatKittyTheme.textMuted),
                              const SizedBox(width: 7),
                              Text('Delivery', style: TextStyle(color: deliveryType == 'Delivery' ? BatKittyTheme.textMain : BatKittyTheme.textMuted, fontWeight: FontWeight.w700, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => deliveryType = 'Pickup'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: deliveryType == 'Pickup' ? BatKittyTheme.hotPink.withOpacity(.14) : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: deliveryType == 'Pickup' ? BatKittyTheme.hotPink : Colors.transparent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.storefront_outlined, size: 17, color: deliveryType == 'Pickup' ? BatKittyTheme.hotPink : BatKittyTheme.textMuted),
                              const SizedBox(width: 7),
                              Text('Pickup', style: TextStyle(color: deliveryType == 'Pickup' ? BatKittyTheme.textMain : BatKittyTheme.textMuted, fontWeight: FontWeight.w700, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              GestureDetector(
                onTap: () async {
                  final now = DateTime.now();
                  final earliestDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 2));
                  final latestDate = earliestDate.add(const Duration(days: 14));

                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: earliestDate,
                    firstDate: earliestDate,
                    lastDate: latestDate,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: BatKittyTheme.hotPink,
                            onPrimary: Colors.white,
                            surface: BatKittyTheme.surfaceDark,
                            onSurface: BatKittyTheme.textMain,
                          ),
                          dialogBackgroundColor: BatKittyTheme.surfaceDark,
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate == null) return;

                  if (!context.mounted) return;

                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 10, minute: 0),
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: BatKittyTheme.hotPink,
                              onPrimary: Colors.white,
                              surface: BatKittyTheme.surfaceDark,
                              onSurface: BatKittyTheme.textMain,
                            ),
                            dialogBackgroundColor: BatKittyTheme.surfaceDark,
                          ),
                          child: child!,
                        ),
                      );
                    },
                  );
                  if (pickedTime == null) return;

                  if (!_isKitchenOperationalHours(pickedTime)) {
                    _showNotification('Jam operasional pengantaran/pickup hanya 08:00 – 17:00 WIB.');
                    return;
                  }

                  final fullTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  setState(() => selectedSchedule = fullTime);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: BatKittyTheme.bgDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BatKittyTheme.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (selectedSchedule == null ? Colors.orangeAccent : Colors.greenAccent).withOpacity(.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: selectedSchedule == null ? Colors.orangeAccent : Colors.greenAccent,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jadwal (Min. H-2 Hari • 08:00–17:00 WIB)',
                              style: TextStyle(
                                color: BatKittyTheme.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              selectedSchedule == null
                                  ? 'Pilih jadwal pengambilan / antar'
                                  : _formatDate(selectedSchedule),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: BatKittyTheme.textMain,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: BatKittyTheme.textMuted, size: 20),
                    ],
                  ),
                ),
              ),

              if (deliveryType == 'Delivery') ...[
                const SizedBox(height: 14),
                TextField(
                  controller: addressController,
                  style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Alamat Pengiriman',
                    hintText: 'Masukkan alamat lengkap',
                    prefixIcon: const Icon(Icons.location_on_outlined, size: 19, color: BatKittyTheme.textMuted),
                    filled: true,
                    fillColor: BatKittyTheme.bgDark,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: BatKittyTheme.borderSubtle)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: BatKittyTheme.hotPink)),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              TextField(
                controller: notesController,
                maxLines: 2,
                style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  hintText: 'Contoh: tidak pedas, tanpa sambal & saus tomat...',
                  prefixIcon: const Icon(Icons.edit_note_rounded, size: 19, color: BatKittyTheme.textMuted),
                  filled: true,
                  fillColor: BatKittyTheme.bgDark,
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: BatKittyTheme.borderSubtle)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: BatKittyTheme.hotPink)),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BatKittyTheme.bgDark,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: BatKittyTheme.borderSubtle),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal', style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 11)),
                        Text(_formatRupiah(subtotal), style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery', style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 11)),
                        Text(deliveryFee == 0 ? 'Gratis' : _formatRupiah(deliveryFee), style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(color: BatKittyTheme.borderSubtle, height: 1)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 13, fontWeight: FontWeight.w800)),
                        Text(_formatRupiah(total), style: const TextStyle(color: BatKittyTheme.hotPink, fontSize: 15, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BatKittyTheme.hotPink,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if (selectedSchedule == null) {
                      _showNotification('Pilih jadwal terlebih dahulu.');
                      return;
                    }
                    if (deliveryType == 'Delivery' && addressController.text.trim().isEmpty) {
                      _showNotification('Alamat pengiriman wajib diisi.');
                      return;
                    }

                    widget.onConfirm({
                      'id': DateTime.now().millisecondsSinceEpoch % 10000,
                      'tanggal_order': DateTime.now().toIso8601String(),
                      'tanggal_pengambilan': selectedSchedule!.toIso8601String(),
                      'total_price': subtotal,
                      'delivery_fee': deliveryFee,
                      'delivery_type': deliveryType,
                      'delivery_address': deliveryType == 'Delivery' ? addressController.text.trim() : null,
                      'custom_notes': notesController.text.trim(),
                      'status_pesanan': 'waiting_approve',
                      'status_bayar': 'unpaid',
                      'status_masak': 'Pending',
                      'cancellation_reason': null,
                      'menu_name': widget.menu['name'],
                      'quantity': qty,
                    });

                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 19),
                      const SizedBox(width: 9),
                      Text('Konfirmasi • ${_formatRupiah(total)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}