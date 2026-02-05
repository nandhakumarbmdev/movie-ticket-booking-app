class ScreenModel {
  final String screenId;
  final String name;
  final String theatreId;
  final int totalSeats;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ScreenModel({
    required this.screenId,
    required this.name,
    required this.theatreId,
    required this.totalSeats,
    this.createdAt,
    this.updatedAt,
  });

  factory ScreenModel.fromJson(Map<String, dynamic> json) {
    return ScreenModel(
      screenId: json['screen_id'] ?? '',
      name: json['name'] ?? '',
      theatreId: json['theatre_id'] ?? '',
      totalSeats: json['total_seats'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screen_id': screenId,
      'name': name,
      'theatre_id': theatreId,
      'total_seats': totalSeats,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}