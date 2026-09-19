class CustomerRequest {
  final String name;
  final String phone;

  CustomerRequest({required this.name, required this.phone});

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
      };
}

class CustomerResponse {
  final int id;
  final String name;
  final String phone;

  CustomerResponse({required this.id, required this.name, required this.phone});

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}