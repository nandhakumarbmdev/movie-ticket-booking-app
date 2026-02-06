import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../constants/api_routes.dart';
import '../../constants/color.dart';
import '../../services/notification_service.dart';
import '/users/screens/payment_screen.dart';
import 'package:provider/provider.dart';

import '../../models/seat_model.dart';
import '../../providers/user_provider.dart';
import '../../services/api_client.dart';
import '../../services/booking_api.dart';
import '../../shared/loader.dart';
import '../widgets/seat/bottom_bar.dart';
import '../widgets/seat/seat_grid.dart';
import '../widgets/seat/seat_legend.dart';


class SeatSelectionScreen extends StatefulWidget {
  final String showId;

  const SeatSelectionScreen({ super.key, required this.showId });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  late Future<SeatModel> _seatFuture;
  final Set<int> _selectedSeats = {};
  final bool _bookingLoading = false;

  @override
  void initState() {
    super.initState();
    _seatFuture = _fetchSeats(widget.showId);
  }

  Future<void> _bookSeats(int price) async {
    if (_selectedSeats.isEmpty || _bookingLoading) return;

    final userProvider = context.read<UserProvider>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          totalAmount: price * _selectedSeats.length,
          selectedSeats: _selectedSeats.length,
          seatNumbers: _selectedSeats.toList(),
          showId: widget.showId,
          userId: userProvider.user!.userId,
          onPaymentSuccess: () {
            _performActualBooking(userProvider.user!.userId);
          },
        ),
      ),
    );
  }

  Future<void> _performActualBooking(String userId) async {
    try {
      await BookingService.bookSeats(
        userId: userId,
        showId: widget.showId,
        seats: _selectedSeats.toList(),
      );
      _seatFuture = _fetchSeats(widget.showId);

      NotificationService.instance.showLocalNotification(
        title: '🎬 Booking Confirmed',
        body: 'Your seat has been reserved successfully.',
      );
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.toString())),
      );
    }
  }

  Future<SeatModel> _fetchSeats(String showId) async {
    try {
      final response = await ApiClient.dio.post(
        ApiRoutes.getShowSeats,
        data: {"show_id": showId},
      );

      final data = response.data['data'];

      if (data == null) {
        throw Exception("Seat data missing");
      }

      return SeatModel.fromJson(data);
    } catch (e) {
      debugPrint("Seat fetch failed: $e");

      return SeatModel(
        totalSeats: 0,
        price: 0,
        bookedSeats: const [],
      );
    }
  }

  void _onSeatTap(int seatNumber, bool isBooked) {
    if (isBooked || _bookingLoading) return;

    if (_selectedSeats.length >= 5 && !_selectedSeats.contains(seatNumber)) {
      final messenger = ScaffoldMessenger.of(context);

      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(
          content: Text("You can select maximum 5 seats"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }


    setState(() {
      _selectedSeats.contains(seatNumber)
          ? _selectedSeats.remove(seatNumber)
          : _selectedSeats.add(seatNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Select Seats"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
      ),
      body: FutureBuilder<SeatModel>(
        future: _seatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader(content: "Loading seats...",);
          }

          final data = snapshot.data;

          if (data == null || data.totalSeats == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Something went wrong!"),
                  const SizedBox(height: 12),
                ],
              ),
            );
          }

          return Column(
            children: [
              const SeatLegend(),
              Expanded(
                child: SeatGrid(
                  totalSeats: data.totalSeats,
                  bookedSeats: data.bookedSeats,
                  selectedSeats: _selectedSeats,
                  onSeatTap: _onSeatTap,
                ),
              ),
              BottomBar(
                price: data.price,
                selectedCount: _selectedSeats.length,
                loading: _bookingLoading,
                onProceed: () => _bookSeats(data.price),
              ),
            ],
          );
        },
      ),
    );
  }
}