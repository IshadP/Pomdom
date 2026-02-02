import 'package:flutter/material.dart';

class RetroSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final bool isPrimary;

  const RetroSliderThumbShape({
    this.thumbRadius = 16.0, // This is kept for sizing logic
    this.isPrimary = false,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    // Matching the specific dimensions from Frame34/35: 24 width, 89 height
    return const Size(24, 89);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // --- Styling derived from Frame34 (Secondary) and Frame35 (Primary) ---
    final List<Color> gradientColors = isPrimary
        ? [const Color(0xFFF2AC4B), const Color(0xFFFAC273)]
        : [const Color(0xFFB9AB83), const Color(0xFFDDD6C1)];

    final Color borderColor = isPrimary
        ? const Color(0xFFFCCD89)
        : const Color(0xFFE4DECD);

    // Dimensions
    final double scale =
        1.0 + (activationAnimation.value * 0.1); // 10% increase
    final double width = 24.0 * scale;
    final double height = 60.0 * scale;

    // Create the Rect centered on the slider track
    final Rect rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    // Define the RRect (BorderRadius.circular(30))
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(30),
    );

    // --- 1. Draw the Gradient Background ---
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(1.00, 0.50),
        end: const Alignment(0.00, 0.50),
        colors: gradientColors,
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);

    // --- 2. Draw the Border (Stroke) ---
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(rrect, borderPaint);
  }
}
