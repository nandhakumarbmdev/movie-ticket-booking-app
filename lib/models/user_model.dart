class UserModel {
  final String userId;
  final String name;
  final String email;
  final String role;
  final String address;
  final bool isActive;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.address,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      address: json['address'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'role': role,
      'address': address,
      'is_active': isActive,
    };
  }
}
