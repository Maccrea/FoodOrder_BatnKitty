import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';

class CashierCustomerCard extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController nameController;  
  final bool isCustomerFound;
  final bool isNewCustomer; 
  final String customerName;
  final int pastCompletedOrders;
  final bool loyaltyActive;
  final ValueChanged<String> onPhoneChanged;

  const CashierCustomerCard({
    super.key,
    required this.phoneController,
    required this.nameController,
    required this.isCustomerFound,
    required this.isNewCustomer,
    required this.customerName,
    required this.pastCompletedOrders,
    required this.loyaltyActive,
    required this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
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
              Icon(Icons.person_outline_rounded, color: BatKittyTheme.hotPink, size: 18),
              SizedBox(width: 10),
              Text(
                'Customer Identification',
                style: TextStyle(color: BatKittyTheme.textMain, fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: phoneController,
            onChanged: onPhoneChanged,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              labelText: 'Nomor WhatsApp (Cari / Input Baru)',
              labelStyle: const TextStyle(color: BatKittyTheme.textSubtle, fontSize: 11),
              filled: true,
              fillColor: BatKittyTheme.surfaceElevated,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              prefixIcon: const Icon(Icons.phone_rounded, color: BatKittyTheme.textSubtle, size: 16),
            ),
          ),
          
          if (isNewCustomer) ...[
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              style: const TextStyle(color: BatKittyTheme.textMain, fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Pelanggan Baru - Masukkan Nama Lengkap',
                labelStyle: const TextStyle(color: BatKittyTheme.hotPink, fontSize: 11, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: BatKittyTheme.surfaceElevated,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: BatKittyTheme.hotPink)),
                prefixIcon: const Icon(Icons.person_add_rounded, color: BatKittyTheme.hotPink, size: 16),
              ),
            ),
          ],

          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCustomerFound 
                    ? 'Dikenal: $customerName ($pastCompletedOrders Pesanan Selesai)' 
                    : (isNewCustomer ? 'Status: Pelanggan Baru (Akan didaftarkan otomatis)' : 'Silakan masukkan min. 10 digit nomor WhatsApp'),
                style: TextStyle(
                  color: isCustomerFound ? Colors.greenAccent : (isNewCustomer ? BatKittyTheme.hotPink : BatKittyTheme.textSubtle),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (loyaltyActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.amberAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: const Text('Loyalty Active (Free Ongkir!)', style: TextStyle(color: Colors.amberAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}