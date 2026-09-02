import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BatKittyTheme.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: BatKittyTheme.hotPink.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: BatKittyTheme.hotPink,
              size: 23,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning, Administrator',
                  style: TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Here is what is happening with your operation today.',
                  style: TextStyle(
                    color: BatKittyTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.greenAccent.withOpacity(.22)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 7, color: Colors.greenAccent),
                SizedBox(width: 7),
                Text(
                  'All systems operational',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}