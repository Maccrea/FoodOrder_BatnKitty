import 'package:dio/dio.dart';
import '/core/network/api_endpoint.dart';
import '/data/model/customer_model.dart';
import '/data/model/order_model.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> registerCustomer(CustomerRequest request) async {
    return await _dio.post(
      ApiEndpoints.customers,
      data: request.toJson(),
    );
  }

  Future<Response> createOrder(CreateOrderRequest request) async {
    return await _dio.post(
      ApiEndpoints.orders,
      data: request.toJson(),
    );
  }

  Future<Response> updateOrderStatus({
    required int orderId,
    required String statusPesanan, // approved, rejected, processing, completed, cancelled, expired
  }) async {
    return await _dio.patch(
      ApiEndpoints.updateOrderStatus(orderId),
      data: {'status_pesanan': statusPesanan},
    );
  }

  Future<Response> mockPayment(int orderId) async {
    return await _dio.post(
      ApiEndpoints.mockPayment(orderId),
      data: {}, 
    );
  }

  Future<Response> updateKitchenStatus({
    required int orderId,
    required String statusMasak, // Pending, Proses, Selesai
  }) async {
    return await _dio.patch(
      ApiEndpoints.updateKitchenStatus(orderId),
      data: {'status_masak': statusMasak},
    );
  }
}