import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../widgets/primary_button.dart';
import 'booking_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final int totalAmount;
  final int selectedSeats;
  final List<int> seatNumbers;
  final String showId;
  final String userId;
  final VoidCallback onPaymentSuccess;

  const PaymentScreen({ super.key, required this.totalAmount, required this.selectedSeats,
    required this.seatNumbers,
    required this.showId,
    required this.userId,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = '';
  bool isProcessing = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Payment'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seats: ${widget.seatNumbers.join(", ")}',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${widget.totalAmount}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Select Payment Method',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPaymentOption(
                  'UPI',
                  Icons.account_balance_wallet,
                  'Google Pay, PhonePe, Paytm & more',
                ),
                _buildPaymentOption(
                  'Credit Card',
                  Icons.credit_card,
                  'Visa, Mastercard, Amex',
                ),
                _buildPaymentOption(
                  'Debit Card',
                  Icons.credit_card,
                  'Visa, Mastercard, Rupay',
                ),
                _buildPaymentOption(
                  'Net Banking',
                  Icons.account_balance,
                  'All major banks',
                ),
              ],
            ),
          ),
          PrimaryButton(
            text: isProcessing
                ? 'Processing...'
                : 'Pay ₹${widget.totalAmount}',
            isDisabled: selectedPaymentMethod.isEmpty || isProcessing,
            onPressed: _processPayment,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption( String title, IconData icon, String subtitle ) {
    final bool isSelected = selectedPaymentMethod == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
            isSelected ? AppColors.primary : AppColors.backgroundColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color:
                isSelected ? AppColors.primary : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.primary
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() {
      isProcessing = true;
    });

    widget.onPaymentSuccess();

    if (!mounted) return;

    setState(() {
      isProcessing = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSuccessScreen(
          seatNumbers: widget.seatNumbers,
          totalAmount: widget.totalAmount,
          paymentMethod: selectedPaymentMethod,
          showId: widget.showId,
        ),
      ),
    );
  }
}
