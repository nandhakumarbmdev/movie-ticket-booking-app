import "package:flutter/material.dart";
import "/models/movie_model.dart";
import "/users/widgets/movie/movie_details.dart";
import "../../../constants/color.dart";
import "../../../models/show_movie_data_model.dart";

class TicketCard extends StatelessWidget {
  final ShowMovieData data;
  final String bookingId;
  final String showDate;
  final String showTime;
  final List<int> seatNumbers;
  final String paymentMethod;
  final int totalAmount;

  const TicketCard({
    super.key,
    required this.data,
    required this.bookingId,
    required this.showDate,
    required this.showTime,
    required this.seatNumbers,
    required this.paymentMethod,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Movie Info Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Poster
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data.posterUrl,
                        width: 100,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.movie, size: 40),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: MovieDetails(
                        movie: MovieModel(
                          title: data.title,
                          durationMinutes: data.duration,
                          description: "",
                          genre: data.genres,
                          language: data.language,
                          posterUrl: data.posterUrl,
                          releaseDate: data.startTime,
                          movieId: "",
                          isActive: true,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey[300]),

              // Booking Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(
                      Icons.confirmation_number_outlined,
                      'Booking ID',
                      bookingId,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.calendar_today_outlined,
                      'Date',
                      showDate,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.access_time_outlined,
                      'Show Time',
                      showTime,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.event_seat_outlined,
                      'Seats',
                      seatNumbers.join(', '),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.payment_outlined,
                      'Payment',
                      paymentMethod,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '₹$totalAmount',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Stamp Seal "CONFIRMED"
        Positioned(
          top: 220,
          right: 50,
          child: Transform.rotate(
            angle: 0.4, // Slight rotation for stamp effect
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'CONFIRMED',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}