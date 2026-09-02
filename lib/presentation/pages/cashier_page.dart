import 'package:flutter/material.dart';

import '../../core/constants/theme.dart';

import '../../components/cashier/cashier_customer_card.dart';
import '../../components/cashier/cashier_fulfillment_card.dart';
import '../../components/cashier/cashier_menu_card.dart';
import '../../components/cashier/cashier_order_summary.dart';
import '../../data/local/app_seed.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
 
  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController(
    text: 'Jl. Prof. Sudharto No.12, Tembalang',
  );

  bool isCustomerFound = false;
  String customerName = '';
  int pastCompletedOrders = 0;

  String deliveryType = 'delivery';
  double distanceKm = 7.5;


  late final List<Map<String, dynamic>> masterMenus;

  Map<String, dynamic>? selectedMenu;

  bool isCustom = false;
  int quantity = 1;

  final TextEditingController manualPriceController =
      TextEditingController(text: '20000');

  final TextEditingController durationDaysController =
      TextEditingController(text: '1');

  final TextEditingController mealsPerDayController =
      TextEditingController(text: '1');

  final TextEditingController customNotesController =
      TextEditingController();



  @override
  void initState() {
    super.initState();
    masterMenus = (appSeed['menus'] as List)
        .map((menu) => {
              ...Map<String, dynamic>.from(menu),
              'is_custom': menu['category'] == 'custom' || menu['category'] == 'diet_package',
            })
        .toList()
        .cast<Map<String, dynamic>>();
    selectedMenu = masterMenus.first;
  }

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    manualPriceController.dispose();
    durationDaysController.dispose();
    mealsPerDayController.dispose();
    customNotesController.dispose();

    super.dispose();
  }

  double get rawDeliveryFee {
    if (deliveryType == 'pickup' || distanceKm <= 0) {
      return 0;
    }

    const double costPerKmPP = 3333.33;

    final total = distanceKm * costPerKmPP;

    return (total / 500).ceil() * 500;
  }

  bool get loyaltyActive {
    return pastCompletedOrders >= 4;
  }

  double get finalDeliveryFee {
    if (deliveryType == 'pickup') {
      return 0;
    }

    if (loyaltyActive) {
      return 0;
    }

    return rawDeliveryFee;
  }

  double get unitPrice {
    if (isCustom) {
      return double.tryParse(
            manualPriceController.text,
          ) ??
          0;
    }

    return selectedMenu?['base_price']?.toDouble() ?? 0;
  }

  int get durationDays {
    return int.tryParse(
          durationDaysController.text,
        ) ??
        1;
  }

  int get mealsPerDay {
    return int.tryParse(
          mealsPerDayController.text,
        ) ??
        1;
  }

  double get subtotalFood {
    return unitPrice *
        durationDays *
        mealsPerDay *
        quantity;
  }

  double get grandTotal {
    return subtotalFood + finalDeliveryFee;
  }


  void onPhoneChanged(String value) {
    setState(() {
      if (value.length >= 10) {
        isCustomerFound = true;
        customerName = 'Budi Santoso';
        pastCompletedOrders = 4;
      } else {
        isCustomerFound = false;
        customerName = '';
        pastCompletedOrders = 0;
      }
    });
  }


  @override
  @override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),

        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  CashierCustomerCard(
                        phoneController: phoneController,
                        isCustomerFound: isCustomerFound,
                        customerName: customerName,
                        pastCompletedOrders:
                            pastCompletedOrders,
                        loyaltyActive: loyaltyActive,
                        onPhoneChanged: onPhoneChanged,
                      ),

                  const SizedBox(height: 16),

                  CashierFulfillmentCard(
                        deliveryType: deliveryType,
                        distanceKm: distanceKm,
                        addressController: addressController,
                        finalDeliveryFee:
                            finalDeliveryFee,
                        loyaltyActive: loyaltyActive,
                        onDeliveryChanged: (value) {
                          setState(() {
                            deliveryType = value;
                          });
                        },
                        onDistanceChanged: (value) {
                          setState(() {
                            distanceKm = value;
                          });
                        },
                      ),


                  const SizedBox(height: 16),

                  CashierMenuCard(
                        masterMenus: masterMenus,
                        selectedMenu: selectedMenu,
                        isCustom: isCustom,
                        quantity: quantity,
                        manualPriceController:
                            manualPriceController,
                        durationDaysController:
                            durationDaysController,
                        mealsPerDayController:
                            mealsPerDayController,
                        customNotesController:
                            customNotesController,
                        unitPrice: unitPrice,
                        onMenuChanged: (value) {
                          setState(() {
                            selectedMenu = value;
                            isCustom =
                                value?['is_custom'] ?? false;
                          });
                        },
                        onQuantityChanged: (value) {
                          setState(() {
                            quantity = value;
                          });
                        },
                      ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            SizedBox(
              width: 360,
              child:CashierOrderSummary(
                    selectedMenu: selectedMenu,
                    quantity: quantity,
                    unitPrice: unitPrice,
                    subtotalFood: subtotalFood,
                    finalDeliveryFee:
                        finalDeliveryFee,
                    rawDeliveryFee: rawDeliveryFee,
                    grandTotal: grandTotal,
                    loyaltyActive: loyaltyActive,
                    onCreateOrder: _createOrder,
                  ),
            ),
          ],
        ),
      ],
    ),
  );
}
  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Order',
                style: TextStyle(
                  color: BatKittyTheme.textMain,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Create and process a new customer order.',
                style: TextStyle(
                  color: BatKittyTheme.textMuted,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: BatKittyTheme.surfaceDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: BatKittyTheme.borderSubtle,
            ),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                size: 15,
                color: BatKittyTheme.textMuted,
              ),
              SizedBox(width: 8),
              Text(
                '#ORD-093',
                style: TextStyle(
                  color: BatKittyTheme.textMain,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _createOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Order #ORD-093 created successfully',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

  }
}