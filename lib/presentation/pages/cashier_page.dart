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
  final TextEditingController addressController = TextEditingController(
    text: 'Jl. Prof. Sudharto No.12, Tembalang',
  );

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

  final TextEditingController manualPriceController = TextEditingController(
    text: '20000',
  );
  final TextEditingController durationDaysController = TextEditingController(
    text: '1',
  );
  final TextEditingController mealsPerDayController = TextEditingController(
    text: '1',
  );
  final TextEditingController customNotesController = TextEditingController();

  // --- VARIABLE RULES & JADWAL PENGAMBILAN ---
  DateTime? selectedTanggalPengambilan;
  final int maxDailyQuota = 10;
  bool isCloseOrderManual = false;

  @override
  void initState() {
    super.initState();
    masterMenus = (appSeed['menus'] as List)
        .map(
          (menu) => {
            ...Map<String, dynamic>.from(menu),
            'is_custom':
                menu['category'] == 'custom' ||
                menu['category'] == 'diet_package',
          },
        )
        .toList()
        .cast<Map<String, dynamic>>();
    selectedMenu = masterMenus.first;
    addressController.addListener(() {
      _autoDetectArea(addressController.text);
    });
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

  // --- LOGIKA VALIDASI WAKTU 4 JAM & OPERASIONAL ---
  bool isTimeValid(DateTime targetTime) {
    final minimumAllowed = DateTime.now().add(const Duration(hours: 4));
    return targetTime.isAfter(minimumAllowed);
  }

  Future<void> _pickPickupDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final selectedFull = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (isTimeValid(selectedFull)) {
      setState(() {
        selectedTanggalPengambilan = selectedFull;
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jadwal pengambilan/antar minimal 4 jam dari waktu saat ini!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void onPhoneChanged(String value) {
    final customers =
        (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];

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

        final orders =
            (matchedCustomer['orders'] as List?)
                ?.cast<Map<String, dynamic>>() ??
            [];
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

  void _autoDetectArea(String addressText) {
    String lower = addressText.toLowerCase();

    setState(() {
      if (lower.contains('binus') || lower.contains('madukoro') || lower.contains('the park') || lower.contains('puri') || lower.contains('krapyak')) {
        destinationArea = 'Semarang Barat / Binus / Madukoro';
      } else if (lower.contains('simpang lima') || lower.contains('tugu muda') || lower.contains('pemuda') || lower.contains('gajah mada') || lower.contains('kota')) {
        destinationArea = 'Arah Kota';
      } else {
        destinationArea = 'Dekat (0-4 km)';
      }
    });
  }

  double get rawDeliveryFee {
    if (deliveryType == 'pickup' || distanceKm <= 0) return 0;
    return 5000;
  }

  bool get loyaltyActive => pastCompletedOrders >= 3;

  String destinationArea = 'Dekat (0-4 km)';
  bool hasClassToday = true;

  double get finalDeliveryFee {
    if (deliveryType == 'pickup' || loyaltyActive) return 0;
    if (subtotalFood >= 50000) return 0; 

    if (destinationArea == 'Dekat (0-4 km)') {
      return 5000;
    } else if (destinationArea == 'Semarang Barat / Binus / Madukoro') {
      return hasClassToday ? 5000 : 7000;
    } else if (destinationArea == 'Arah Kota') {
      return 10000;
    }
    return 5000;
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
    debugPrint('Tombol Create Order ditekan!');

    if (isCloseOrderManual) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operasional sedang ditutup (Close Order).'), backgroundColor: Colors.red),
      );
      return;
    }

    final rawCustomers = (appSeed['customers'] as List?) ?? [];
    List<Map<String, dynamic>> customers = rawCustomers.map((cust) {
      final cMap = Map<String, dynamic>.from(cust);
      final rawOrders = (cMap['orders'] as List?) ?? [];
      cMap['orders'] = rawOrders.map((ord) => Map<String, dynamic>.from(ord)).toList();
      return cMap;
    }).toList();

    int allOrdersCount = 0;
    for (var c in customers) {
      allOrdersCount += ((c['orders'] as List?)?.length ?? 0);
    }

    // Validasi kuota 10 order
    if (allOrdersCount >= maxDailyQuota) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kuota harian sudah penuh (10 pesanan)!'), backgroundColor: Colors.red),
      );
      return;
    }

    // Validasi pemilihan jadwal
    if (selectedTanggalPengambilan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jadwal pengambilan/antar terlebih dahulu (min. 4 jam)!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, dynamic>? targetCustomer;

    if (!isCustomerFound && isNewCustomer) {
      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nomor HP dan Nama Pelanggan wajib diisi!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      int newCustId = customers.length + 1;
      
      final Map<String, dynamic> newCust = {
        'id': newCustId,
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
        'orders': <Map<String, dynamic>>[],
      };
      customers.add(newCust);
      targetCustomer = newCust;
    } else if (isCustomerFound) {
      targetCustomer = customers.firstWhere((c) => c['id'] == foundCustomerId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nomor WhatsApp pelanggan terlebih dahulu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int newOrderId = allOrdersCount + 1;
    String nowTimestamp = DateTime.now().toIso8601String();

    final custOrders = (targetCustomer!['orders'] as List<dynamic>).cast<Map<String, dynamic>>();
    
    final Map<String, dynamic> newOrder = {
      'id': newOrderId,
      'tanggal_order': nowTimestamp,
      'tanggal_pengambilan': selectedTanggalPengambilan!.toIso8601String(),
      'total_price': subtotalFood.toInt(), 
      'delivery_fee': finalDeliveryFee.toInt(),
      'delivery_type': deliveryType == 'delivery' ? 'Delivery' : 'Pickup',
      'delivery_address': deliveryType == 'delivery' ? addressController.text : null,
      'status_pesanan': 'waiting_approve', // Sesuai ERD
      'status_bayar': 'unpaid',            // Sesuai ERD
      'status_masak': 'Pending',           // Sesuai ERD
      'cancellation_reason': null,
      'items': <Map<String, dynamic>>[
        {
          'menu_name': selectedMenu?['name'] ?? 'Custom Menu',
          'quantity': quantity, 
          'unit_price': unitPrice.toInt(),
          'custom_notes': customNotesController.text.isEmpty ? null : customNotesController.text,
        },
      ],
      'review': null,
    };

    custOrders.add(newOrder);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: BatKittyTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: BatKittyTheme.borderSubtle),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.greenAccent,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pesanan Berhasil Dibuat! 🎉',
                style: TextStyle(
                  color: BatKittyTheme.textMain,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Order #ORD-09$newOrderId atas nama ${targetCustomer!['name']} berhasil masuk antrean dengan status waiting_approve.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: BatKittyTheme.textMuted,
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BatKittyTheme.hotPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Selesai & Lanjutkan',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    phoneController.clear();
    nameController.clear();
    customNotesController.clear();
    setState(() {
      selectedTanggalPengambilan = null;
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                decoration: BoxDecoration(
                  color: BatKittyTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: BatKittyTheme.borderSubtle),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.receipt_long_rounded, size: 15, color: BatKittyTheme.textMuted),
                    SizedBox(width: 8),
                    Text(
                      'POS Terminal',
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
                      destinationArea: destinationArea,
                      hasClassToday: hasClassToday,
                      addressController: addressController,
                      finalDeliveryFee: finalDeliveryFee,
                      loyaltyActive: loyaltyActive,
                      onDeliveryChanged: (value) => setState(() => deliveryType = value),
                      onAreaChanged: (value) => setState(() => destinationArea = value),
                      onClassStatusChanged: (value) => setState(() => hasClassToday = value ?? true),
                    ),
                    const SizedBox(height: 16),
                    // Widget Tambahan: Pemilih Jadwal Pengambilan (Aturan 4 Jam)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: BatKittyTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: BatKittyTheme.borderSubtle),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jadwal Pengambilan / Kirim',
                                style: TextStyle(
                                  color: BatKittyTheme.textMain,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedTanggalPengambilan == null
                                    ? 'Wajib dipilih (Min. 4 jam dari sekarang)'
                                    : selectedTanggalPengambilan.toString().substring(0, 16),
                                style: TextStyle(
                                  color: selectedTanggalPengambilan == null
                                      ? Colors.orangeAccent
                                      : Colors.greenAccent,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BatKittyTheme.surfaceHighlight,
                              foregroundColor: BatKittyTheme.textMain,
                            ),
                            onPressed: _pickPickupDateTime,
                            icon: const Icon(Icons.access_time_rounded, size: 16),
                            label: const Text('Pilih Jadwal', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
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