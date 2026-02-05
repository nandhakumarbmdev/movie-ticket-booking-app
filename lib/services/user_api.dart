import 'package:dio/dio.dart';
import '../constants/api_routes.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class UserApi {

  static Future<void> createUser({ required String token, required String name, required String email }) async {
    try {
      await ApiClient.dio.post(ApiRoutes.createUser, data: { 'name': name, 'email': email },
        options: Options(
          headers: { 'Authorization': 'Bearer $token' },
        ),
      );
    } on DioException{
      rethrow;
    }
  }

  static Future<UserModel> getUserByEmail({ required String email }) async {
    try {
      final response = await ApiClient.dio.post(ApiRoutes.getUserByEmail, data: { "email": email });
      return UserModel.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  static Future<void> updateProfile({ required String userId, required String name, required String address }) async {
    try {
      await ApiClient.dio.post( ApiRoutes.updateUser, data: {
          'user_id': userId,
          'name': name,
          'address': address,
        },
      );
    } on DioException {
      rethrow;
    }
  }
}
