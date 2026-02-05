import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../../constants/color.dart";
import "../../providers/user_provider.dart";
import "../../shared/animated_app_logo_shimmer.dart";

class Header extends AppBar {
  Header({super.key})
      : super(
    backgroundColor: AppColors.whiteColor,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
    automaticallyImplyLeading: false,
    toolbarHeight: 97,
    titleSpacing: 0,
    title: const _HeaderContent(),
  );
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final name = user?.name.trim();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnimatedAppLogoShimmer(),
              const SizedBox(height: 8),
              Text(
                "Hi, ${name ?? 'Guest'}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
