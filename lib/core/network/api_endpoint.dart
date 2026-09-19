class ApiEndpoints {
  static const String customers = '/customers';
  static const String orders = '/orders';
  static String updateOrderStatus(int id) => '/orders/$id/status';
  static String mockPayment(int id) => '/orders/$id/mock-pay';
  static String updateKitchenStatus(int id) => '/orders/$id/kitchen';
}