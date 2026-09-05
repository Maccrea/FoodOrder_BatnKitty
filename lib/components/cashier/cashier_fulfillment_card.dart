import 'package:flutter/material.dart';

import '../../core/constants/theme.dart';
import '../../core/utils/formatters.dart';
import 'cashier_shared.dart';

class CashierFulfillmentCard extends StatelessWidget {
  final String deliveryType;
  final String destinationArea; 
  final bool hasClassToday; 
  final TextEditingController addressController;
  final double finalDeliveryFee;
  final bool loyaltyActive;

  final Function(String) onDeliveryChanged;
  final Function(String) onAreaChanged;
  final Function(bool?) onClassStatusChanged;

  const CashierFulfillmentCard({
    super.key,
    required this.deliveryType,
    required this.destinationArea,
    required this.hasClassToday,
    required this.addressController,
    required this.finalDeliveryFee,
    required this.loyaltyActive,
    required this.onDeliveryChanged,
    required this.onAreaChanged,
    required this.onClassStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CashierShared.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CashierShared.header(
            icon: Icons.local_shipping_outlined,
            title: 'Fulfillment',
            subtitle: 'Choose how the order will be received',
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _option(
                  icon: Icons.delivery_dining_rounded,
                  title: 'Delivery',
                  subtitle: 'Send to customer',
                  selected: deliveryType == 'delivery',
                  onTap: () => onDeliveryChanged('delivery'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _option(
                  icon: Icons.storefront_rounded,
                  title: 'Pickup',
                  subtitle: 'Customer collects',
                  selected: deliveryType == 'pickup',
                  onTap: () => onDeliveryChanged('pickup'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          CashierShared.label('DELIVERY DATE'),

          const SizedBox(height: 7),

          _staticField(
            '05 Jun 2026',
            Icons.calendar_today_outlined,
          ),

          if (deliveryType == 'delivery') ...[
            const SizedBox(height: 15),

            CashierShared.label('WILAYAH TUJUAN PENGIRIMAN'),

            const SizedBox(height: 7),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: BatKittyTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: BatKittyTheme.borderSubtle,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: destinationArea,
                  dropdownColor: BatKittyTheme.surfaceDark,
                  style: const TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 10.5,
                  ),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'Dekat (0-4 km)',
                      child: Text('Dekat 0-4 km (Wologito / Sekitar) - Rp 5.000'),
                    ),
                    DropdownMenuItem(
                      value: 'Semarang Barat / Binus / Madukoro',
                      child: Text('Semarang Barat / Binus / The Park / Madukoro - Rp 7.000'),
                    ),
                    DropdownMenuItem(
                      value: 'Arah Kota',
                      child: Text('Arah Kota / Pusat - Rp 10.000'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) onAreaChanged(val);
                  },
                ),
              ),
            ),

            if (destinationArea == 'Semarang Barat / Binus / Madukoro') ...[
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Hari ini ada jadwal kelas (Promo Ongkir jadi Rp 5.000)',
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: hasClassToday,
                activeColor: BatKittyTheme.hotPink,
                onChanged: onClassStatusChanged,
              ),
            ],

            const SizedBox(height: 15),

            CashierShared.label('DELIVERY ADDRESS'),

            const SizedBox(height: 7),

            CashierShared.textField(
              controller: addressController,
              hint: 'Enter customer address / detail patokan',
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Calculated delivery fee',
                  style: TextStyle(
                    color: BatKittyTheme.textMuted,
                    fontSize: 9.5,
                  ),
                ),
                Text(
                  formatRupiah(finalDeliveryFee),
                  style: TextStyle(
                    color: loyaltyActive || finalDeliveryFee == 0
                        ? Colors.greenAccent
                        : BatKittyTheme.pinkGlow,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _option({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? BatKittyTheme.hotPink.withOpacity(.08)
              : BatKittyTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? BatKittyTheme.hotPink
                : BatKittyTheme.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected
                  ? BatKittyTheme.hotPink
                  : BatKittyTheme.textMuted,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: BatKittyTheme.textMain,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: BatKittyTheme.textSubtle,
                      fontSize: 8.5,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: BatKittyTheme.hotPink,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _staticField(
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: BatKittyTheme.textMuted,
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(
              color: BatKittyTheme.textMain,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}