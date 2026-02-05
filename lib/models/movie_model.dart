class MovieModel {
  final String movieId;
  final String title;
  final int durationMinutes;
  final List<String> genre;
  final String language;
  final String posterUrl;
  final DateTime releaseDate;
  final String description;
  final int? ratingCount;
  final int? averageRating;
  final bool isActive;

  MovieModel({
    required this.movieId,
    required this.title,
    required this.durationMinutes,
    required this.genre,
    required this.language,
    required this.posterUrl,
    required this.releaseDate,
    required this.description,
    this.ratingCount,
    this.averageRating,
    required this.isActive,
  });


  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      movieId: json['movie_id'] as String,
      title: json['title'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      genre: List<String>.from(json['genre'] ?? []),
      language: json['language'] ?? '',
      posterUrl: json['poster_url'] ?? '',
      releaseDate: DateTime.parse(json['release_date']),
      description: json['description'] ?? '',
      ratingCount: json['rating_count'] ?? 0,
      averageRating: json['average_rating'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie_id': movieId,
      'title': title,
      'duration_minutes': durationMinutes,
      'genre': genre,
      'language': language,
      'poster_url': posterUrl,
      'release_date': releaseDate,
      'description': description,
      'is_active': isActive,
    };
  }
}
