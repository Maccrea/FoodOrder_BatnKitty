import 'package:batnkitty_food/data/services/order_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/local/app_seed.dart';
import ''; 
import 'admin_state.dart';

abstract class AdminEvent {}

class LoadAdminDataEvent extends AdminEvent {}

class FilterAdminOrdersEvent extends AdminEvent {
  final String? statusFilter;
  final String? fulfillmentFilter;
  final String? query;
  FilterAdminOrdersEvent({this.statusFilter, this.fulfillmentFilter, this.query});
}

class SelectOrderForDetailEvent extends AdminEvent {
  final Map<String, dynamic> order;
  SelectOrderForDetailEvent(this.order);
}

class ChangeDeliveryDateEvent extends AdminEvent {
  final DateTime date;
  ChangeDeliveryDateEvent(this.date);
}

class UpdateAdminOrderStatusEvent extends AdminEvent {
  final int orderId;
  final String newStatus;
  final String? reason;
  UpdateAdminOrderStatusEvent({required this.orderId, required this.newStatus, this.reason});
}

class UpdateDeliveryStatusEvent extends AdminEvent {
  final int orderId;
  final String nextStatus;
  UpdateDeliveryStatusEvent({required this.orderId, required this.nextStatus});
}

class CreateCashierOrderEvent extends AdminEvent {
  final Map<String, dynamic> newOrder;
  final String customerName;
  final String customerPhone;
  CreateCashierOrderEvent({required this.newOrder, required this.customerName, required this.customerPhone});
}

class AddExpenseEvent extends AdminEvent {
  final String title;
  final num amount;
  AddExpenseEvent({required this.title, required this.amount});
}

class ToggleStoreStatusEvent extends AdminEvent {}

class UpdateStoreHoursEvent extends AdminEvent {
  final TimeOfDay openTime;
  final TimeOfDay closeTime;
  UpdateStoreHoursEvent({required this.openTime, required this.closeTime});
}

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final OrderApiService _orderApiService;

  AdminBloc({required OrderApiService orderApiService})
      : _orderApiService = orderApiService,
        super(AdminState()) {
    on<LoadAdminDataEvent>(_onLoadData);
    on<FilterAdminOrdersEvent>(_onFilterOrders);
    on<SelectOrderForDetailEvent>(_onSelectOrder);
    on<ChangeDeliveryDateEvent>(_onChangeDeliveryDate);
    on<UpdateAdminOrderStatusEvent>(_onUpdateOrderStatus);
    on<UpdateDeliveryStatusEvent>(_onUpdateDeliveryStatus);
    on<CreateCashierOrderEvent>(_onCreateCashierOrder);
    on<AddExpenseEvent>(_onAddExpense);
    on<ToggleStoreStatusEvent>(_onToggleStoreStatus);
    on<UpdateStoreHoursEvent>(_onUpdateStoreHours);
  }

Future<void> _onLoadData(LoadAdminDataEvent event, Emitter<AdminState> emit) async {
  try {
    final response = await _orderApiService.getOrders();
    final List<dynamic> rawList = response.data['data'] ?? [];

    final normalizedOrders = rawList.map((order) {
      final itemMap = Map<String, dynamic>.from(order);
      final items = (order['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];

      if (items.isNotEmpty) {
        final first = items.first;
        itemMap['menu_name'] = itemMap['menu_name'] ?? first['menu_name'] ?? 'Menu PO';
        itemMap['quantity'] = itemMap['quantity'] ?? first['quantity'] ?? 1;
        itemMap['custom_notes'] = itemMap['custom_notes'] ?? first['custom_notes'];
      } else {
        itemMap['menu_name'] = itemMap['menu_name'] ?? 'Menu PO';
        itemMap['quantity'] = itemMap['quantity'] ?? 1;
      }

      itemMap['status_pesanan'] = itemMap['status_pesanan'] ??
          (itemMap['status_masak'] == 'Selesai' ? 'completed' : 'processing');
      return itemMap;
    }).toList();

    normalizedOrders.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));

    emit(state.copyWith(
      allOrders: normalizedOrders,
      selectedOrder: normalizedOrders.isNotEmpty ? normalizedOrders.first : null,
      statusFilter: 'all',
      selectedDeliveryDate: DateTime(2026, 9, 7),
    ));
  } catch (e) {
    debugPrint('Gagal memuat data orders dari API: $e');
  }
}

  void _onFilterOrders(FilterAdminOrdersEvent event, Emitter<AdminState> emit) {
    emit(state.copyWith(
      statusFilter: event.statusFilter ?? state.statusFilter,
      fulfillmentFilter: event.fulfillmentFilter ?? state.fulfillmentFilter,
      searchQuery: event.query ?? state.searchQuery,
    ));
  }

  void _onSelectOrder(SelectOrderForDetailEvent event, Emitter<AdminState> emit) {
    emit(state.copyWith(selectedOrder: event.order));
  }

  void _onChangeDeliveryDate(ChangeDeliveryDateEvent event, Emitter<AdminState> emit) {
    emit(state.copyWith(selectedDeliveryDate: event.date));
  }

  Future<void> _onUpdateOrderStatus(
      UpdateAdminOrderStatusEvent event, Emitter<AdminState> emit) async {
    try {
      await _orderApiService.updateOrderStatus(event.orderId, event.newStatus);

      final updatedList = state.allOrders.map((o) {
        if (o['id'] == event.orderId) {
          final updated = Map<String, dynamic>.from(o);
          updated['status_pesanan'] = event.newStatus;
          if (event.reason != null) updated['cancellation_reason'] = event.reason;
          if (event.newStatus == 'approved' || event.newStatus == 'completed') {
            updated['status_bayar'] = 'Lunas';
          }
          return updated;
        }
        return o;
      }).toList();

      emit(state.copyWith(
        allOrders: updatedList,
        selectedOrder: updatedList.firstWhere((o) => o['id'] == event.orderId),
      ));
    } catch (e) {
      debugPrint('Gagal update status pesanan ke API: $e');
    }
  }

  Future<void> _onUpdateDeliveryStatus(
      UpdateDeliveryStatusEvent event, Emitter<AdminState> emit) async {
    try {
      String kitchenStatus = event.nextStatus == 'Delivering' ? 'Delivering' : 'Selesai';
      
      await _orderApiService.updateKitchenStatus(event.orderId, kitchenStatus);

      final updatedList = state.allOrders.map((o) {
        if (o['id'] == event.orderId) {
          final updated = Map<String, dynamic>.from(o);
          if (event.nextStatus == 'Delivering') {
            updated['status_pesanan'] = 'delivering';
            updated['status_masak'] = 'Delivering';
          } else if (event.nextStatus == 'Delivered') {
            updated['status_pesanan'] = 'completed';
            updated['status_masak'] = 'Selesai';
            updated['status_bayar'] = 'Lunas';
          }
          return updated;
        }
        return o;
      }).toList();

      emit(state.copyWith(allOrders: updatedList));
    } catch (e) {
      debugPrint('Gagal update status pengiriman ke API: $e');
    }
  }

  Future<void> _onCreateCashierOrder(
      CreateCashierOrderEvent event, Emitter<AdminState> emit) async {
    try {
      await _orderApiService.registerCustomer(
        name: event.customerName,
        phone: event.customerPhone,
      );

      await _orderApiService.createOrder(event.newOrder);

      final order = Map<String, dynamic>.from(event.newOrder);
      order['customer_name'] = event.customerName;
      order['customer_phone'] = event.customerPhone;
      final updated = List<Map<String, dynamic>>.from(state.allOrders)..insert(0, order);
      
      emit(state.copyWith(allOrders: updated, selectedOrder: order));
    } catch (e) {
      debugPrint('Gagal membuat order kasir ke API: $e');
    }
  }

  void _onAddExpense(AddExpenseEvent event, Emitter<AdminState> emit) {
    final newExpense = {
      'title': event.title,
      'amount': event.amount,
      'date': 'Hari Ini',
    };
    final updated = List<Map<String, dynamic>>.from(state.expenses)..insert(0, newExpense);
    emit(state.copyWith(expenses: updated));
  }

  void _onToggleStoreStatus(ToggleStoreStatusEvent event, Emitter<AdminState> emit) {
    emit(state.copyWith(isStoreOpen: !state.isStoreOpen));
  }

  void _onUpdateStoreHours(UpdateStoreHoursEvent event, Emitter<AdminState> emit) {
    emit(state.copyWith(openTime: event.openTime, closeTime: event.closeTime));
  }
}