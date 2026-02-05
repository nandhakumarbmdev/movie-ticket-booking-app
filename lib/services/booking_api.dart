import '../constants/api_routes.dart';
import '../services/api_client.dart';

class BookingService {

  static Future<void> bookSeats({ required String userId, required String showId, required List<int> seats }) async {
    await ApiClient.dio.post(
      ApiRoutes.createBooking,
      data: {
        "user_id": userId,
        "show_id": showId,
        "seats": seats,
      },
    );
  }
}
