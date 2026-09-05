class CustomerCatalogState {
  final bool isStoreOpen;
  final int currentOrdersToday;
  final int maxDailyQuota;
  final List<Map<String, dynamic>> activeMenus;
  final List<Map<String, dynamic>> myOrders;
  final String? message;
  final bool isError;

  const CustomerCatalogState({
    this.isStoreOpen = true,
    this.currentOrdersToday = 8,
    this.maxDailyQuota = 10,
    this.activeMenus = const [],
    this.myOrders = const [],
    this.message,
    this.isError = false,
  });

  bool get canOrder => isStoreOpen && currentOrdersToday < maxDailyQuota;
  int get remainingQuota => (maxDailyQuota - currentOrdersToday).clamp(0, maxDailyQuota);

  CustomerCatalogState copyWith({
    bool? isStoreOpen,
    int? currentOrdersToday,
    int? maxDailyQuota,
    List<Map<String, dynamic>>? activeMenus,
    List<Map<String, dynamic>>? myOrders,
    String? message,
    bool? isError,
  }) {
    return CustomerCatalogState(
      isStoreOpen: isStoreOpen ?? this.isStoreOpen,
      currentOrdersToday: currentOrdersToday ?? this.currentOrdersToday,
      maxDailyQuota: maxDailyQuota ?? this.maxDailyQuota,
      activeMenus: activeMenus ?? this.activeMenus,
      myOrders: myOrders ?? this.myOrders,
      message: message,
      isError: isError ?? false,
    );
  }
}