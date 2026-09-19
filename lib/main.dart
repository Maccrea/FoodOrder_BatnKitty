import 'package:batnkitty_food/core/constants/theme.dart';
import 'package:batnkitty_food/core/network/api_client.dart';
import 'package:batnkitty_food/data/services/order_api_services.dart';
import 'package:batnkitty_food/logic/admin/admin_bloc.dart';
import 'package:batnkitty_food/logic/customer/customer_catalog_bloc.dart';
import 'package:batnkitty_food/presentation/pages/admin/admin_shell_page.dart';
import 'package:batnkitty_food/presentation/pages/customer/customer_catalog_page.dart';
import 'package:batnkitty_food/presentation/pages/customer/customer_home_dashboard.dart';
import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminBloc>(
          create: (_) => AdminBloc(
  orderApiService: OrderApiService(),
),
        ),
        BlocProvider<CustomerCatalogBloc>(
          create: (_) => CustomerCatalogBloc()
            ..add(LoadCustomerCatalogEvent('')),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: BatKittyTheme.darkTheme,
        home: const CustomerHomeDashboard(),
      ),
    );
  }
}