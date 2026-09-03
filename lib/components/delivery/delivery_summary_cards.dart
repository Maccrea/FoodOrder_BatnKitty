import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class DeliverySummaryCards extends StatelessWidget {
  final int pendingCount;
  final int deliveringCount;
  final int deliveredCount;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const DeliverySummaryCards({
    super.key,
    required this.pendingCount,
    required this.deliveringCount,
    required this.deliveredCount,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onFilterChanged('Pending'),
            child: _buildCard('Pending', pendingCount.toString(), Icons.schedule_rounded, Colors.amberAccent, isSelected: selectedFilter == 'Pending'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: GestureDetector(
            onTap: () => onFilterChanged('Delivering'),
            child: _buildCard('Delivering', deliveringCount.toString(), Icons.local_shipping_rounded, BatKittyTheme.hotPink, isSelected: selectedFilter == 'Delivering'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: GestureDetector(
            onTap: () => onFilterChanged('Delivered'),
            child: _buildCard('Completed', deliveredCount.toString(), Icons.check_circle_outline_rounded, Colors.greenAccent, isSelected: selectedFilter == 'Delivered'),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? BatKittyTheme.hotPink : BatKittyTheme.borderSubtle,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}