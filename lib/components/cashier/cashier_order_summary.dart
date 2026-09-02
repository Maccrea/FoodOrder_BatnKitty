import 'package:flutter/material.dart';

import '../../core/constants/theme.dart';
import '../../core/utils/formatters.dart';

class CashierOrderSummary extends StatelessWidget {
  final Map<String, dynamic>? selectedMenu;
  final int quantity;
  final double unitPrice;
  final double subtotalFood;
  final double finalDeliveryFee;
  final double rawDeliveryFee;
  final double grandTotal;
  final bool loyaltyActive;
  final VoidCallback onCreateOrder;

  const CashierOrderSummary({
    super.key,
    required this.selectedMenu,
    required this.quantity,
    required this.unitPrice,
    required this.subtotalFood,
    required this.finalDeliveryFee,
    required this.rawDeliveryFee,
    required this.grandTotal,
    required this.loyaltyActive,
    required this.onCreateOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: BatKittyTheme.hotPink,
                size: 18,
              ),
              SizedBox(width: 9),
              Text(
                'Order Summary',
                style: TextStyle(
                  color: BatKittyTheme.textMain,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          const Text(
            '#ORD-093 · New transaction',
            style: TextStyle(
              color: BatKittyTheme.textSubtle,
              fontSize: 9,
            ),
          ),

          const SizedBox(height: 20),

          if (selectedMenu != null)
            _itemCard(),

          const SizedBox(height: 20),

          _row(
            'Food subtotal',
            formatRupiah(subtotalFood),
          ),

          _row(
            'Delivery',
            formatRupiah(finalDeliveryFee),
          ),

          if (loyaltyActive)
            _row(
              'Loyalty discount',
              '- ${formatRupiah(rawDeliveryFee)}',
              color: Colors.greenAccent,
            ),

          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Divider(
              color: BatKittyTheme.borderSubtle,
            ),
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(
                  color: BatKittyTheme.textMain,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              Text(
                formatRupiah(grandTotal),
                style: const TextStyle(
                  color: BatKittyTheme.pinkGlow,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          if (loyaltyActive)
            Container(
              margin:
                  const EdgeInsets.only(bottom: 11),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.greenAccent
                    .withOpacity(.06),
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.greenAccent,
                    size: 14,
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Free delivery reward applied',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onCreateOrder,
              icon: const Icon(
                Icons.check_rounded,
                size: 16,
              ),
              label: const Text(
                'Create Order',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    BatKittyTheme.hotPink,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemCard() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: BatKittyTheme.hotPink
                  .withOpacity(.08),
              borderRadius:
                  BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: BatKittyTheme.hotPink,
              size: 17,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  selectedMenu!['name'],
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$quantity × ${formatRupiah(unitPrice)}',
                  style: const TextStyle(
                    color: BatKittyTheme.textMuted,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: BatKittyTheme.textMuted,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color:
                  color ?? BatKittyTheme.textMain,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}