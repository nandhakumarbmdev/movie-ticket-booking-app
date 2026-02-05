import 'package:flutter/material.dart';
import '/constants/color.dart';
import '../../../models/movie_model.dart';
import "package:intl/intl.dart";

class MovieDetails extends StatelessWidget {
  final MovieModel movie;

  const MovieDetails({ super.key, required this.movie });

  @override
  Widget build(BuildContext context) {

    final formattedDate = DateFormat('dd MMM, yyyy').format(
      movie.releaseDate.toLocal(),
    );

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          /// Language + Genre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  movie.language.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  movie.genre.join(', '),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Duration
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 14),
              const SizedBox(width: 4),

              Text(
                '${movie.durationMinutes} mins',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(width: 6),
              Text(
                '·',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),

              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
    );
  }
}