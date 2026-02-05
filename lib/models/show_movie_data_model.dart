class ShowMovieData {
  final String title;
  final String posterUrl;
  final List<String> genres;
  final String language;
  final int duration;
  final DateTime startTime;
  final int? averageRating;
  final int? ratingCount;

  ShowMovieData({
    required this.title,
    required this.posterUrl,
    required this.genres,
    required this.language,
    required this.duration,
    required this.startTime,
    this.averageRating,
    this.ratingCount,
  });

  factory ShowMovieData.fromJson(Map<String, dynamic> json) {
    return ShowMovieData(
      title: json['movie']['title'],
      posterUrl: json['movie']['poster_url'],
      genres: List<String>.from(json['movie']['genre']),
      language: json['movie']['language'],
      duration: json['movie']['duration_minutes'],
      startTime: DateTime.parse(json['show']['start_time']),
      averageRating: json['movie']['average_rating'],
      ratingCount: json['movie']['rating_count'],
    );
  }
}