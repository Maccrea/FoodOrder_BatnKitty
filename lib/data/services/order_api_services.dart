import 'package:batnkitty_food/core/network/api_client.dart';
import 'package:dio/dio.dart';
import '/core/network/api_endpoint.dart';

class OrderApiService {
  final Dio _dio;

OrderApiService([ApiClient? apiClient]) : _dio = (apiClient ?? ApiClient()).dio;
  Future<Response> registerCustomer({
    required String name,
    required String phone,
  }) async {
    return await _dio.post(
      ApiEndpoints.customers,
      data: {'name': name, 'phone': phone},
    );
  }

  Future<Response> createOrder(Map<String, dynamic> orderData) async {
    return await _dio.post(ApiEndpoints.orders, data: orderData);
  }

  Future<Response> updateOrderStatus(int orderId, String status) async {
    return await _dio.patch(
      ApiEndpoints.updateOrderStatus(orderId),
      data: {'status_pesanan': status},
    );
  }

  Future<Response> mockPayment(int orderId) async {
    return await _dio.post(ApiEndpoints.mockPayment(orderId));
  }

  Future<Response> updateKitchenStatus(
    int orderId,
    String kitchenStatus,
  ) async {
    return await _dio.patch(
      ApiEndpoints.updateKitchenStatus(orderId),
      data: {'status_masak': kitchenStatus},
    );
  }

  Future<Response> getOrders() async {
    return await _dio.get('/orders');
  }

  Future<List<Map<String, dynamic>>> getCustomerOrders({
    int? customerId,
    String? phone,
  }) async {
    final response = await getOrders();
    final responseData = response.data;
    final rawOrders = responseData is List
        ? responseData
        : responseData is Map && responseData['data'] is List
            ? responseData['data'] as List
            : const [];

    return rawOrders
        .whereType<Map>()
        .map((order) => Map<String, dynamic>.from(order))
        .where((order) {
          final customer = order['customer'];
          final orderCustomerId = order['customer_id'] ?? order['user_id'];
          final orderPhone = order['customer_phone'] ?? order['phone'];
          final nestedCustomerId = customer is Map ? customer['id'] : null;
          final nestedPhone = customer is Map ? customer['phone'] : null;

          return (customerId != null &&
                  (orderCustomerId == customerId || nestedCustomerId == customerId)) ||
              (phone != null &&
                  (orderPhone == phone || nestedPhone == phone));
        })
        .toList();
  }

  Future<Response> getMenus() async {
    return await _dio.get('/menus');
  }

  Future<List<Map<String, dynamic>>> getActiveMenus() async {
    final response = await getMenus();
    final responseData = response.data;
    final rawMenus = responseData is List
        ? responseData
        : responseData is Map && responseData['data'] is List
            ? responseData['data'] as List
            : const [];

    return rawMenus
        .whereType<Map>()
        .map((menu) => Map<String, dynamic>.from(menu))
        .where((menu) => menu['is_active'] != false)
        .toList();
  }
}
