import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';

class MainLayout extends StatelessWidget {
  final String activePage;
  final Function(String) onNavigate;
  final Widget child;

  const MainLayout({
    super.key,
    required this.activePage,
    required this.onNavigate,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BatKittyTheme.bgDark,
      body: Row(
        children: [
          // Sidebar Navigasi Kiri
          Container(
            width: 265,
            decoration: const BoxDecoration(
              color: BatKittyTheme.surfaceDark,
              border: Border(right: BorderSide(color: BatKittyTheme.borderSubtle, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo & Branding Brand
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [BatKittyTheme.hotPink, BatKittyTheme.pinkMuted],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: BatKittyTheme.hotPink.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text("🦇", style: TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BATKITTY",
                            style: TextStyle(
                              color: BatKittyTheme.textMain,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 1.1,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "ENTERPRISE OS",
                            style: TextStyle(
                              color: BatKittyTheme.textSubtle,
                              fontSize: 7.5,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: BatKittyTheme.borderSubtle, height: 1),
                ),
                const SizedBox(height: 20),

                // Daftar Menu Navigasi (Core Modules)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 10),
                        child: Text(
                          "CORE MODULES",
                          style: TextStyle(
                            color: BatKittyTheme.textSubtle,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      _buildNavItem(context, 'dashboard', 'Home / Dashboard', Icons.grid_view_rounded),
                      _buildNavItem(context, 'menu', 'Menu Management', Icons.restaurant_menu_rounded),
                      _buildNavItem(context, 'cashier', 'Kasir & Pesanan', Icons.point_of_sale_rounded),
                      _buildNavItem(context, 'routes', 'Manifes Kurir', Icons.local_shipping_outlined),
                      _buildNavItem(context, 'finance', 'Keuangan & Omzet', Icons.account_balance_wallet_outlined),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Indikator Status Node di Bagian Bawah Sidebar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: BatKittyTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BatKittyTheme.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.greenAccent, blurRadius: 6),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Node Synchronized",
                          style: TextStyle(
                            color: BatKittyTheme.textMuted,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Area Konten Utama Kanan
          Expanded(
            child: Column(
              children: [
                // Top App Bar / Header Kanan
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: const BoxDecoration(
                    color: BatKittyTheme.bgDark,
                    border: Border(bottom: BorderSide(color: BatKittyTheme.borderSubtle, width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: BatKittyTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: BatKittyTheme.borderSubtle),
                            ),
                            child: const Icon(Icons.notifications_none_rounded, color: BatKittyTheme.textMuted, size: 18),
                          ),
                          const SizedBox(width: 14),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: BatKittyTheme.hotPink.withOpacity(0.5), width: 1.5),
                            ),
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: BatKittyTheme.surfaceElevated,
                              child: Text(
                                "AD",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: BatKittyTheme.textMain,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Body Konten Halaman Aktif
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String id, String label, IconData icon) {
    bool isActive = activePage == id;
    return InkWell(
      onTap: () => onNavigate(id),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? BatKittyTheme.hotPink.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? BatKittyTheme.hotPink.withOpacity(0.35) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? BatKittyTheme.hotPink : BatKittyTheme.textSubtle,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? BatKittyTheme.textMain : BatKittyTheme.textMuted,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}