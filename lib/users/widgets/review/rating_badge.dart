import 'package:flutter/material.dart';
import '../../../constants/color.dart';

class RatingBadge extends StatelessWidget {
  final bool isLoading;
  final double averageRating;
  final int totalReviews;

  const RatingBadge({
    super.key,
    required this.isLoading,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 8),

          Text(
            isLoading ? '...' : averageRating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            '/10',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),

          const SizedBox(width: 8),

          if (!isLoading)
            Text(
              '($totalReviews ${totalReviews == 1 ? 'vote' : 'votes'})',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
