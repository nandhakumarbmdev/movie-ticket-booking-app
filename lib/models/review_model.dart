class ReviewModel {
  final String? reviewId;
  final String userId;
  final String movieId;
  final String name;
  final double rating;
  final String comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  ReviewModel({
    this.reviewId,
    required this.userId,
    required this.movieId,
    required this.name,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['review_id'],
      userId: json['user_id'],
      movieId: json['movie_id'],
      name: json['name'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'movie_id': movieId,
      'name': name,
      'rating': rating,
      'comment': comment,
    };
  }

}
