import 'package:flutter/material.dart';
import 'package:movie_ticket_booking/models/review_model.dart';
import 'package:movie_ticket_booking/users/widgets/movie/poster_section.dart';
import '../../constants/api_routes.dart';
import '../widgets/primary_button.dart';
import '/users/widgets/review/review_section.dart';
import '../../constants/color.dart';
import '../../models/movie_model.dart';
import '../../providers/movie_provider.dart';
import '../../providers/user_provider.dart';
import "package:provider/provider.dart";
import '../../services/api_client.dart';
import '../widgets/review/add_review_bottom_sheet.dart';
import 'theatre_show_time_screen.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsScreen({ super.key, required this.movie });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _isLoading = true;
  double _averageRating = 0.0;
  int _totalReviews = 0;
  List<ReviewModel> _reviews = [];


  @override
  void initState() {
    super.initState();
    _fetchMovieReviews();
  }

  Future<void> _fetchMovieReviews() async {
    try {
      setState(() => _isLoading = true);

      final response = await ApiClient.dio.post(
        ApiRoutes.getReviewsByMovie,
        data: {
          'movie_id': widget.movie.movieId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          _averageRating = (data['averageRating'] ?? 0).toDouble();
          _totalReviews = data['totalReviews'] ?? 0;

          _reviews = (data['reviews'] as List)
              .map((e) => ReviewModel.fromJson(e))
              .toList();

          _isLoading = false;
        });
      }
    } catch (e) {
      _isLoading = false;
      debugPrint("Review fetch error: $e");
    }
  }


  void _showAddReviewDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return AddReviewBottomSheet(
          onSubmit: (rating, comment) async {
            final user = context.read<UserProvider>().user!;

            await ApiClient.dio.post(
              ApiRoutes.createReview,
              data: {
                'movie_id': widget.movie.movieId,
                'user_id': user.userId,
                'rating': rating * 2,
                'comment': comment,
                'name': user.name,
              },
            );
            await _fetchMovieReviews();
            context.read<MovieProvider>().loadMovies(refresh: true);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(widget.movie.title),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PosterSection(
                      posterUrl: widget.movie.posterUrl,
                      isLoading: _isLoading,
                      averageRating: _averageRating,
                      totalReviews: _totalReviews,
                    ),

                    const SizedBox(height: 20),
                    Text(
                      "About the movie",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      widget.movie.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 24),

                    ReviewSection(
                      isLoading: _isLoading,
                      reviews: _reviews,
                      onAddReview: _showAddReviewDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PrimaryButton(
        text: 'Book Tickets',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TheatreShowTimeScreen(
                movieId: widget.movie.movieId,
              ),
            ),
          );
        },
      ),
    );
  }
}