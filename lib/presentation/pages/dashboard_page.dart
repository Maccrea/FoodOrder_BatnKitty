import 'package:flutter/material.dart';
import '../../components/dashboard/dashboard_header.dart';
import '../../components/dashboard/dashboard_kpi.dart';
import '../../components/dashboard/recent_orders.dart';
import '../../components/dashboard/delivery_overview.dart';
import '../../components/dashboard/quick_actions.dart';
import '../../components/dashboard/system_status.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          const SizedBox(height: 24),
          const DashboardKpi(),
          const SizedBox(height: 24),
          
          // Bagian Recent Orders & Delivery Overview
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: RecentOrders()),
              SizedBox(width: 20),
              Expanded(flex: 2, child: DeliveryOverview()),
            ],
          ),
          const SizedBox(height: 20),
          
          // Bagian Quick Actions & System Status
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: QuickActions()),
              SizedBox(width: 20),
              Expanded(child: SystemStatus()),
            ],
          ),
        ],
      ),
    );
  }
}