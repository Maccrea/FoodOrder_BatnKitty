import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/local/app_seed.dart';
import 'customer_catalog_state.dart';

abstract class CustomerCatalogEvent {}

class LoadCustomerCatalogEvent extends CustomerCatalogEvent {
  final String userPhone;
  LoadCustomerCatalogEvent(this.userPhone);
}

class MarkOrderPaidEvent extends CustomerCatalogEvent {
  final int orderId;
  final String transactionId;
  MarkOrderPaidEvent({required this.orderId, required this.transactionId});
}

class CreateCustomerOrderEvent extends CustomerCatalogEvent {
  final Map<String, dynamic> order;
  final String userPhone;

  CreateCustomerOrderEvent({
    required this.order,
    required this.userPhone,
  });
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
    on<MarkOrderPaidEvent>(_onMarkOrderPaid);
  }

void _onMarkOrderPaid(
  MarkOrderPaidEvent event,
  Emitter<CustomerCatalogState> emit,
) {
  final updatedOrders = state.myOrders.map((o) {
    if (o['id'] == event.orderId) {
      final updated = Map<String, dynamic>.from(o);
      updated['status_bayar'] = 'Lunas';
      updated['payment_info'] = {
        'transaction_id': event.transactionId,
        'paid_at': DateTime.now().toIso8601String(),
        'method': 'QRIS Midtrans',
      };
      return updated;
    }
    return o;
  }).toList();

  emit(state.copyWith(
    myOrders: updatedOrders,
    message: 'Pembayaran QRIS berhasil! Pesanan siap diproses dapur.',
  ));
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

    final customers = (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (var cust in customers) {
      if (cust['phone'] == event.userPhone) {
        final custOrders = (cust['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        cust['orders'] = [event.order, ...custOrders];
        break;
      }
    }

    if (appSeed.containsKey('orders')) {
      final allOrders = (appSeed['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      appSeed['orders'] = [event.order, ...allOrders];
    }

    emit(state.copyWith(
      myOrders: updatedOrders,
      currentOrdersToday: state.currentOrdersToday + 1,
      message: 'Pesanan PO berhasil dibuat dan masuk antrean sistem.',
      isError: false,
    ));
  }

  void _onCancelOrder(CancelCustomerOrderEvent event, Emitter<CustomerCatalogState> emit) {
    final updatedOrders = state.myOrders.map((order) {
      if (order['id'] == event.orderId) {
        return {
          ...order,
          'status_pesanan': 'cancelled',
          'cancellation_reason': event.reason,
        };
      }
      return order;
    }).toList();

    final customers = (appSeed['customers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    for (var cust in customers) {
      final custOrders = (cust['orders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      for (var o in custOrders) {
        if (o['id'] == event.orderId) {
          o['status_pesanan'] = 'cancelled';
          o['cancellation_reason'] = event.reason;
        }
      }
    }

    emit(state.copyWith(
      myOrders: updatedOrders,
      message: 'Pesanan berhasil dibatalkan.',
      isError: false,
    ));
  }
}