import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';
import '../../data/local/app_seed.dart';
import '../../data/model/user_model.dart';
import 'admin/admin_shell_page.dart';
import 'customer/customer_catalog_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? errorMessage;

  void _handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Email dan password tidak boleh kosong!');
      return;
    }

    final rawUsers = (appSeed['users'] as List).cast<Map<String, dynamic>>();
    final matched = rawUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (matched.isEmpty) {
      setState(() => errorMessage = 'Kombinasi email atau password salah!');
      return;
    }

    final user = User.fromMap(matched);

    if (user.isAdmin || user.isStaffDapur) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminShellPage()),
      );
    } else if (user.isCustomer) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CustomerCatalogPage(user: matched)),
      );
    }
  }

  void _quickLogin(int roleId) {
    final rawUsers = (appSeed['users'] as List).cast<Map<String, dynamic>>();
    final target = rawUsers.firstWhere((u) => u['role_id'] == roleId);
    setState(() {
      emailController.text = target['email'];
      passwordController.text = target['password'];
      errorMessage = null;
    });
    _handleLogin();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    BatKittyTheme.hotPink.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1080, minHeight: 620),
                decoration: BoxDecoration(
                  color: const Color(0xFF11141D),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF22283A)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [BatKittyTheme.hotPink, BatKittyTheme.pinkMuted],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text("🦇", style: TextStyle(fontSize: 16)),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "BATKITTY OS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Masuk untuk kelola operasional katering atau buat pesanan PO.",
                              style: TextStyle(color: Color(0xFF8E95A9), fontSize: 12.5),
                            ),
                            const SizedBox(height: 28),

                            if (errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, color: Colors.redAccent, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        errorMessage!,
                                        style: const TextStyle(color: Colors.redAccent, fontSize: 11.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                            ],

                            const Text(
                              "EMAIL ADDRESS",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: "admin@batkitty.com",
                                hintStyle: const TextStyle(color: Color(0xFF4B5563), fontSize: 13),
                                prefixIcon: const Icon(Icons.alternate_email_rounded, color: Color(0xFF6B7280), size: 18),
                                filled: true,
                                fillColor: const Color(0xFF171B26),
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF262D40)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: BatKittyTheme.hotPink, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            const Text(
                              "PASSWORD",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                hintStyle: const TextStyle(color: Color(0xFF4B5563), fontSize: 13),
                                prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF6B7280), size: 18),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: const Color(0xFF6B7280),
                                    size: 18,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF171B26),
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF262D40)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: BatKittyTheme.hotPink, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: BatKittyTheme.hotPink,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text(
                                  "Sign In to Portal",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            const Row(
                              children: [
                                Expanded(child: Divider(color: Color(0xFF262D40))),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "DEV QUICK SWITCH",
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(color: Color(0xFF262D40))),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(child: _buildRoleButton("Admin", Icons.admin_panel_settings_outlined, () => _quickLogin(1))),
                                const SizedBox(width: 8),
                                Expanded(child: _buildRoleButton("Dapur", Icons.outdoor_grill_outlined, () => _quickLogin(2))),
                                const SizedBox(width: 8),
                                Expanded(child: _buildRoleButton("Customer", Icons.person_outline_rounded, () => _quickLogin(3))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (isDesktop)
                      Expanded(
                        flex: 6,
                        child: Container(
                          height: 620,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF161B28), Color(0xFF0F121C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xFF262D42)),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 40,
                                right: 40,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF20273A),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFF333E59)),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(radius: 4, backgroundColor: Colors.greenAccent),
                                      SizedBox(width: 8),
                                      Text(
                                        "Kitchen Ready // Semarang Hub",
                                        style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(48),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: BatKittyTheme.hotPink.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        "CATERING & DIET SYSTEM",
                                        style: TextStyle(
                                          color: BatKittyTheme.hotPink,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    const Text(
                                      "Pesan PO Sehat &\nMenu Harian.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        height: 1.15,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      "Platform katering harian BatKitty. Bikin pesanan PO mudah untuk 1–2 hari ke depan, pantau slot kuota dapur, dan kelola menu sehat dalam satu pintu.",
                                      style: TextStyle(color: Color(0xFF8E95A9), fontSize: 13, height: 1.5),
                                    ),
                                    const SizedBox(height: 32),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        _buildFeatureBadge(Icons.calendar_month_outlined, "PO Maks. H+2 Hari"),
                                        _buildFeatureBadge(Icons.approval_outlined, "Approval 1x24 Jam"),
                                        _buildFeatureBadge(Icons.cancel_outlined, "Batal Maks. H-4 Jam"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF171B26),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF262D40)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: BatKittyTheme.hotPink),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2233),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2C3650)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.pinkAccent),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}