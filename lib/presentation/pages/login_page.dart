import 'package:batnkitty_food/core/network/api_client.dart';
import 'package:batnkitty_food/core/network/api_service.dart';
import 'package:batnkitty_food/data/model/customer_model.dart';
import 'package:flutter/material.dart';

import '../../core/constants/theme.dart';
import '../../data/local/app_seed.dart';
import '../../data/model/user_model.dart';
import 'admin/admin_shell_page.dart';
import 'customer/customer_catalog_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);

  Future<void> _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _errorMessage.value = 'Silakan isi email dan password.';
      return;
    }

    final rawUsers = (appSeed['users'] as List).cast<Map<String, dynamic>>();
    final matched = rawUsers.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (matched.isEmpty) {
      _errorMessage.value = 'Email atau password tidak sesuai.';
      return;
    }

    _errorMessage.value = null;
    final user = User.fromMap(matched);

    if (!context.mounted) return;

    if (user.isAdmin || user.isStaffDapur) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminShellPage()),
      );
    } else if (user.isCustomer) {
      try {
        final apiService = ApiService(ApiClient().dio);
        final request = CustomerRequest(
          name: matched['name'] ?? 'Pelanggan',
          phone: matched['phone'] ?? '0800000000',
        );

        final response = await apiService.registerCustomer(request);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : <String, dynamic>{};
          final customerData = responseData['data'] is Map<String, dynamic>
              ? responseData['data'] as Map<String, dynamic>
              : responseData;
          if (customerData['id'] != null) {
            matched['id'] = int.tryParse(customerData['id'].toString());
          }
        }
      } catch (e) {
        debugPrint('Gagal sinkronisasi data customer ke server: $e');
      }

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CustomerCatalogPage(user: matched)),
      );
    }
  }

  void _quickLogin(int roleId, BuildContext context) {
    final rawUsers = (appSeed['users'] as List).cast<Map<String, dynamic>>();
    final target = rawUsers.firstWhere((user) => user['role_id'] == roleId);

    emailController.text = target['email'];
    passwordController.text = target['password'];
    _errorMessage.value = null;

    _handleLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10),
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: isDesktop
                          ? _buildDesktopLayout(context)
                          : _buildMobileLayout(context),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      height: 650,
      decoration: BoxDecoration(
        color: const Color(0xFF12141A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF252832)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.35),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 5, child: _buildLoginSection(context)),
          Expanded(flex: 6, child: _buildBrandSection()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12141A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF252832)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.30),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildLoginSection(context),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -180,
          left: -150,
          child: Container(
            width: 480,
            height: 480,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [BatKittyTheme.hotPink.withOpacity(.10), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -220,
          right: -160,
          child: Container(
            width: 520,
            height: 520,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [const Color(0xFF6366F1).withOpacity(.07), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 46),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 42),
          const Text(
            'Selamat Datang',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -.6,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masuk untuk melanjutkan ke BatKitty.',
            style: TextStyle(color: Color(0xFF9297A5), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 30),
          ValueListenableBuilder<String?>(
            valueListenable: _errorMessage,
            builder: (context, error, child) {
              if (error == null) return const SizedBox.shrink();
              return Column(
                children: [
                  _buildErrorMessage(error),
                  const SizedBox(height: 18),
                ],
              );
            },
          ),
          _buildFieldLabel('Email'),
          const SizedBox(height: 7),
          _buildTextField(
            controller: emailController,
            hintText: 'Masukkan email',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),
          _buildFieldLabel('Password'),
          const SizedBox(height: 7),
          ValueListenableBuilder<bool>(
            valueListenable: _obscurePassword,
            builder: (context, obscure, child) {
              return _buildTextField(
                controller: passwordController,
                hintText: 'Masukkan password',
                icon: Icons.lock_outline_rounded,
                obscureText: obscure,
                suffixIcon: IconButton(
                  splashRadius: 20,
                  onPressed: () => _obscurePassword.value = !obscure,
                  icon: Icon(
                    obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF777D8C),
                    size: 18,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _handleLogin(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: BatKittyTheme.hotPink,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Masuk', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 30),
          _buildDevelopmentAccess(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: BatKittyTheme.hotPink.withOpacity(.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: BatKittyTheme.hotPink.withOpacity(.20)),
          ),
          alignment: Alignment.center,
          child: const Text('🦇', style: TextStyle(fontSize: 17)),
        ),
        const SizedBox(width: 11),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BATKITTY', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
            SizedBox(height: 2),
            Text('Catering', style: TextStyle(color: Color(0xFF777D8C), fontSize: 9.5)),
          ],
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFFB4B8C3), fontSize: 11, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      cursorColor: BatKittyTheme.hotPink,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF555B69), fontSize: 12.5),
        prefixIcon: Icon(icon, color: const Color(0xFF777D8C), size: 18),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF181A21),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF292C35))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF292C35))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: BatKittyTheme.hotPink, width: 1.2)),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent.withOpacity(.20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 17),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFE88A8A), fontSize: 11.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopmentAccess(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: Color(0xFF292C35))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'DEVELOPMENT ACCESS',
                style: TextStyle(color: Color(0xFF606674), fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
            ),
            const Expanded(child: Divider(color: Color(0xFF292C35))),
          ],
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            Expanded(child: _buildRoleButton('Admin', Icons.admin_panel_settings_outlined, () => _quickLogin(1, context))),
            const SizedBox(width: 7),
            Expanded(child: _buildRoleButton('Dapur', Icons.restaurant_outlined, () => _quickLogin(2, context))),
            const SizedBox(width: 7),
            Expanded(child: _buildRoleButton('Customer', Icons.person_outline_rounded, () => _quickLogin(3, context))),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleButton(String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF181A21),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: const Color(0xFF292C35)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 16, color: BatKittyTheme.hotPink),
              const SizedBox(height: 5),
              Text(label, style: const TextStyle(color: Color(0xFFB9BDC7), fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF171920),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFF282B34)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -70,
            top: -70,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(shape: BoxShape.circle, color: BatKittyTheme.hotPink.withOpacity(.055)),
            ),
          ),
          Positioned(
            left: -90,
            bottom: -100,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF6366F1).withOpacity(.045)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: BatKittyTheme.hotPink.withOpacity(.09),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Text(
                    'BATKITTY CATERING',
                    style: TextStyle(color: BatKittyTheme.hotPink, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Makanan harian,\ndipesan lebih mudah.',
                  style: TextStyle(color: Colors.white, fontSize: 34, height: 1.12, fontWeight: FontWeight.w800, letterSpacing: -.8),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pesan menu harian dan katering sesuai kebutuhan. Pilih jadwal, tentukan metode pengambilan, dan pantau pesanan kamu dalam satu tempat.',
                  style: TextStyle(color: Color(0xFF9297A5), fontSize: 12.5, height: 1.6),
                ),
                const SizedBox(height: 30),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFeatureBadge(Icons.calendar_today_outlined, 'PO H+2'),
                    _buildFeatureBadge(Icons.check_circle_outline, 'Approval 1×24 Jam'),
                    _buildFeatureBadge(Icons.schedule_outlined, 'Pembatalan H-4'),
                  ],
                ),
                const SizedBox(height: 36),
                Container(width: double.infinity, height: 1, color: const Color(0xFF282B34)),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF777D8C)),
                    SizedBox(width: 7),
                    Text('Semarang', style: TextStyle(color: Color(0xFF777D8C), fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F27),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2E38)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: BatKittyTheme.hotPink),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Color(0xFFB9BDC7), fontSize: 9.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}