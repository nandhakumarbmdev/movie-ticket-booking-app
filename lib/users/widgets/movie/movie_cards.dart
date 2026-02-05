import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import '../../../models/movie_model.dart';
import '../../screens/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final bool isCompact;

  const MovieCard({ super.key, required this.movie, this.isCompact = false });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? 130 : null, // Fixed width for horizontal list
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailsScreen(movie: movie),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poster
            isCompact
                ? ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.movie, size: 30, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            )
                : AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                  bottom: Radius.circular(4),
                ),
                child: Image.network(
                  movie.posterUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.movie, size: 40, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Info Section
            Padding(
              padding: isCompact
                  ? const EdgeInsets.all(6)
                  : const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Rating and Vote Count Row (Both compact and full)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Average Rating (Left)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: isCompact ? 11 : 13,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            movie.averageRating != null
                                ? movie.averageRating!.toStringAsFixed(1)
                                : 'N/A',
                            style: TextStyle(
                              fontSize: isCompact ? 9 : 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Vote Count (Right)
                      Flexible(
                        child: Text(
                          movie.ratingCount != null
                              ? _formatRatingCount(movie.ratingCount!)
                              : '0 votes',
                          style: TextStyle(
                            fontSize: isCompact ? 8 : 10,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isCompact ? 4 : 6),

                  // Movie Title
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: isCompact ? 10 : 14,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                    maxLines: isCompact ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatRatingCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M votes';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K votes';
    } else {
      return '$count votes';
    }
  }
}