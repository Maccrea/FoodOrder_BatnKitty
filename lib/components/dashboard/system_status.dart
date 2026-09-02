import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class SystemStatus extends StatelessWidget {
  const SystemStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.monitor_heart_rounded, color: BatKittyTheme.hotPink, size: 17),
              SizedBox(width: 9),
              Text(
                'System Status',
                style: TextStyle(color: BatKittyTheme.textMain, fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _systemItem('Database', 'Healthy', Colors.greenAccent),
              const SizedBox(width: 24),
              _systemItem('Automation', 'Active', Colors.greenAccent),
              const SizedBox(width: 24),
              _systemItem('Payments', 'Online', Colors.greenAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _systemItem(String label, String status, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 9)),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.circle, color: color, size: 7),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}