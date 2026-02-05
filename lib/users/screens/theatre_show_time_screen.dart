import 'package:flutter/material.dart';
import '../../services/theatre_api.dart';
import '../../shared/loader.dart';
import '../../shared/empty_state.dart';
import '../widgets/theatre/date_selector.dart';
import '../widgets/theatre/theatre_card.dart';
import '/constants/color.dart';

class TheatreShowTimeScreen extends StatefulWidget {
  final String movieId;

  const TheatreShowTimeScreen({super.key, required this.movieId});

  @override
  State<TheatreShowTimeScreen> createState() => _TheatreShowTimeScreenState();
}

class _TheatreShowTimeScreenState extends State<TheatreShowTimeScreen> {
  late Future<List<dynamic>> _theatres;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchTheatres();
  }

  void _fetchTheatres() {
    _theatres = TheatreService.fetchTheatresByMovie(widget.movieId, _selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
        foregroundColor: Colors.black87,
        title: const Text(
          "Select Theatre & Show",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Date Selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: DateSelector(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                  _fetchTheatres();
                });
              },
            ),
          ),

          // Theatre List
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _theatres,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader(content: "Loading theatres...");
                }

                if (snapshot.hasError) {
                  return EmptyState(
                    content: snapshot.error.toString(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const EmptyState(
                    content: "No shows available for this date",
                  );
                }

                final theatres = snapshot.data!;

                return Container(
                  color: AppColors.backgroundColor,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: theatres.length,
                        itemBuilder: (context, index) {
                          final theatre = theatres[index];
                          final shows = List<Map<String, dynamic>>.from(theatre['shows']);

                          return TheatreCard(
                            theatre: theatre,
                            shows: shows,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}