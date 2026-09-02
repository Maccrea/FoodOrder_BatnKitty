import 'package:flutter/material.dart';
import '../../core/constants/theme.dart';
import '../../core/utils/formatters.dart';

class FinancialPage extends StatelessWidget {
  const FinancialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Overview',
                  style: TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Monitor revenue, logistics cost, and recent transactions',
                  style: TextStyle(
                    color: BatKittyTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // KPI CARDS
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Food Revenue',
                value: formatRupiah(4850000),
                label: 'Total food sales',
                icon: Icons.restaurant_rounded,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricCard(
                title: 'Logistics Cost',
                value: formatRupiah(340000),
                label: 'Delivery & fuel',
                icon: Icons.local_shipping_rounded,
                color: BatKittyTheme.hotPink,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricCard(
                title: 'Promo Subsidy',
                value: formatRupiah(75000),
                label: 'Loyalty discount',
                icon: Icons.local_offer_rounded,
                color: Colors.amberAccent,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // TRANSACTION SECTION
        Container(
          decoration: BoxDecoration(
            color: BatKittyTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: BatKittyTheme.borderSubtle,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: TextStyle(
                            color: BatKittyTheme.textMain,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Latest completed orders',
                          style: TextStyle(
                            color: BatKittyTheme.textSubtle,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    _buildFilterButton(),
                  ],
                ),
              ),

              const Divider(
                height: 1,
                color: BatKittyTheme.borderSubtle,
              ),

              _buildTableHeader(),

              _buildTransactionRow(
                '#ORD-092',
                'Budi Santoso',
                formatRupiah(35000),
                formatRupiah(9000),
                'Completed',
              ),

              _buildTransactionRow(
                '#ORD-091',
                'Siti Rahma',
                formatRupiah(105000),
                'Pickup',
                'Completed',
              ),

              _buildTransactionRow(
                '#ORD-090',
                'Ahmad Fauzi',
                formatRupiah(45000),
                formatRupiah(9000),
                'Completed',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 19,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: BatKittyTheme.textSubtle,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: BatKittyTheme.borderSubtle,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.tune_rounded,
            size: 13,
            color: BatKittyTheme.textMuted,
          ),
          SizedBox(width: 6),
          Text(
            'Filter',
            style: TextStyle(
              color: BatKittyTheme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'ORDER',
              style: TextStyle(
                color: BatKittyTheme.textSubtle,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'CUSTOMER',
              style: TextStyle(
                color: BatKittyTheme.textSubtle,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'FOOD',
              style: TextStyle(
                color: BatKittyTheme.textSubtle,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'DELIVERY',
              style: TextStyle(
                color: BatKittyTheme.textSubtle,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'STATUS',
              style: TextStyle(
                color: BatKittyTheme.textSubtle,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(
    String id,
    String customer,
    String food,
    String delivery,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: BatKittyTheme.borderSubtle,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              id,
              style: const TextStyle(
                color: BatKittyTheme.textMain,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              customer,
              style: const TextStyle(
                color: BatKittyTheme.textMuted,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              food,
              style: const TextStyle(
                color: BatKittyTheme.textMain,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              delivery,
              style: const TextStyle(
                color: BatKittyTheme.textMuted,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(.10),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

