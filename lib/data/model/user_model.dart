class Role {
  final int id;
  final String name; // 'admin', 'staff_dapur', 'customer'
  final String? description;

  const Role({
    required this.id,
    required this.name,
    this.description,
  });

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
    );
  }
}

class User {
  final int id;
  final int roleId;
  final String name;
  final String email;
  final String phone;
  final String? password;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.roleId,
    required this.name,
    required this.email,
    required this.phone,
    this.password,
    required this.createdAt,
  });

  bool get isAdmin => roleId == 1;
  bool get isStaffDapur => roleId == 2;
  bool get isCustomer => roleId == 3;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      roleId: map['role_id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}