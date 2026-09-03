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
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController(text: 'Jl. Prof. Sudharto No.12, Tembalang');

  bool isCustomerFound = false;
  bool isNewCustomer = false;
  int foundCustomerId = 0;
  String customerName = '';
  int pastCompletedOrders = 0;

  String deliveryType = 'delivery';
  double distanceKm = 7.5;

  late List<Map<String, dynamic>> masterMenus;
  Map<String, dynamic>? selectedMenu;

  bool isCustom = false;
  int quantity = 1;

  final TextEditingController manualPriceController = TextEditingController(text: '20000');
  final TextEditingController durationDaysController = TextEditingController(text: '1');
  final TextEditingController mealsPerDayController = TextEditingController(text: '1');
  final TextEditingController customNotesController = TextEditingController();

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
    nameController.dispose();
    addressController.dispose();
    manualPriceController.dispose();
    durationDaysController.dispose();
    mealsPerDayController.dispose();
    customNotesController.dispose();
    super.dispose();
  }

  void onPhoneChanged(String value) {
    final customers = (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final matchedCustomer = customers.firstWhere(
      (c) => c['phone'] == value.trim(),
      orElse: () => {},
    );

    setState(() {
      if (matchedCustomer.isNotEmpty) {
        isCustomerFound = true;
        isNewCustomer = false;
        foundCustomerId = matchedCustomer['id'];
        customerName = matchedCustomer['name'];
        
        final orders = (matchedCustomer['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        pastCompletedOrders = orders.length;
      } else if (value.trim().length >= 10) {
        isCustomerFound = false;
        isNewCustomer = true;
        foundCustomerId = 0;
        customerName = '';
        pastCompletedOrders = 0;
      } else {
        isCustomerFound = false;
        isNewCustomer = false;
        foundCustomerId = 0;
        customerName = '';
        pastCompletedOrders = 0;
      }
    });
  }

  double get rawDeliveryFee {
    if (deliveryType == 'pickup' || distanceKm <= 0) return 0;
    return 5000;
  }

  bool get loyaltyActive => pastCompletedOrders >= 3;

  double get finalDeliveryFee {
    if (deliveryType == 'pickup' || loyaltyActive) return 0;
    return rawDeliveryFee;
  }

  double get unitPrice {
    if (isCustom) {
      return double.tryParse(manualPriceController.text) ?? 0;
    }
    return (selectedMenu?['base_price'] as num?)?.toDouble() ?? 0;
  }

  double get subtotalFood => unitPrice * quantity;
  double get grandTotal => subtotalFood + finalDeliveryFee;

  void _createOrder() {
    final customers = (appSeed['customers'] as List);

    Map<String, dynamic>? targetCustomer;

    if (!isCustomerFound && isNewCustomer) {
      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nomor HP dan Nama Pelanggan wajib diisi!'), backgroundColor: Colors.red),
        );
        return;
      }
      int newCustId = customers.length + 1;
      targetCustomer = {
        'id': newCustId,
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
        'orders': [],
      };
      customers.add(targetCustomer);
    } else if (isCustomerFound) {
      targetCustomer = customers.firstWhere((c) => c['id'] == foundCustomerId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nomor WhatsApp pelanggan terlebih dahulu!'), backgroundColor: Colors.red),
      );
      return;
    }

    int allOrdersCount = 0;
    for (var c in customers) {
      allOrdersCount += ((c['orders'] as List?)?.length ?? 0);
    }
    int newOrderId = allOrdersCount + 1;
    String todayStr = DateTime.now().toIso8601String().substring(0, 10);

    final custOrders = (targetCustomer!['orders'] as List);
    custOrders.add({
      'id': newOrderId,
      'tanggal_order': todayStr,
      'tanggal_pengambilan': todayStr,
      'total_price': subtotalFood.toInt(),
      'delivery_fee': finalDeliveryFee.toInt(),
      'delivery_type': deliveryType == 'delivery' ? 'Delivery' : 'Pickup',
      'delivery_address': deliveryType == 'delivery' ? addressController.text : null,
      'status_bayar': 'Lunas',
      'status_masak': 'Proses',
      'items': [
        {
          'menu_name': selectedMenu?['name'] ?? 'Custom Menu',
          'quantity': quantity,
          'unit_price': unitPrice.toInt(),
          'custom_notes': customNotesController.text.isEmpty ? null : customNotesController.text,
        }
      ],
      'review': null,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order #ORD-09$newOrderId berhasil dibuat dan tercatat di Financial Ledger!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    phoneController.clear();
    nameController.clear();
    setState(() {
      isCustomerFound = false;
      isNewCustomer = false;
      foundCustomerId = 0;
      customerName = '';
      pastCompletedOrders = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Order', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 21, fontWeight: FontWeight.w900)),
                  SizedBox(height: 4),
                  Text('Create and process a new customer order.', style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 10.5)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                decoration: BoxDecoration(color: BatKittyTheme.surfaceDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: BatKittyTheme.borderSubtle)),
                child: const Row(
                  children: [
                    Icon(Icons.receipt_long_rounded, size: 15, color: BatKittyTheme.textMuted),
                    SizedBox(width: 8),
                    Text('POS Terminal', style: TextStyle(color: BatKittyTheme.textMain, fontSize: 10, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
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
                      nameController: nameController,
                      isCustomerFound: isCustomerFound,
                      isNewCustomer: isNewCustomer,
                      customerName: customerName,
                      pastCompletedOrders: pastCompletedOrders,
                      loyaltyActive: loyaltyActive,
                      onPhoneChanged: onPhoneChanged,
                    ),
                    const SizedBox(height: 16),
                    CashierFulfillmentCard(
                      deliveryType: deliveryType,
                      distanceKm: distanceKm,
                      addressController: addressController,
                      finalDeliveryFee: finalDeliveryFee,
                      loyaltyActive: loyaltyActive,
                      onDeliveryChanged: (value) => setState(() => deliveryType = value),
                      onDistanceChanged: (value) => setState(() => distanceKm = value),
                    ),
                    const SizedBox(height: 16),
                    CashierMenuCard(
                      masterMenus: masterMenus,
                      selectedMenu: selectedMenu,
                      isCustom: isCustom,
                      quantity: quantity,
                      manualPriceController: manualPriceController,
                      durationDaysController: durationDaysController,
                      mealsPerDayController: mealsPerDayController,
                      customNotesController: customNotesController,
                      unitPrice: unitPrice,
                      onMenuChanged: (value) => setState(() {
                        selectedMenu = value;
                        isCustom = value?['is_custom'] ?? false;
                      }),
                      onQuantityChanged: (value) => setState(() => quantity = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 360,
                child: CashierOrderSummary(
                  selectedMenu: selectedMenu,
                  quantity: quantity,
                  unitPrice: unitPrice,
                  subtotalFood: subtotalFood,
                  finalDeliveryFee: finalDeliveryFee,
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
}