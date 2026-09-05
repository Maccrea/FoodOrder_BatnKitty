import 'package:batnkitty_food/presentation/pages/admin/admin_shell_page.dart';
import 'package:batnkitty_food/presentation/pages/customer/customer_catalog_page.dart';
import 'package:flutter/material.dart';
import 'presentation/pages/login_page.dart';

void main() {
  runApp(const BatKittyCateringApp());
}

class BatKittyCateringApp extends StatelessWidget {
  const BatKittyCateringApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bat-Kitty Catering Enterprise OS',
      theme: ThemeData.dark(),
      home:  AdminShellPage()
    );
  }
}