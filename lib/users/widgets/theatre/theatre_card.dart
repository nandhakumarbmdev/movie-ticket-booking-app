import "package:flutter/material.dart";
import "/users/widgets/theatre/show_times.dart";
import "/users/widgets/theatre/theatre_header.dart";

class TheatreCard extends StatelessWidget {
  final Map<String, dynamic> theatre;
  final List<Map<String, dynamic>> shows;

  const TheatreCard({super.key, required this.theatre, required this.shows});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TheatreHeader(theatre: theatre),
          const SizedBox(height: 16),
          ShowTimes(shows: shows),
        ],
      ),
    );
  }
}