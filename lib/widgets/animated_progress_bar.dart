import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double percentage; // 0.0 to 1.0
  final double height;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.percentage,
    this.height = 8,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        return Container(
          width: totalWidth,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: percentage),
                duration: duration,
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Container(
                    width: totalWidth * value,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: AppColors.redGradient,
                      borderRadius: BorderRadius.circular(height / 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
