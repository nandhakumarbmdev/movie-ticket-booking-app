import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:movie_ticket_booking/shared/loader.dart';
import 'package:movie_ticket_booking/shared/my_logger.dart';
import 'package:provider/provider.dart';
import 'package:movie_ticket_booking/admin/widgets/movies/admin_movie_card.dart';
import 'package:movie_ticket_booking/models/movie_model.dart';
import 'package:movie_ticket_booking/providers/movie_provider.dart';
import 'package:movie_ticket_booking/constants/color.dart';
import 'package:movie_ticket_booking/constants/api_routes.dart';
import 'package:movie_ticket_booking/services/api_client.dart';
import 'movie_form_screen.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadMovies();
    });
  }

  Future<void> _refreshMovies() async {
    await context.read<MovieProvider>().loadMovies(refresh: true);
  }

  Future<void> _deleteMovie(String id) async {
    try {
      MyLogger.log(id);
      await ApiClient.dio.post(ApiRoutes.deleteMovie, data: {'movie_id': id});

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Movie deleted successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      await _refreshMovies();
    } on DioException catch (e) {
      if (!mounted) return;

      final message = e.response?.data?['message'] ??
          e.message ??
          'Failed to delete movie';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An unexpected error occurred'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void navigateToAddEdit({MovieModel? movie}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieFormScreen(movie: movie),
      ),
    );

    if (result == true) {
      _refreshMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          // Loading state (initial load)
          if (movieProvider.loading && movieProvider.movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading movies...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (movieProvider.movies.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_outlined,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No movies found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Add your first movie to get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => navigateToAddEdit(),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        'Add Movie',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshMovies,
            color: AppColors.primary,
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 80,
                  ),
                  itemCount: movieProvider.movies.length,
                  itemBuilder: (context, index) {
                    final movie = movieProvider.movies[index];
                    return AdminMovieCard(
                      movie: movie,
                      onEdit: () => navigateToAddEdit(movie: movie),
                      onDelete: () => _deleteMovie(movie.movieId),
                    );
                  },
                ),

                if (movieProvider.loading && movieProvider.movies.isNotEmpty) Loader(content: "Refreshing...")
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigateToAddEdit(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 22),
        label: const Text(
          'Add Movie',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 4,
      ),
    );
  }
}