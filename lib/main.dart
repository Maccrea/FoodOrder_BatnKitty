import 'package:flutter/material.dart';
import 'presentation/layouts/main_layouts.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/cashier_page.dart';
import 'presentation/pages/financial_page.dart';
import 'presentation/pages/delivery_page.dart'; // <-- Tambahkan import ini

void main() {
  runApp(const BatKittyCateringApp());
}

class BatKittyCateringApp extends StatefulWidget {
  const BatKittyCateringApp({super.key});

  @override
  State<BatKittyCateringApp> createState() => _BatKittyCateringAppState();
}

class _BatKittyCateringAppState extends State<BatKittyCateringApp> {
  String activePage = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bat-Kitty Catering CMS',
      theme: ThemeData.dark(),
      home: MainLayout(
        activePage: activePage,
        onNavigate: (page) => setState(() => activePage = page),
        child: _buildCurrentPage(),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (activePage) {
      case 'dashboard':
        return const DashboardPage();
      case 'cashier':
      case 'orders':
        return const CashierPage();
      case 'routes':
        return const DeliveryPage(); // <-- Hubungkan ke modul rute kurir
      case 'finance':
        return const FinancialPage();
      default:
        return Container(
          padding: const EdgeInsets.all(40),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF0F1117),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF222634)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("🚀", style: TextStyle(fontSize: 32)),
              const SizedBox(height: 12),
              Text(
                "MODULE // ${activePage.toUpperCase()}",
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Modul sistem manajemen katering sedang aktif.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
    }
  }
}