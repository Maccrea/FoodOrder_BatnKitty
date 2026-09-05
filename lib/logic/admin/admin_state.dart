import 'package:flutter/material.dart';

class AdminState  {
  final List<Map<String, dynamic>> allOrders;
  final List<Map<String, dynamic>> menus;
  final List<Map<String, dynamic>> expenses;
  final Map<String, dynamic>? selectedOrder;
  final String statusFilter;
  final String fulfillmentFilter;
  final String searchQuery;
  final DateTime selectedDeliveryDate;
  final bool isLoading;

  final bool isStoreOpen;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;

  AdminState({
    this.allOrders = const [],
    this.menus = const [],
    this.expenses = const [],
    this.selectedOrder,
    this.statusFilter = 'all',
    this.fulfillmentFilter = 'all',
    this.searchQuery = '',
    DateTime? selectedDeliveryDate,
    this.isLoading = false,
    this.isStoreOpen = true,
    this.openTime = const TimeOfDay(hour: 8, minute: 0),
    this.closeTime = const TimeOfDay(hour: 20, minute: 0),
  }) : selectedDeliveryDate = selectedDeliveryDate ?? DateTime(2026, 9, 7);

  bool get isCurrentlyOpen {
    if (!isStoreOpen) return false;
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final openMinutes = openTime.hour * 60 + openTime.minute;
    final closeMinutes = closeTime.hour * 60 + closeTime.minute;
    return nowMinutes >= openMinutes && nowMinutes <= closeMinutes;
  }

  num get totalRevenue {
    num sum = 0;
    for (var o in allOrders) {
      final bayar = (o['status_bayar'] ?? '').toString().toLowerCase();
      final status = (o['status_pesanan'] ?? '').toString().toLowerCase();
      final masak = (o['status_masak'] ?? '').toString().toLowerCase();
      if (bayar == 'lunas' ||
          bayar == 'paid' ||
          status == 'completed' ||
          status == 'processing' ||
          masak == 'selesai' ||
          masak == 'cooking') {
        sum += ((o['total_price'] as num?) ?? 0);
      }
    }
    return sum;
  }

  num get totalExpensesAmount =>
      expenses.fold<num>(0, (sum, e) => sum + ((e['amount'] as num?) ?? 0));

  num get netProfit => totalRevenue - totalExpensesAmount;

  int get totalWaiting =>
      allOrders.where((o) => o['status_pesanan'] == 'waiting_approve').length;
  int get totalApproved =>
      allOrders.where((o) => o['status_pesanan'] == 'approved').length;
  int get totalKitchen => allOrders
      .where((o) =>
          o['status_pesanan'] == 'processing' ||
          o['status_masak'] == 'Cooking' ||
          o['status_masak'] == 'Proses')
      .length;
  int get totalCompleted =>
      allOrders.where((o) => o['status_pesanan'] == 'completed').length;
  int get totalDelivery =>
      allOrders.where((o) => o['delivery_type'] == 'Delivery').length;
  int get totalPickup =>
      allOrders.where((o) => o['delivery_type'] == 'Pickup').length;

  List<Map<String, dynamic>> get deliveryTasksOnDate {
    final targetStr =
        '${selectedDeliveryDate.year}-${selectedDeliveryDate.month.toString().padLeft(2, '0')}-${selectedDeliveryDate.day.toString().padLeft(2, '0')}';
    return allOrders.where((o) {
      final isDelivery = o['delivery_type'] == 'Delivery';
      final pickupDate = (o['tanggal_pengambilan'] ?? '').toString();
      return isDelivery && pickupDate.startsWith(targetStr);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredOrders {
    return allOrders.where((o) {
      final status = (o['status_pesanan'] ?? '').toString();
      final masak = (o['status_masak'] ?? '').toString();

      bool matchStatus = true;
      if (statusFilter == 'waiting_approve') {
        matchStatus = status == 'waiting_approve';
      } else if (statusFilter == 'approved') {
        matchStatus = status == 'approved';
      } else if (statusFilter == 'processing') {
        matchStatus = status == 'processing' || masak == 'Cooking' || masak == 'Proses';
      } else if (statusFilter == 'completed') {
        matchStatus = status == 'completed' || masak == 'Selesai';
      }

      final matchFulfillment =
          fulfillmentFilter == 'all' || o['delivery_type'] == fulfillmentFilter;

      final q = searchQuery.toLowerCase();
      final matchQuery = q.isEmpty ||
          (o['menu_name'] ?? '').toString().toLowerCase().contains(q) ||
          (o['customer_name'] ?? '').toString().toLowerCase().contains(q) ||
          (o['id'] ?? '').toString().contains(q);

      return matchStatus && matchFulfillment && matchQuery;
    }).toList();
  }

  AdminState copyWith({
    List<Map<String, dynamic>>? allOrders,
    List<Map<String, dynamic>>? menus,
    List<Map<String, dynamic>>? expenses,
    Map<String, dynamic>? selectedOrder,
    String? statusFilter,
    String? fulfillmentFilter,
    String? searchQuery,
    DateTime? selectedDeliveryDate,
    bool? isLoading,
    bool? isStoreOpen,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
  }) {
    return AdminState(
      allOrders: allOrders ?? this.allOrders,
      menus: menus ?? this.menus,
      expenses: expenses ?? this.expenses,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      statusFilter: statusFilter ?? this.statusFilter,
      fulfillmentFilter: fulfillmentFilter ?? this.fulfillmentFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDeliveryDate: selectedDeliveryDate ?? this.selectedDeliveryDate,
      isLoading: isLoading ?? this.isLoading,
      isStoreOpen: isStoreOpen ?? this.isStoreOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  @override
  List<Object?> get props => [
        allOrders,
        menus,
        expenses,
        selectedOrder,
        statusFilter,
        fulfillmentFilter,
        searchQuery,
        selectedDeliveryDate,
        isLoading,
        isStoreOpen,
        openTime,
        closeTime,
      ];
}