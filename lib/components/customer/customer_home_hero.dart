import 'package:flutter/material.dart';

import '../../core/constants/theme.dart';

class CustomerHomeHero extends StatelessWidget {
  final VoidCallback onViewMenu;
  final VoidCallback onLogin;

  const CustomerHomeHero({
    super.key,
    required this.onViewMenu,
    required this.onLogin,
  });

  static const Color surface = Color(0xFF121419);
  static const Color textLight = Color(0xFFF7F7F8);
  static const Color textMuted = Color(0xFF9297A2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(.065),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -55,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BatKittyTheme.hotPink.withOpacity(.09),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: BatKittyTheme.hotPink.withOpacity(.10),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: BatKittyTheme.hotPink.withOpacity(.14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: BatKittyTheme.hotPink,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'PO MAKANAN • SEMARANG',
                      style: TextStyle(
                        color: BatKittyTheme.hotPink,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Lapar?',
                style: TextStyle(
                  color: textLight,
                  fontSize: 38,
                  height: .95,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.7,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'Jangan bikin ribet.',
                style: TextStyle(
                  color: BatKittyTheme.hotPink,
                  fontSize: 31,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.3,
                ),
              ),

              const SizedBox(height: 13),

              const SizedBox(
                width: 270,
                child: Text(
                  'Pilih makanan favoritmu, amankan porsinya, '
                  'lalu tinggal tunggu sampai siap.',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 12,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: onViewMenu,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              BatKittyTheme.hotPink,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(13),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu_rounded,
                              size: 17,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Lihat Menu',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 9),

                  SizedBox(
                    height: 46,
                    width: 46,
                    child: OutlinedButton(
                      onPressed: onLogin,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textLight,
                        padding: EdgeInsets.zero,
                        side: BorderSide(
                          color: Colors.white.withOpacity(.09),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(13),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 19),

              Row(
                children: const [
                  _MiniStat(
                    icon: Icons.schedule_rounded,
                    title: 'H+2',
                    subtitle: 'Booking',
                  ),
                  SizedBox(width: 22),
                  _MiniStat(
                    icon: Icons.qr_code_rounded,
                    title: 'QRIS',
                    subtitle: 'Pembayaran',
                  ),
                  SizedBox(width: 22),
                  _MiniStat(
                    icon: Icons.location_on_outlined,
                    title: 'SMG',
                    subtitle: 'Semarang',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MiniStat({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(.38),
          size: 14,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF737883),
                fontSize: 7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}