import "package:flutter/material.dart";


class SeatGrid extends StatelessWidget {
  final int totalSeats;
  final List<int> bookedSeats;
  final Set<int> selectedSeats;
  final void Function(int seatNumber, bool isBooked) onSeatTap;

  const SeatGrid({ super.key, required this.totalSeats,  required this.bookedSeats,  required this.selectedSeats, required this.onSeatTap });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: totalSeats,
      itemBuilder: (context, index) {
        final seatNumber = index + 1;
        final isBooked = bookedSeats.contains(seatNumber);
        final isSelected = selectedSeats.contains(seatNumber);

        final color = isBooked
            ? Colors.grey.shade400
            : isSelected
            ? Colors.orange
            : Colors.green;

        return GestureDetector(
          onTap: () => onSeatTap(seatNumber, isBooked),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              seatNumber.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
