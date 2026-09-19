class OrderItemModel {
  final String menuName;
  final int quantity;
  final int unitPrice;
  final String? customNotes;

  OrderItemModel({
    required this.menuName,
    required this.quantity,
    required this.unitPrice,
    this.customNotes,
  });

  Map<String, dynamic> toJson() => {
        'menu_name': menuName,
        'quantity': quantity,
        'unit_price': unitPrice,
        if (customNotes != null) 'custom_notes': customNotes,
      };
}

class CreateOrderRequest {
  final int customerId;
  final String tanggalPengambilan; // Format: "YYYY-MM-DD HH:mm:ss"
  final String deliveryType;
  final String? deliveryAddress;
  final int deliveryFee;
  final List<OrderItemModel> items;

  CreateOrderRequest({
    required this.customerId,
    required this.tanggalPengambilan,
    this.deliveryType = 'Pickup',
    this.deliveryAddress,
    this.deliveryFee = 0,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'customer_id': customerId,
        'tanggal_pengambilan': tanggalPengambilan,
        'delivery_type': deliveryType,
        'delivery_address': deliveryAddress,
        'delivery_fee': deliveryFee,
        'items': items.map((x) => x.toJson()).toList(),
      };
}