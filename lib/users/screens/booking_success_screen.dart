import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_ticket_booking/shared/my_logger.dart';
import '/services/api_client.dart';
import '../../constants/api_routes.dart';
import '../../constants/color.dart';
import '../../models/show_movie_data_model.dart';
import '../../models/movie_model.dart';
import '../../shared/loader.dart';
import '../widgets/booking/ticket_card.dart';
import '../widgets/movie/movie_cards.dart';
import '../widgets/primary_button.dart';

// Model
class BookingScreenData {
  final ShowMovieData showMovieData;
  final List<MovieModel> recommendedMovies;

  BookingScreenData({
    required this.showMovieData,
    required this.recommendedMovies,
  });
}

class BookingSuccessScreen extends StatefulWidget {
  final String showId;
  final List<int> seatNumbers;
  final int totalAmount;
  final String paymentMethod;

  const BookingSuccessScreen({
    super.key,
    required this.showId,
    required this.seatNumbers,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen> {
  late final Future<BookingScreenData> _future;
  late final String _bookingId;

  @override
  void initState() {
    super.initState();
    _bookingId = _generateBookingId();
    _future = _fetchShowMovie();
  }

  String _generateBookingId() {
    final r = Random();
    return 'BMS${r.nextInt(999999).toString().padLeft(6, '0')}';
  }

  Future<BookingScreenData> _fetchShowMovie() async {
    try {
      final response = await ApiClient.dio.post(
        ApiRoutes.getShowDetails,
        data: {"show_id": widget.showId},
      );

      final data = response.data['data'];
      if (data == null) {
        throw Exception("No data in response");
      }

      return BookingScreenData(
        showMovieData: ShowMovieData.fromJson(data),
        recommendedMovies: (data['recommended_movies'] as List? ?? [])
            .map((e) => MovieModel.fromJson(e))
            .toList(),
      );
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.response?.data['message'] ?? e.message ?? "Network error",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<BookingScreenData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader(content: "Loading your ticket...");
          }

          if (snapshot.hasError) {
            MyLogger.log("BookingSuccessScreen error: ${snapshot.error}");
            return const Center(
              child: Text("Something went wrong!"),
            );
          }

          final data = snapshot.data!;
          final showMovieData = data.showMovieData;
          final recommendedMovies = data.recommendedMovies;

          final localTime = showMovieData.startTime.toLocal();
          final showDate = DateFormat('EEE, dd MMM yyyy').format(localTime);
          final showTime = DateFormat('hh:mm a').format(localTime);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    TicketCard(
                      data: showMovieData,
                      bookingId: _bookingId,
                      showDate: showDate,
                      showTime: showTime,
                      seatNumbers: widget.seatNumbers,
                      paymentMethod: widget.paymentMethod,
                      totalAmount: widget.totalAmount,
                    ),

                    if (recommendedMovies.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Icon(
                            Icons.movie_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'You might also like',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendedMovies.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return MovieCard(
                              movie: recommendedMovies[index],
                              isCompact: true,
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              PrimaryButton(
                text: 'Back to Home',
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
              ),
            ],
          );
        },
      ),
    );
  }
}
