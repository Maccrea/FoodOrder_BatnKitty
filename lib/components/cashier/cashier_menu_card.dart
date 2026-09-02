import 'package:flutter/material.dart';

import '../../core/constants/theme.dart';
import '../../core/utils/formatters.dart';
import 'cashier_shared.dart';

class CashierMenuCard extends StatelessWidget {
  final List<Map<String, dynamic>> masterMenus;
  final Map<String, dynamic>? selectedMenu;
  final bool isCustom;
  final int quantity;

  final TextEditingController manualPriceController;
  final TextEditingController durationDaysController;
  final TextEditingController mealsPerDayController;
  final TextEditingController customNotesController;

  final double unitPrice;

  final Function(Map<String, dynamic>?) onMenuChanged;
  final Function(int) onQuantityChanged;

  const CashierMenuCard({
    super.key,
    required this.masterMenus,
    required this.selectedMenu,
    required this.isCustom,
    required this.quantity,
    required this.manualPriceController,
    required this.durationDaysController,
    required this.mealsPerDayController,
    required this.customNotesController,
    required this.unitPrice,
    required this.onMenuChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CashierShared.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CashierShared.header(
            icon: Icons.restaurant_menu_rounded,
            title: 'Order Items',
            subtitle:
                'Select menu and configure quantity',
          ),

          const SizedBox(height: 18),

          CashierShared.label('MENU'),

          const SizedBox(height: 7),

          _menuDropdown(),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _quantity(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _price(),
              ),
            ],
          ),

          if (isCustom) ...[
            const SizedBox(height: 15),
            _customConfiguration(),
          ],
        ],
      ),
    );
  }

  Widget _menuDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
      ),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, dynamic>>(
          value: selectedMenu,
          isExpanded: true,
          dropdownColor:
              BatKittyTheme.surfaceElevated,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: BatKittyTheme.textMuted,
          ),
          items: masterMenus.map((menu) {
            final custom = menu['is_custom'] == true;

            return DropdownMenuItem<
                Map<String, dynamic>>(
              value: menu,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      menu['name'],
                      style: const TextStyle(
                        color: BatKittyTheme.textMain,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                  Text(
                    custom
                        ? 'Custom'
                        : formatRupiah(
                            menu['base_price'],
                          ),
                    style: TextStyle(
                      color: custom
                          ? BatKittyTheme.pinkGlow
                          : BatKittyTheme.textMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onMenuChanged,
        ),
      ),
    );
  }

  Widget _quantity() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
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
          CashierShared.label('QUANTITY'),
          const Spacer(),
          _quantityButton(
            Icons.remove_rounded,
            () {
              if (quantity > 1) {
                onQuantityChanged(quantity - 1);
              }
            },
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: const TextStyle(
                color: BatKittyTheme.textMain,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _quantityButton(
            Icons.add_rounded,
            () {
              onQuantityChanged(quantity + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: BatKittyTheme.surfaceDark,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          icon,
          size: 13,
          color: BatKittyTheme.textMuted,
        ),
      ),
    );
  }

  Widget _price() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          CashierShared.label('UNIT PRICE'),
          Text(
            formatRupiah(unitPrice),
            style: const TextStyle(
              color: BatKittyTheme.pinkGlow,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customConfiguration() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: BatKittyTheme.hotPink.withOpacity(.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: BatKittyTheme.hotPink.withOpacity(.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.tune_rounded,
                color: BatKittyTheme.pinkGlow,
                size: 15,
              ),
              SizedBox(width: 7),
              Text(
                'Custom configuration',
                style: TextStyle(
                  color: BatKittyTheme.pinkGlow,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              Expanded(
                child: _field(
                  'PRICE / UNIT',
                  manualPriceController,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _field(
                  'DAYS',
                  durationDaysController,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _field(
                  'MEALS / DAY',
                  mealsPerDayController,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          _field(
            'SPECIAL NOTES',
            customNotesController,
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CashierShared.label(label),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(
            color: BatKittyTheme.textMain,
            fontSize: 10,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: BatKittyTheme.surfaceElevated,
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 11,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: BatKittyTheme.borderSubtle,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: BatKittyTheme.borderSubtle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}