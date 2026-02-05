import "package:flutter/material.dart";
import "../../../constants/color.dart";
import "../review/rating_badge.dart";

class PosterSection extends StatelessWidget {
  final String posterUrl;
  final bool isLoading;
  final double averageRating;
  final int totalReviews;

  const PosterSection({
    super.key,
    required this.posterUrl,
    required this.isLoading,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 400,
        width: double.infinity,
        color: AppColors.whiteColor,
        child: Stack(
          children: [
            Image.network(
              posterUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.movie, size: 100, color: Colors.grey),
                );
              },
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Rating Badge
            Positioned(
              bottom: 20,
              left: 20,
              child: RatingBadge(
                isLoading: isLoading,
                averageRating: averageRating,
                totalReviews: totalReviews,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
