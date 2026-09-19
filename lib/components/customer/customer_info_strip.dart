import 'package:flutter/material.dart';

import '../../core/constants/theme.dart';

class CustomerInfoStrip extends StatelessWidget {
  const CustomerInfoStrip({
    super.key,
  });

  static const Color surface = Color(0xFF121419);
  static const Color textLight = Color(0xFFF5F5F6);
  static const Color textMuted = Color(0xFF858A95);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.white.withOpacity(.055),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _InfoItem(
              icon: Icons.local_shipping_outlined,
              title: 'Delivery',
              subtitle: 'H+2',
            ),
          ),
          _Divider(),
          Expanded(
            child: _InfoItem(
              icon: Icons.payments_outlined,
              title: 'Bayar',
              subtitle: 'QRIS',
            ),
          ),
          _Divider(),
          Expanded(
            child: _InfoItem(
              icon: Icons.confirmation_number_outlined,
              title: 'Loyalty',
              subtitle: 'Order #5',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: BatKittyTheme.hotPink,
        ),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: const Color(0xFF858A95),
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              style: const TextStyle(
                color: const Color(0xFFF5F5F6),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 27,
      color: Colors.white.withOpacity(.07),
    );
  }
}