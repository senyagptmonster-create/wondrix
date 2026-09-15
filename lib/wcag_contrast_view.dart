import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'color_vision_controller.dart';
import 'wondrix_palette.dart';

class WcagContrastView extends StatelessWidget {
  const WcagContrastView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ColorVisionController>();
    final ratio = ctrl.contrastRatio;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: WondrixPalette.cardSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Luminance Contrast Ratio', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 10),
                Text(
                  '${ratio.toStringAsFixed(2)}:1',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: ctrl.passesAA ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Badge(label: 'AA Normal', passed: ctrl.passesAA),
                    _Badge(label: 'AAA Enhanced', passed: ctrl.passesAAA),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: WondrixPalette.cardSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('WCAG 2.1 Threshold Guidelines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 12),
                  Text('• 4.5:1 Minimum contrast for regular body text (AA)'),
                  SizedBox(height: 6),
                  Text('• 3.0:1 Minimum contrast for large text (18pt+) & UI components'),
                  SizedBox(height: 6),
                  Text('• 7.0:1 Enhanced contrast for maximum readability (AAA)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final bool passed;

  const _Badge({required this.label, required this.passed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: passed ? const Color(0xFF14532D) : const Color(0xFF7F1D1D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(passed ? Icons.check : Icons.close, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
