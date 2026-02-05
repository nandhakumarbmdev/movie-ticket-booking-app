import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import '../../screens/seat_selection_screen.dart';

class ShowTimes extends StatelessWidget {
  final List<Map<String, dynamic>> shows;

  const ShowTimes({super.key, required this.shows});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: shows.map((show) {
        final int availableSeats = show['available_seats'];
        final int totalSeats = show['total_seats'];
        final int price = show['price'];
        final bool isAvailable = availableSeats > 0;

        final DateTime startTime =
        DateTime.parse(show['start_time']).toLocal();

        // Calculate seat availability percentage
        final double availabilityPercentage =
            (availableSeats / totalSeats) * 100;

        // Determine color based on availability
        final Color borderColor = _getAvailabilityColor(availabilityPercentage);

        return InkWell(
          onTap: isAvailable
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SeatSelectionScreen(
                  showId: show['show_id'],
                ),
              ),
            );
          } : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isAvailable ? borderColor : Colors.grey.shade400,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Start Time only
                Text(
                  _formatSingleTime(startTime),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isAvailable
                        ? Colors.grey.shade800
                        : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),

                /// Price + seat availability
                Text(
                  '₹$price • $availableSeats/$totalSeats seats',
                  style: TextStyle(
                    fontSize: 11,
                    color: isAvailable
                        ? Colors.grey.shade600
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getAvailabilityColor(double percentage) {
    if (percentage >= 50) {
      return const Color(0xFF7BC67E); // BookMyShow green
    } else if (percentage >= 20) {
      return const Color(0xFFF4BD6B); // Warning orange
    } else {
      return AppColors.primary.withOpacity(0.6); // Alert red
    }
  }

  String _formatSingleTime(DateTime date) {
    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '$hour:$minute $period';
  }
}