import 'package:flutter/material.dart';
import 'package:movie_ticket_booking/models/review_model.dart';
import '../../../shared/loader.dart';
import '/users/widgets/review/review_card.dart';
import '../../../constants/color.dart';


class ReviewSection extends StatelessWidget {
  final bool isLoading;
  final List<ReviewModel> reviews;
  final VoidCallback onAddReview;
  final int maxPreviewCount;

  const ReviewSection({
    super.key,
    required this.isLoading,
    required this.reviews,
    required this.onAddReview,
    this.maxPreviewCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(onAddReview: onAddReview),
        const SizedBox(height: 16),
        _Content(
          isLoading: isLoading,
          reviews: reviews,
          maxPreviewCount: maxPreviewCount,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onAddReview;

  const _Header({required this.onAddReview});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Reviews',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton.icon(
          onPressed: onAddReview,
          icon: Icon(Icons.add, color: AppColors.primary, size: 20),
          label: Text(
            'Add Review',
            style: TextStyle(color: AppColors.primary),
          ),
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final bool isLoading;
  final List<ReviewModel> reviews;
  final int maxPreviewCount;

  const _Content({
    required this.isLoading,
    required this.reviews,
    required this.maxPreviewCount,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Loader(content: "Loading reviews...");
    }

    if (reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.rate_review_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'No reviews yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Be the first to review!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final visibleReviews = reviews.length > maxPreviewCount ? reviews.take(maxPreviewCount).toList() : reviews;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visibleReviews.length,
      itemBuilder: (context, index) {
        return ReviewCard(review: visibleReviews[index]);
      },
    );
  }
}
