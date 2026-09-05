import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/local/app_seed.dart';
import '../../../logic/admin/admin_bloc.dart';
import '../../../logic/admin/admin_state.dart';

class DashboardPage extends StatefulWidget {
  final ValueChanged<String>? onNavigate;

  const DashboardPage({super.key, this.onNavigate});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isStoreOpen = true;
  String openHour = '08:00';
  String closeHour = '20:00';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        final rawCustomers =
            (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final int totalCustomers = rawCustomers.length;
        final int repeatCustomers = rawCustomers
            .where((c) => ((c['orders'] as List?)?.length ?? 0) > 1)
            .length;

        final Map<String, int> areaDistribution = {};
        for (var o in state.allOrders) {
          final addr = (o['delivery_address'] ?? 'Pickup di Tempat').toString();
          String area = 'Pickup';
          if (addr.toLowerCase().contains('binus'))
            area = 'Binus / Madukoro';
          else if (addr.toLowerCase().contains('puri'))
            area = 'Puri Anjasmoro';
          else if (addr.toLowerCase().contains('tawangmas'))
            area = 'Tawangmas';
          else if (addr.toLowerCase().contains('stadium') ||
              addr.toLowerCase().contains('jki'))
            area = 'Holy Stadium';
          else if (o['delivery_type'] == 'Delivery')
            area = 'Semarang Lainnya';

          areaDistribution[area] = (areaDistribution[area] ?? 0) + 1;
        }

        final Map<String, int> menuQtyMap = {};
        for (var order in state.allOrders) {
          final items =
              (order['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          if (items.isNotEmpty) {
            for (var item in items) {
              final String name =
                  item['menu_name'] ?? order['menu_name'] ?? 'Menu PO';
              final int qty = (item['quantity'] as num?)?.toInt() ?? 1;
              menuQtyMap[name] = (menuQtyMap[name] ?? 0) + qty;
            }
          } else {
            final String name = order['menu_name'] ?? 'Menu PO';
            final int qty = (order['quantity'] as num?)?.toInt() ?? 1;
            menuQtyMap[name] = (menuQtyMap[name] ?? 0) + qty;
          }
        }

        String topMenuName = 'Belum ada data';
        int topMenuQty = 0;
        if (menuQtyMap.isNotEmpty) {
          final topEntry = menuQtyMap.entries.reduce(
            (a, b) => a.value > b.value ? a : b,
          );
          topMenuName = topEntry.key;
          topMenuQty = topEntry.value;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 1150;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEnterpriseHeader(context, state),
                  const SizedBox(height: 18),

                  if (state.totalWaiting > 0) ...[
                    _buildActionAlert(state.totalWaiting),
                    const SizedBox(height: 18),
                  ],

                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          title: 'TOTAL OMZET',
                          value: formatRupiah(state.totalRevenue.toInt()),
                          subtitle: 'Saldo riil GoPay/BCA',
                          icon: Icons.account_balance_wallet_rounded,
                          accent: Colors.greenAccent,
                          onTap: () => widget.onNavigate?.call('finance'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'TOTAL PESANAN',
                          value: '${state.allOrders.length}',
                          subtitle: '${state.totalWaiting} pesanan verifikasi',
                          icon: Icons.receipt_long_rounded,
                          accent: BatKittyTheme.hotPink,
                          onTap: () => widget.onNavigate?.call('orders'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'TOTAL PELANGGAN',
                          value: '$totalCustomers Orang',
                          subtitle: '$repeatCustomers repeat order',
                          icon: Icons.people_alt_rounded,
                          accent: Colors.tealAccent,
                          onTap: () => widget.onNavigate?.call('orders'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'MENU TERLARIS ⭐',
                          value: topMenuQty > 0 ? '$topMenuQty Porsi' : '-',
                          subtitle: topMenuName,
                          icon: Icons.star_rounded,
                          accent: Colors.amberAccent,
                          onTap: () => widget.onNavigate?.call('menu'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildRecentOrdersCard(
                            state.allOrders.take(5).toList(),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: _buildRightSideOperations(
                            areaDistribution,
                            state,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildRecentOrdersCard(
                          state.allOrders.take(5).toList(),
                        ),
                        const SizedBox(height: 20),
                        _buildRightSideOperations(areaDistribution, state),
                      ],
                    ),

                  const SizedBox(height: 20),

                  _buildQuickActionsCard(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionAlert(int waiting) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orangeAccent.withOpacity(.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_rounded,
            color: Colors.orangeAccent,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Ada $waiting pesanan PO masuk yang belum disetujui.',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => widget.onNavigate?.call('orders'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Buka Verifikasi',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: BatKittyTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BatKittyTheme.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: BatKittyTheme.textSubtle,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .6,
                  ),
                ),
                Icon(icon, color: accent, size: 17),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                color: accent,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSideOperations(
    Map<String, int> areaDist,
    AdminState state,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: BatKittyTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BatKittyTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: BatKittyTheme.hotPink,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sebaran Wilayah Pelanggan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...areaDist.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.key,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                        ),
                      ),
                      Text(
                        '${e.value} Order',
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: BatKittyTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BatKittyTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Batas Kuota Masak Hari Ini',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${state.totalKitchen} / 10 Slot',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (state.totalKitchen / 10).clamp(0.0, 1.0),
                  backgroundColor: BatKittyTheme.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.orangeAccent,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnterpriseHeader(BuildContext context, AdminState state) {
    final openStr =
        '${state.openTime.hour.toString().padLeft(2, '0')}:${state.openTime.minute.toString().padLeft(2, '0')}';
    final closeStr =
        '${state.closeTime.hour.toString().padLeft(2, '0')}:${state.closeTime.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: BatKittyTheme.hotPink.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.store_rounded,
              color: BatKittyTheme.hotPink,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BatKitty Command Center 🦇',
                  style: TextStyle(
                    color: BatKittyTheme.textMain,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),

                InkWell(
                  onTap: () => _showCustomStoreHoursDialog(context, state),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141720),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF1F2433)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: BatKittyTheme.pinkGlow,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Jam Operasional: $openStr – $closeStr WIB',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.edit_rounded,
                          size: 12,
                          color: BatKittyTheme.pinkGlow,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF141720),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1F2433)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 8,
                  color: state.isStoreOpen
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
                const SizedBox(width: 8),
                Text(
                  state.isStoreOpen ? 'TOKO BUKA' : 'TOKO TUTUP',
                  style: TextStyle(
                    color: state.isStoreOpen
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 10),
                Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    value: state.isStoreOpen,
                    activeColor: Colors.greenAccent,
                    onChanged: (_) =>
                        context.read<AdminBloc>().add(ToggleStoreStatusEvent()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersCard(List<Map<String, dynamic>> orders) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                color: BatKittyTheme.hotPink,
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Pesanan Berjalan & Terkini',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => widget.onNavigate?.call('orders'),
                child: const Text(
                  'Buka Semua',
                  style: TextStyle(
                    color: BatKittyTheme.pinkGlow,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...orders.map((order) {
            final int id = order['id'] ?? 0;
            final bool isPickup = order['delivery_type'] == 'Pickup';
            final String status = order['status_pesanan'] ?? 'completed';
            final Color color = status == 'completed'
                ? Colors.greenAccent
                : (status == 'delivering'
                      ? Colors.tealAccent
                      : Colors.orangeAccent);

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: BatKittyTheme.borderSubtle),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isPickup
                        ? Icons.storefront_rounded
                        : Icons.delivery_dining_rounded,
                    size: 16,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#ORD-$id · ${order['customer_name']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${order['menu_name']} (${order['quantity'] ?? 1} porsi)',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatRupiah(((order['total_price'] as num?) ?? 0).toInt()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BatKittyTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BatKittyTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aksi Cepat Admin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => widget.onNavigate?.call('cashier'),
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                  label: const Text('Input Pesanan Kasir (POS)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BatKittyTheme.hotPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => widget.onNavigate?.call('orders'),
                  icon: const Icon(Icons.rule_folder_rounded, size: 16),
                  label: const Text('Approval & Antrean Dapur'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BatKittyTheme.surfaceElevated,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => widget.onNavigate?.call('menu'),
                  icon: const Icon(Icons.inventory_2_rounded, size: 16),
                  label: const Text('Update Stok & Menu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BatKittyTheme.surfaceElevated,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCustomStoreHoursDialog(BuildContext context, AdminState state) {
    int selectedOpenHour = state.openTime.hour;
    int selectedOpenMin = state.openTime.minute;
    int selectedCloseHour = state.closeTime.hour;
    int selectedCloseMin = state.closeTime.minute;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF141720),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFF222634)),
            ),
            contentPadding: const EdgeInsets.all(24),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: BatKittyTheme.hotPink.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: BatKittyTheme.hotPink,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atur Jam Operasional Toko',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pemesanan pelanggan dibatasi sesuai jam ini',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                _buildTimeSelectRow(
                  label: 'Jam Buka Toko',
                  icon: Icons.wb_sunny_outlined,
                  accentColor: Colors.amberAccent,
                  hourValue: selectedOpenHour,
                  minValue: selectedOpenMin,
                  onHourChanged: (val) =>
                      setModalState(() => selectedOpenHour = val!),
                  onMinChanged: (val) =>
                      setModalState(() => selectedOpenMin = val!),
                ),
                const SizedBox(height: 16),
                _buildTimeSelectRow(
                  label: 'Jam Tutup Toko',
                  icon: Icons.nightlight_outlined,
                  accentColor: Colors.purpleAccent,
                  hourValue: selectedCloseHour,
                  minValue: selectedCloseMin,
                  onHourChanged: (val) =>
                      setModalState(() => selectedCloseHour = val!),
                  onMinChanged: (val) =>
                      setModalState(() => selectedCloseMin = val!),
                ),
              ],
            ),
            actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BatKittyTheme.hotPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  final newOpen = TimeOfDay(
                    hour: selectedOpenHour,
                    minute: selectedOpenMin,
                  );
                  final newClose = TimeOfDay(
                    hour: selectedCloseHour,
                    minute: selectedCloseMin,
                  );

                  context.read<AdminBloc>().add(
                    UpdateStoreHoursEvent(
                      openTime: newOpen,
                      closeTime: newClose,
                    ),
                  );

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Jam operasional disimpan: ${selectedOpenHour.toString().padLeft(2, '0')}:${selectedOpenMin.toString().padLeft(2, '0')} – ${selectedCloseHour.toString().padLeft(2, '0')}:${selectedCloseMin.toString().padLeft(2, '0')} WIB',
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text(
                  'Simpan Pengaturan',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeSelectRow({
    required String label,
    required IconData icon,
    required Color accentColor,
    required int hourValue,
    required int minValue,
    required ValueChanged<int?> onHourChanged,
    required ValueChanged<int?> onMinChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E2230)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF141720),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF222634)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: hourValue,
                dropdownColor: const Color(0xFF141720),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                items: List.generate(24, (i) => i)
                    .map(
                      (h) => DropdownMenuItem(
                        value: h,
                        child: Text(h.toString().padLeft(2, '0')),
                      ),
                    )
                    .toList(),
                onChanged: onHourChanged,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              ':',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF141720),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF222634)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: minValue,
                dropdownColor: const Color(0xFF141720),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                items: [0, 15, 30, 45]
                    .map(
                      (m) => DropdownMenuItem(
                        value: m,
                        child: Text(m.toString().padLeft(2, '0')),
                      ),
                    )
                    .toList(),
                onChanged: onMinChanged,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'WIB',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
