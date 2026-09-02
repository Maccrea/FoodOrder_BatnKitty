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
          // 1. HIGH-END LUXURY SIDEBAR
          Container(
            width: 270,
            decoration: const BoxDecoration(
              color: BatKittyTheme.surfaceDark,
              border: Border(right: BorderSide(color: BatKittyTheme.borderSubtle, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Header with Gradient Aura
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
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
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text("🦇", style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BATKITTY",
                            style: TextStyle(
                              color: BatKittyTheme.textMain,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "ENTERPRISE OS",
                            style: TextStyle(
                              color: BatKittyTheme.textSubtle,
                              fontSize: 8,
                              letterSpacing: 2.2,
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
                const SizedBox(height: 16),

                // Navigation Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 8),
                        child: Text(
                          "CORE MODULES",
                          style: TextStyle(
                            color: BatKittyTheme.textSubtle,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      _buildNavItem(context, 'dashboard', 'Home / Dashboard', Icons.grid_view_rounded),
                      _buildNavItem(context, 'cashier', 'Kasir & Pesanan', Icons.point_of_sale_rounded),
                      _buildNavItem(context, 'routes', 'Manifes Kurir', Icons.local_shipping_outlined),
                      _buildNavItem(context, 'finance', 'Keuangan & Omzet', Icons.account_balance_wallet_outlined),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Minimalist Live Sync Badge
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: BatKittyTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BatKittyTheme.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
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
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. MAIN CONTENT AREA
          Expanded(
            child: Column(
              children: [
                // Top Navigation Bar
                Container(
                  height: 76,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: const BoxDecoration(
                    color: BatKittyTheme.bgDark,
                    border: Border(bottom: BorderSide(color: BatKittyTheme.borderSubtle, width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: BatKittyTheme.hotPink.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: BatKittyTheme.hotPink.withOpacity(0.2)),
                            ),
                            child: const Text(
                              "🦇🎀 SECURE DESKTOP KERNEL",
                              style: TextStyle(
                                color: BatKittyTheme.pinkGlow,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Text(
                          //   "// MODULE : ${activePage.toUpperCase()}",
                          //   style: const TextStyle(
                          //     color: BatKittyTheme.textMuted,
                          //     fontSize: 11,
                          //     fontWeight: FontWeight.w700,
                          //     letterSpacing: 1.2,
                          //   ),
                          // ),
                        ],
                      ),
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

                // Workspace Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: child,
                  ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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