import 'package:flutter/material.dart';
import '/constants/api_routes.dart';
import '/services/api_client.dart';
import '/shared/loader.dart';
import '../../constants/color.dart';
import '../../shared/empty_state.dart';
import '../widgets/theatre/date_selector.dart';
import '../widgets/theatre/show_times.dart';

class MoviesByTheatreScreen extends StatefulWidget {
  final String theatreId;
  final String theatreName;

  const MoviesByTheatreScreen({
    super.key,
    required this.theatreId,
    required this.theatreName,
  });

  @override
  State<MoviesByTheatreScreen> createState() => _MoviesByTheatreScreenState();
}

class _MoviesByTheatreScreenState extends State<MoviesByTheatreScreen> {
  bool _loading = true;
  DateTime _selectedDate = DateTime.now();

  /// Backend response:
  /// [
  ///   {
  ///     movie_id,
  ///     title,
  ///     language,
  ///     shows: [ ... ]
  ///   }
  /// ]
  List<Map<String, dynamic>> _movies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    if (!mounted) return;

    setState(() => _loading = true);

    try {
      final response = await ApiClient.dio.post(
        ApiRoutes.getMoviesByTheatre,
        data: {
          'theatre_id': widget.theatreId,
          'date': _selectedDate.toIso8601String().split('T')[0],
        },
      );

      if (!mounted) return;

      setState(() {
        _movies =
        List<Map<String, dynamic>>.from(response.data['data'] ?? []);
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // ✅ BODY BACKGROUND
      appBar: _buildAppBar(),
      body: Column(
        children: [
          /// Date selector strip (white)
          Container(
            color: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: DateSelector(
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
              daysCount: 7,
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      leading: const BackButton(color: Colors.black),
      title: Text(
        widget.theatreName,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBody() {
    // 1️⃣ Loading state
    if (_loading) {
      return const Center(
        child: Loader(content: 'Loading shows...'),
      );
    }

    // 2️⃣ Empty state (after API returns)
    if (_movies.isEmpty) {
      return const Center(
        child: EmptyState(
          content: "No shows available for this date",
        ),
      );
    }

    // 3️⃣ Data available
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _movies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final movie = _movies[index];
        final shows =
        List<Map<String, dynamic>>.from(movie['shows'] ?? []);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.s`tart,
            children: [
              Text(
                "${movie['title']} - ${movie['language']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ShowTimes(shows: shows),
            ],
          ),
        );
      },
    );
  }

}
