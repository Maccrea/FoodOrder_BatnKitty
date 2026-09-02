import 'package:flutter/material.dart';

import '../../core/constants/theme.dart';
import 'cashier_shared.dart';

class CashierCustomerCard extends StatelessWidget {
  final TextEditingController phoneController;
  final bool isCustomerFound;
  final String customerName;
  final int pastCompletedOrders;
  final bool loyaltyActive;
  final Function(String) onPhoneChanged;

  const CashierCustomerCard({
    super.key,
    required this.phoneController,
    required this.isCustomerFound,
    required this.customerName,
    required this.pastCompletedOrders,
    required this.loyaltyActive,
    required this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CashierShared.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CashierShared.header(
            icon: Icons.person_outline_rounded,
            title: 'Customer',
            subtitle: 'Identify customer account',
          ),

          const SizedBox(height: 18),

          CashierShared.label('PHONE NUMBER'),

          const SizedBox(height: 7),

          CashierShared.textField(
            controller: phoneController,
            hint: '081234567890',
            icon: Icons.phone_outlined,
            onChanged: onPhoneChanged,
          ),

          if (isCustomerFound) ...[
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BatKittyTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.greenAccent.withOpacity(.18),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: Colors.greenAccent,
                    size: 18,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            color:
                                BatKittyTheme.textMain,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$pastCompletedOrders completed orders',
                          style: const TextStyle(
                            color:
                                BatKittyTheme.textMuted,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (loyaltyActive)
                    CashierShared.badge(
                      'FREE DELIVERY',
                      BatKittyTheme.hotPink,
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}