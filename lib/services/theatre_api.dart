import 'package:dio/dio.dart';
import '../constants/api_routes.dart';
import '../models/theatre_model.dart';
import 'api_client.dart';

class TheatreService {

  static Future<List<dynamic>> fetchTheatresByMovie(String movieId, DateTime date) async {
    try {
      final response = await ApiClient.dio.post(ApiRoutes.getTheatresByMovie,data: {
        "date": date.toIso8601String().split('T').first,
        "movie_id": movieId
      });
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load theatres',
      );
    }
  }

  static Future<List<TheatreModel>> getAllTheatres() async {
    try {
      final response = await ApiClient.dio.post(ApiRoutes.getAllTheatre);

      final dynamic responseData = response.data;

      List<dynamic> theatreList;
      if (responseData is List) {
        theatreList = responseData;
      } else if (responseData is Map<String, dynamic>) {
        theatreList = responseData['data'] ??
            responseData['theatres'] ??
            responseData['results'] ??
            [];
      } else {
        theatreList = [];
      }

      return theatreList.map((json) => TheatreModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<TheatreModel> createTheatre(Map<String, dynamic> payload) async {
    try {
      final response = await ApiClient.dio.post(
        ApiRoutes.createTheatre,
        data: payload,
      );

      if (response.data['success'] == true) {
        return TheatreModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create theatre');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<TheatreModel> updateTheatre( String theatreId, Map<String, dynamic> payload ) async {
    try {
      final data = {
        'theatre_id': theatreId,
        ...payload,
      };

      final response = await ApiClient.dio.post(
        ApiRoutes.updateTheatre,
        data: data,
      );


      if (response.data['success'] == true) {
        return TheatreModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update theatre');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteTheatre(String theatreId) async {
    try {
      final response = await ApiClient.dio.post(
        ApiRoutes.deleteTheatre,
        data: {'theatre_id': theatreId},
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to delete theatre');
      }
    } catch (e) {
      rethrow;
    }
  }

}
