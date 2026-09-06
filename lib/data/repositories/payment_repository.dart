abstract class PaymentRepository {
  Future<Map<String, dynamic>> chargeQris({
    required int orderId,
    required num amount,
  });

  Future<String> checkPaymentStatus(String transactionId);
}

class MockMidtransPaymentRepository implements PaymentRepository {
  @override
  Future<Map<String, dynamic>> chargeQris({
    required int orderId,
    required num amount,
  }) async {
    // Simulasi latency network API
    await Future.delayed(const Duration(milliseconds: 600));

    final fee = (amount * 0.007).round(); // MDR QRIS 0.7%
    final transactionId = 'TRX-BATKITTY-$orderId-${DateTime.now().millisecondsSinceEpoch}';

    // Payload standar format QRIS Midtrans Core API
    return {
      'transaction_id': transactionId,
      'order_id': orderId,
      'gross_amount': amount,
      'fee_amount': fee,
      'payment_status': 'pending',
      'qris_payload': '00020101021226680016ID.MIDTRANS.WWW0118936009110000000000520458125802ID5913BATKITTY_FOOD6008SEMARANG62070703A016304',
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<String> checkPaymentStatus(String transactionId) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulasi webhook berhasil
    return 'success';
  }
}