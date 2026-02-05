import 'package:flutter/material.dart';
import 'package:movie_ticket_booking/models/review_model.dart';
import '../../../constants/color.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({ super.key, required this.review });

  @override
  Widget build(BuildContext context) {
    final String name = review.name;
    final String comment = review.comment;
    final bool hasComment = comment.isNotEmpty;

    // Rating is assumed 0–10 from backend
    final int rawRating = review.rating.clamp(0, 10).toInt();
    final int stars = (rawRating / 2).round().clamp(0, 5);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              name: name,
              stars: stars,
            ),
            const SizedBox(height: 12),
            _StarsRow(stars: stars),
            if (hasComment) ...[
              const SizedBox(height: 12),
              _CommentBox(comment: comment),
            ],
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final int stars;

  const _Header({
    required this.name,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Avatar(letter: name[0].toUpperCase()),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        _RatingBadge(stars: stars),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String letter;

  const _Avatar({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final int stars;

  const _RatingBadge({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _ratingColor(stars),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(stars.toString(), style: TextStyle(color: AppColors.whiteColor),)
        ],
      ),
    );
  }
}

class _StarsRow extends StatelessWidget {
  final int stars;

  const _StarsRow({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          5,
              (i) => Icon(
            i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
            color: i < stars ? Colors.amber.shade600 : Colors.grey.shade300,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _ratingText(stars),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _CommentBox extends StatelessWidget {
  final String comment;

  const _CommentBox({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        comment,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 14,
          height: 1.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

const _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  boxShadow: [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ],
);

Color _ratingColor(int rating) {
  if (rating >= 4) return Colors.green;
  if (rating >= 3) return Colors.orange;
  return Colors.red;
}

String _ratingText(int rating) {
  switch (rating) {
    case 5:
      return 'Excellent';
    case 4:
      return 'Very Good';
    case 3:
      return 'Good';
    case 2:
      return 'Average';
    case 1:
      return 'Poor';
    default:
      return 'No Rating';
  }
}
