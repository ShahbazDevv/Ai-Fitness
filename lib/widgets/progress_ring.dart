import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProgressRing extends StatelessWidget {
  final double percentage; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Widget? centerWidget;

  const ProgressRing({
    super.key,
    required this.percentage,
    this.size = 180,
    this.strokeWidth = 8,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressRingPainter(
              percentage: percentage,
              strokeWidth: strokeWidth,
            ),
          ),
          if (centerWidget != null)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: centerWidget!,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.percentage,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background track
    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Draw progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * percentage;

    final progressPaint = Paint()
      ..shader = const SweepGradient(
        colors: [
          AppColors.primary,
          AppColors.primaryDark,
          AppColors.primary,
        ],
        stops: [0.0, 0.5, 1.0],
        transform: GradientRotation(startAngle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.strokeWidth != strokeWidth;
  }
}
