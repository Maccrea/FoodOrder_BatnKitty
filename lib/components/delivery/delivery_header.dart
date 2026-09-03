import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class DeliveryHeader extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DeliveryHeader({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
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
    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = "${selectedDate.day.toString().padLeft(2, '0')} ${_getMonthName(selectedDate.month)} ${selectedDate.year}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Tasks',
              style: TextStyle(
                color: BatKittyTheme.textMain,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Manage today\'s delivery operations',
              style: TextStyle(
                color: BatKittyTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: BatKittyTheme.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: BatKittyTheme.borderSubtle),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: BatKittyTheme.pinkGlow),
                const SizedBox(width: 8),
                Text(
                  'Date · $formattedDate',
                  style: const TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_drop_down_rounded, size: 16, color: BatKittyTheme.textSubtle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}