import 'package:batnkitty_food/components/customer/customer_home_hero.dart';
import 'package:batnkitty_food/components/customer/customer_info_strip.dart';
import 'package:batnkitty_food/components/customer/dish_card.dart';
import 'package:batnkitty_food/logic/customer/customer_catalog_bloc.dart';
import 'package:batnkitty_food/logic/customer/customer_catalog_state.dart';
import 'package:batnkitty_food/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/theme.dart';

class CustomerHomeDashboard extends StatelessWidget {
  final String userName;

  const CustomerHomeDashboard({
    super.key,
    this.userName = 'Foodie',
  });

  static const Color background = Color(0xFF090A0D);
  static const Color surface = Color(0xFF121419);
  static const Color surfaceSoft = Color(0xFF181A21);
  static const Color textLight = Color(0xFFF7F7F8);
  static const Color textMuted = Color(0xFF8D929D);

  void _scrollToMenu(
    BuildContext context,
    GlobalKey menuKey,
  ) {
    HapticFeedback.selectionClick();

    final target = menuKey.currentContext;

    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        alignment: .05,
      );
    }
  }

  void _goToLogin(BuildContext context) {
    HapticFeedback.selectionClick();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuKey = GlobalKey();

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: BlocBuilder<CustomerCatalogBloc, CustomerCatalogState>(
          builder: (context, state) {
            final menus = state.activeMenus;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [

                SliverToBoxAdapter(
                  child: _TopBar(
                    userName: userName,
                    onLogin: () => _goToLogin(context),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      0,
                    ),
                    child: CustomerHomeHero(
                      onViewMenu: () {
                        _scrollToMenu(
                          context,
                          menuKey,
                        );
                      },
                      onLogin: () {
                        _goToLogin(context);
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      18,
                      20,
                      0,
                    ),
                    child: CustomerInfoStrip(),
                  ),
                ),


                SliverToBoxAdapter(
                  child: KeyedSubtree(
                    key: menuKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        38,
                        20,
                        16,
                      ),
                      child: _MenuHeader(
                        menuCount: menus.length,
                      ),
                    ),
                  ),
                ),

                if (menus.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        4,
                        20,
                        40,
                      ),
                      child: _EmptyMenuState(),
                    ),
                  ),

                if (menus.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      40,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final menu = menus[index];

                          return DishCard(
                            menu: menu,
                            fallbackImage:
                                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
                          );
                        },
                        childCount: menus.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 280,
  crossAxisSpacing: 14,
  mainAxisSpacing: 16,
  childAspectRatio: .72,
),
                    ),
                  ),


                const SliverToBoxAdapter(
                  child: _Footer(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String userName;
  final VoidCallback onLogin;

  const _TopBar({
    required this.userName,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        4,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: BatKittyTheme.hotPink,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.pets_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BATKITTY',
                style: TextStyle(
                  color: CustomerHomeDashboard.textLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'FOOD & MORE',
                style: TextStyle(
                  color: CustomerHomeDashboard.textMuted,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: CustomerHomeDashboard.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(.06),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 14,
                  color: CustomerHomeDashboard.textMuted,
                ),
                const SizedBox(width: 6),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 75,
                  ),
                  child: Text(
                    userName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CustomerHomeDashboard.textLight,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 7),

          Material(
            color: CustomerHomeDashboard.surfaceSoft,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onLogin,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(9),
                child: Icon(
                  Icons.login_rounded,
                  color: CustomerHomeDashboard.textLight,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuHeader extends StatelessWidget {
  final int menuCount;

  const _MenuHeader({
    required this.menuCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 19,
                    decoration: BoxDecoration(
                      color: BatKittyTheme.hotPink,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Text(
                    'PILIHAN HARI INI',
                    style: TextStyle(
                      color: CustomerHomeDashboard.textMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              const Text(
                'Makan apa hari ini?',
                style: TextStyle(
                  color: CustomerHomeDashboard.textLight,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.7,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                menuCount > 0
                    ? 'Fresh batch yang lagi tersedia buat kamu.'
                    : 'Tunggu batch berikutnya, ya.',
                style: const TextStyle(
                  color: CustomerHomeDashboard.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        if (menuCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: BatKittyTheme.hotPink.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: BatKittyTheme.hotPink.withOpacity(.16),
              ),
            ),
            child: Text(
              '$menuCount menu',
              style: const TextStyle(
                color: BatKittyTheme.hotPink,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyMenuState extends StatelessWidget {
  const _EmptyMenuState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        24,
        34,
        24,
        34,
      ),
      decoration: BoxDecoration(
        color: CustomerHomeDashboard.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: BatKittyTheme.hotPink.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_rounded,
              color: BatKittyTheme.hotPink.withOpacity(.65),
              size: 25,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Belum ada menu yang dibuka',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomerHomeDashboard.textLight,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Batch berikutnya lagi disiapkan.\n'
            'Cek lagi nanti biar nggak ketinggalan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomerHomeDashboard.textMuted,
              fontSize: 11,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: CustomerHomeDashboard.textMuted,
                  size: 15,
                ),
                SizedBox(width: 7),
                Text(
                  'Stay tuned',
                  style: TextStyle(
                    color: CustomerHomeDashboard.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        30,
      ),
      child: Column(
        children: [
          Divider(
            color: Colors.white.withOpacity(.06),
            height: 1,
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pets_rounded,
                size: 13,
                color: BatKittyTheme.hotPink.withOpacity(.7),
              ),
              const SizedBox(width: 6),
              const Text(
                'BATKITTY',
                style: TextStyle(
                  color: CustomerHomeDashboard.textMuted,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Good food. Less drama.',
            style: TextStyle(
              color: CustomerHomeDashboard.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}