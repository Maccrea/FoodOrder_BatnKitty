import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/local/app_seed.dart';
import 'customer_catalog_state.dart';

abstract class CustomerCatalogEvent {}

class LoadCustomerCatalogEvent extends CustomerCatalogEvent {
  final String userPhone;
  LoadCustomerCatalogEvent(this.userPhone);
}

class CreateCustomerOrderEvent extends CustomerCatalogEvent {
  final Map<String, dynamic> order;
  CreateCustomerOrderEvent(this.order);
}

class CancelCustomerOrderEvent extends CustomerCatalogEvent {
  final int orderId;
  final String reason;
  CancelCustomerOrderEvent({required this.orderId, required this.reason});
}

class CustomerCatalogBloc extends Bloc<CustomerCatalogEvent, CustomerCatalogState> {
  CustomerCatalogBloc() : super(const CustomerCatalogState()) {
    on<LoadCustomerCatalogEvent>(_onLoadCatalog);
    on<CreateCustomerOrderEvent>(_onCreateOrder);
    on<CancelCustomerOrderEvent>(_onCancelOrder);
  }

  void _onLoadCatalog(LoadCustomerCatalogEvent event, Emitter<CustomerCatalogState> emit) {
    final rawMenus = (appSeed['menus'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final active = rawMenus.where((m) => m['is_active'] == true).toList();

    final customers = (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final currentCustomer = customers.firstWhere(
      (c) => c['phone'] == event.userPhone,
      orElse: () => {'orders': <Map<String, dynamic>>[]},
    );

    final orders = (currentCustomer['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    emit(state.copyWith(
      activeMenus: active,
      myOrders: List<Map<String, dynamic>>.from(orders),
    ));
  }

  void _onCreateOrder(CreateCustomerOrderEvent event, Emitter<CustomerCatalogState> emit) {
    final updatedOrders = List<Map<String, dynamic>>.from(state.myOrders)..insert(0, event.order);
    emit(state.copyWith(
      myOrders: updatedOrders,
      currentOrdersToday: state.currentOrdersToday + 1,
      message: 'Pesanan berhasil dikirim.',
      isError: false,
    ));
  }

  void _onCancelOrder(CancelCustomerOrderEvent event, Emitter<CustomerCatalogState> emit) {
    final updatedOrders = state.myOrders.map((order) {
      if (order['id'] == event.orderId) {
        final schedule = DateTime.parse(order['tanggal_pengambilan']);
        final cancelDeadline = schedule.subtract(const Duration(hours: 4));

        if (DateTime.now().isAfter(cancelDeadline)) {
          emit(state.copyWith(
            message: 'Pembatalan hanya dapat dilakukan maksimal 4 jam sebelum jadwal.',
            isError: true,
          ));
          return order;
        }

        return {
          ...order,
          'status_pesanan': 'cancelled',
          'cancellation_reason': event.reason,
        };
      }
      return order;
    }).toList();

    emit(state.copyWith(
      myOrders: updatedOrders,
      message: 'Pesanan berhasil dibatalkan.',
      isError: false,
    ));
  }
}