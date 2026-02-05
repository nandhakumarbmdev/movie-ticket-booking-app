class TheatreModel {
  final String theatreId;
  final String name;
  final String city;
  final String address;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  TheatreModel({
    required this.theatreId,
    required this.name,
    required this.city,
    required this.address,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TheatreModel.fromJson(Map<String, dynamic> json) {
    return TheatreModel(
      theatreId: json['theatre_id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theatre_id': theatreId,
      'name': name,
      'city': city,
      'address': address,
      'is_active': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TheatreModel copyWith({
    String? theatreId,
    String? name,
    String? city,
    String? address,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TheatreModel(
      theatreId: theatreId ?? this.theatreId,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}