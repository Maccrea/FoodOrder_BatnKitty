import 'package:flutter/material.dart';
import '../layouts/main_layouts.dart';
import 'dashboard_page.dart';
import 'cashier_page.dart';
import 'admin_order_page.dart';
import 'financial_page.dart';
import 'delivery_page.dart';
import 'menu_management_page.dart';

class AdminShellPage extends StatefulWidget {
  const AdminShellPage({super.key});

  @override
  State<AdminShellPage> createState() => _AdminShellPageState();
}

class _AdminShellPageState extends State<AdminShellPage> {
  String activePage = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      activePage: activePage,
      onNavigate: (page) => setState(() => activePage = page),
      child: _buildCurrentPage(),
    );
  }

  Widget _buildCurrentPage() {
    switch (activePage) {
      case 'dashboard':
        return const DashboardPage();
      case 'cashier':
        return const CashierPage();
      case 'orders':
        return const AdminOrderPage();
      case 'routes':
        return const DeliveryPage();
      case 'menu':
        return const MenuManagementPage();
      case 'finance':
        return const FinancialPage();
      default:
        return const DashboardPage();
    }
  }
}