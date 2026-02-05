import "package:flutter/material.dart";

import "../constants/color.dart";

class AnimatedAppLogoShimmer extends StatefulWidget {
  const AnimatedAppLogoShimmer({super.key});

  @override
  State<AnimatedAppLogoShimmer> createState() => _AnimatedAppLogoShimmerState();
}

class _AnimatedAppLogoShimmerState extends State<AnimatedAppLogoShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.local_movies,
            color: AppColors.whiteColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.whiteColor,
                    AppColors.primary
                  ],
                  stops: [
                    _controller.value - 0.3,
                    _controller.value,
                    _controller.value + 0.3,
                  ],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: Text(
                'Box Office',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                  letterSpacing: 0.5,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}