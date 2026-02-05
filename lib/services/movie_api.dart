import 'package:dio/dio.dart';
import '../constants/api_routes.dart';
import './api_client.dart';
import '../models/movie_model.dart';

class MovieApi {

  static Future<List<MovieModel>> getAllMovies() async {
    try {
      final response = await ApiClient.dio.post(ApiRoutes.getAllMovies);

      final List data = response.data['data'];
      return data.map((json) => MovieModel.fromJson(json)).toList();
    } on DioException {
      rethrow;
    }
  }

  static Future<MovieModel> createMovie(Map<String, dynamic> payload) async {
    try {
      final response = await ApiClient.dio.post(ApiRoutes.createMovie, data: payload );

      if (response.data['success'] == true) {
        return MovieModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create movie');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<MovieModel> updateMovie( String movieId, Map<String, dynamic> payload) async {
    try {
      final data = {
        'movie_id': movieId,
        ...payload,
      };

      final response = await ApiClient.dio.post(ApiRoutes.updateMovie, data: data );

      if (response.data['success'] == true) {
        return MovieModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update movie');
      }
    } catch (e) {
      rethrow;
    }
  }
}
