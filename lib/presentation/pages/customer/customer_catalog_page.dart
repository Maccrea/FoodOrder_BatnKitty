import 'package:batnkitty_food/data/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/theme.dart';
import '../../../logic/customer/customer_catalog_bloc.dart';
import '../../../logic/customer/customer_catalog_state.dart';
import '/components/customer/cancel_order_dialog.dart';
import '/components/customer/checkout_order_sheet.dart';
import '/components/customer/customer_menu_card.dart';
import '/components/customer/operational_banner.dart';
import '/components/customer/orders_history_dialog.dart';
import '/core/network/api_client.dart';
import '/core/network/api_endpoint.dart';
import '/core/network/api_service.dart';



class CustomerCatalogPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const CustomerCatalogPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomerCatalogBloc()
        ..add(
          LoadCustomerCatalogEvent(
            user['phone'] ?? '',
            customerId: user['id'] is int ? user['id'] as int : null,
          ),
        ),
      child: _CustomerCatalogView(user: user),
    );
  }
}

class _CustomerCatalogView extends StatelessWidget {
  final Map<String, dynamic> user;

  const _CustomerCatalogView({required this.user});

  Future<void> _hubungiAdminWA(String pesan) async {
    const adminPhone = '6281234567890';
    final uri = Uri.parse('https://wa.me/$adminPhone?text=${Uri.encodeComponent(pesan)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: error ? Colors.redAccent : BatKittyTheme.surfaceDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: Row(
            children: [
              Icon(error ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
  }

void _handleCheckout(BuildContext context, Map<String, dynamic> menu) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CheckoutOrderSheet(
      menu: menu,
      userName: user['name'] ?? 'Pelanggan',
      onConfirm: (newOrder) async {
        try {
          final apiService = ApiService(ApiClient().dio);
          final customerId = int.tryParse(user['id']?.toString() ?? '') ?? 1;

          final request = CreateOrderRequest(
            customerId: customerId,
            tanggalPengambilan: newOrder['tanggal_pengambilan'], // Format: YYYY-MM-DD HH:mm:ss
            deliveryType: newOrder['delivery_type'],
            deliveryAddress: newOrder['delivery_address'],
            deliveryFee: newOrder['delivery_type'] == 'Delivery' ? 10000 : 0,
            items: [
              OrderItemModel(
                menuName: menu['name'],
                quantity: newOrder['quantity'],
                unitPrice: menu['price'] ?? menu['base_price'] ?? 0,
                customNotes: newOrder['custom_notes'],
              )
            ],
          );

          final response = await apiService.createOrder(request);

          if (response.statusCode == 200 || response.statusCode == 201) {
            final responseData = response.data is Map<String, dynamic>
                ? response.data as Map<String, dynamic>
                : <String, dynamic>{};
            final orderData = responseData['data'] is Map<String, dynamic>
                ? responseData['data'] as Map<String, dynamic>
                : responseData;

            context.read<CustomerCatalogBloc>().add(
              CreateCustomerOrderEvent(
                order: {
                  ...newOrder,
                  ...orderData,
                  'status_pesanan': orderData['status_pesanan'] ?? 'waiting_approve',
                },
                userPhone: user['phone'] ?? '',
              ),
            );

            _hubungiAdminWA(
              'Halo Admin BatKitty, saya ${user['name']} membuat pesanan PO:\n\n'
              'Menu: ${menu['name']}\n'
              'Jumlah: ${newOrder['quantity']}\n'
              'Tipe: ${newOrder['delivery_type']}\n'
              'Mohon konfirmasinya.',
            );
            
            Navigator.pop(context); 
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal membuat pesanan. Cek kembali jadwal pengambilan.')),
          );
        }
      },
    ),
  );
}

  void _handleCancel(BuildContext context, Map<String, dynamic> order) {
    CancelOrderDialog.show(
      context,
      order: order,
      onConfirmCancel: (reason) {
        context.read<CustomerCatalogBloc>().add(
              CancelCustomerOrderEvent(
                orderId: order['id'],
                reason: reason,
              ),
            );
      },
      onExceededDeadline: () {
        _showSnackBar(
          context,
          'Pembatalan hanya dapat dilakukan maksimal 4 jam sebelum jadwal.',
          error: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = user['name']?.toString().trim() ?? 'Pelanggan';
    final firstName = userName.split(' ').first;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return BlocConsumer<CustomerCatalogBloc, CustomerCatalogState>(
      listener: (context, state) {
        if (state.message != null) {
          _showSnackBar(context, state.message!, error: state.isError);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: BatKittyTheme.bgDark,
          appBar: _buildAppBar(context, state),
          body: SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildGreetingHeader(firstName),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                        child: OperationalBanner(state: state),
                      ),
                    ),
                    _buildMenuSectionTitle(),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    _buildMenuGrid(state, isDesktop),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _hubungiAdminWA('Halo Admin BatKitty, saya ingin bertanya seputar menu/pesanan.'),
            backgroundColor: BatKittyTheme.surfaceDark,
            foregroundColor: BatKittyTheme.textMain,
            elevation: 8,
            icon: const Icon(Icons.support_agent_rounded, size: 19),
            label: const Text('Need help?', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, CustomerCatalogState state) {
    return AppBar(
      backgroundColor: BatKittyTheme.bgDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [BatKittyTheme.hotPink, Colors.deepPurpleAccent],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 19),
          ),
          const SizedBox(width: 11),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BatKitty',
                style: TextStyle(
                  color: BatKittyTheme.textMain,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.3,
                ),
              ),
              Text(
                'Food Experience',
                style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: TextButton.icon(
            onPressed: () => OrdersHistoryDialog.show(
              context,
              orders: state.myOrders,
              onCancelOrder: (order) => _handleCancel(context, order),
            ),
            style: TextButton.styleFrom(
              backgroundColor: BatKittyTheme.surfaceDark,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: BatKittyTheme.borderSubtle),
              ),
            ),
            icon: const Icon(Icons.receipt_long_rounded, size: 17, color: BatKittyTheme.hotPink),
            label: Row(
              children: [
                const Text(
                  'Pesanan Saya',
                  style: TextStyle(color: BatKittyTheme.textMain, fontSize: 12, fontWeight: FontWeight.w700),
                ),
                if (state.myOrders.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: BatKittyTheme.hotPink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${state.myOrders.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildGreetingHeader(String firstName) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good day, $firstName 👋',
              style: const TextStyle(color: BatKittyTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            const Text(
              'What are you craving today?',
              style: TextStyle(
                color: BatKittyTheme.textMain,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                letterSpacing: -.8,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fresh meals, made for your day.',
              style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildMenuSectionTitle() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore Menu',
                    style: TextStyle(
                      color: BatKittyTheme.textMain,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.4,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Pilihan menu terbaik BatKitty',
                    style: TextStyle(color: BatKittyTheme.textMuted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            Icon(Icons.tune_rounded, color: BatKittyTheme.textMuted, size: 19),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildMenuGrid(CustomerCatalogState state, bool isDesktop) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => CustomerMenuCard(
            menu: state.activeMenus[index],
            canOrder: state.canOrder,
            onOrder: () => _handleCheckout(context, state.activeMenus[index]),
          ),
          childCount: state.activeMenus.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: isDesktop ? 1.35 : 0.95,
        ),
      ),
    );
  }
}