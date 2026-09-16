import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/wondrix_theme.dart';

class ColorVisionDeficiencyPainter extends CustomPainter {
  final String cvdMode; // 'Normal', 'Protanopia', 'Deuteranopia', 'Tritanopia'
  final Color sampleColor;

  ColorVisionDeficiencyPainter({
    required this.cvdMode,
    required this.sampleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.42;

    // Outer wheel segments with simulated shift
    const segments = 12;
    for (int i = 0; i < segments; i++) {
      final startAng = (i * 2 * pi / segments) - pi / 2;
      final sweepAng = (2 * pi / segments);

      final hue = (i * 360 / segments);
      final normalColor = HSVColor.fromAHSV(1.0, hue, 0.85, 0.9).toColor();
      final displayColor = _simulateCvd(normalColor, cvdMode);

      final arcPaint = Paint()
        ..color = displayColor
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAng,
        sweepAng,
        true,
        arcPaint,
      );
    }

    // Inner cutout ring
    final innerPaint = Paint()
      ..color = WondrixTheme.surface
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.55, innerPaint);

    // Center sample target swatch
    final swatchPaint = Paint()
      ..color = _simulateCvd(sampleColor, cvdMode)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.4, swatchPaint);

    final borderPaint = Paint()
      ..color = WondrixTheme.edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius * 0.4, borderPaint);
  }

  Color _simulateCvd(Color c, String mode) {
    switch (mode) {
      case 'Protanopia': // Red-blind: shift reds to browns/yellows
        final r = (c.r * 0.566 + c.g * 0.433).clamp(0.0, 1.0);
        final g = (c.r * 0.558 + c.g * 0.442).clamp(0.0, 1.0);
        final b = (c.b * 0.75).clamp(0.0, 1.0);
        return Color.fromRGBO((r * 255).round(), (g * 255).round(), (b * 255).round(), 1.0);
      case 'Deuteranopia': // Green-blind
        final r = (c.r * 0.625 + c.g * 0.375).clamp(0.0, 1.0);
        final g = (c.r * 0.70 + c.g * 0.30).clamp(0.0, 1.0);
        final b = (c.b * 0.70).clamp(0.0, 1.0);
        return Color.fromRGBO((r * 255).round(), (g * 255).round(), (b * 255).round(), 1.0);
      case 'Tritanopia': // Blue-blind
        final r = (c.r * 0.95 + c.g * 0.05).clamp(0.0, 1.0);
        final g = (c.g * 0.433 + c.b * 0.567).clamp(0.0, 1.0);
        final b = (c.g * 0.475 + c.b * 0.525).clamp(0.0, 1.0);
        return Color.fromRGBO((r * 255).round(), (g * 255).round(), (b * 255).round(), 1.0);
      default:
        return c;
    }
  }

  @override
  bool shouldRepaint(covariant ColorVisionDeficiencyPainter oldDelegate) {
    return oldDelegate.cvdMode != cvdMode || oldDelegate.sampleColor != sampleColor;
  }
}
