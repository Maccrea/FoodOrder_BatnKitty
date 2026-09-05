import 'package:batnkitty_food/logic/customer/customer_catalog_state.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/theme.dart';
import '../../logic/customer/customer_catalog_state.dart';

class OperationalBanner extends StatelessWidget {
  final CustomerCatalogState state;

  const OperationalBanner({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final percentage = state.maxDailyQuota == 0
        ? 0.0
        : state.currentOrdersToday / state.maxDailyQuota;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: state.canOrder
              ? [
                  BatKittyTheme.hotPink.withOpacity(.16),
                  BatKittyTheme.surfaceDark,
                ]
              : [
                  Colors.redAccent.withOpacity(.12),
                  BatKittyTheme.surfaceDark,
                ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: state.canOrder
              ? BatKittyTheme.hotPink.withOpacity(.18)
              : Colors.redAccent.withOpacity(.18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: state.canOrder
                      ? BatKittyTheme.hotPink.withOpacity(.12)
                      : Colors.redAccent.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  state.canOrder
                      ? Icons.storefront_rounded
                      : Icons.lock_clock_rounded,
                  color: state.canOrder
                      ? BatKittyTheme.hotPink
                      : Colors.redAccent,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.canOrder
                          ? 'Order window is open'
                          : 'Order window is closed',
                      style: const TextStyle(
                        color: BatKittyTheme.textMain,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.canOrder
                          ? '${state.remainingQuota} slot tersisa hari ini'
                          : 'Kuota hari ini sudah penuh',
                      style: const TextStyle(
                        color: BatKittyTheme.textMuted,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: state.canOrder
                      ? Colors.greenAccent.withOpacity(.10)
                      : Colors.redAccent.withOpacity(.10),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  state.canOrder ? 'OPEN' : 'CLOSED',
                  style: TextStyle(
                    color: state.canOrder
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 5,
              value: percentage.clamp(0.0, 1.0).toDouble(),
              backgroundColor: BatKittyTheme.bgDark,
              valueColor: AlwaysStoppedAnimation(
                state.canOrder ? BatKittyTheme.hotPink : Colors.redAccent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${state.currentOrdersToday} pesanan',
                style: const TextStyle(
                  color: BatKittyTheme.textMuted,
                  fontSize: 9,
                ),
              ),
              Text(
                'Max ${state.maxDailyQuota}',
                style: const TextStyle(
                  color: BatKittyTheme.textMuted,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}