import "package:flutter/material.dart";

import "../../../constants/color.dart";

class BottomBar extends StatelessWidget {
  final int price;
  final int selectedCount;
  final bool loading;
  final VoidCallback onProceed;

  const BottomBar({ super.key, required this.price, required this.selectedCount, required this.loading, required this.onProceed });

  @override
  Widget build(BuildContext context) {
    final total = price * selectedCount;

    return Container(
      color: AppColors.whiteColor,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedCount == 0 ? "Select seats"
                : "$selectedCount seats • ₹$total",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: selectedCount == 0 || loading ? null : onProceed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.whiteColor
            ),
            child: loading
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ) : const Text("Proceed"),
          ),
        ],
      ),
    );
  }
}
