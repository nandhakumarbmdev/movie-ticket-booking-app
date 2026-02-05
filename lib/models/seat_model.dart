class SeatModel {
  final int totalSeats;
  final int price;
  final List<int> bookedSeats;

  SeatModel({ required this.totalSeats, required this.price, required this.bookedSeats });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    final rawBookedSeats = json['booked_seats'];

    final bookedSeats = rawBookedSeats.cast<int>().toList();

    return SeatModel(
      totalSeats: json['total_seats'],
      price: json['price'],
      bookedSeats: bookedSeats,
    );
  }

}