import 'package:batnkitty_food/core/network/api_client.dart';
import 'package:batnkitty_food/data/services/order_api_services.dart';
import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/admin/admin_bloc.dart';
import '../../layouts/main_layouts.dart';
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
    return BlocProvider(
      create: (context) => AdminBloc(
    orderApiService: OrderApiService(), 
  )..add(LoadAdminDataEvent()),
      child: MainLayout(
        activePage: activePage,
        onNavigate: (page) => setState(() => activePage = page),
        child: _buildCurrentPage(),
      ),
    );
  }

Widget _buildCurrentPage() {
  switch (activePage) {
    case 'dashboard':
      return DashboardPage(
        onNavigate: (targetPage) => setState(() => activePage = targetPage),
      );
    case 'cashier':
      return const CashierPage();
    case 'orders':
      return const AdminOrderPage();
    case 'menu':
      return const MenuManagementPage();
    case 'finance':
      return const FinancialPage();
    default:
      return DashboardPage(
        onNavigate: (targetPage) => setState(() => activePage = targetPage),
      );
  }
}
}