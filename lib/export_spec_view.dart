import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'color_vision_controller.dart';
import 'wondrix_palette.dart';

class ExportSpecView extends StatelessWidget {
  const ExportSpecView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ColorVisionController>();
    final fgHex = '#${ctrl.foreground.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    final bgHex = '#${ctrl.background.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

    final cssCode = ':root {\n  --fg-color: $fgHex;\n  --bg-color: $bgHex;\n  --contrast: ${ctrl.contrastRatio.toStringAsFixed(2)};\n}';
    final flutterCode = 'const kForeground = Color(0x${ctrl.foreground.toARGB32().toRadixString(16).toUpperCase()});\nconst kBackground = Color(0x${ctrl.background.toARGB32().toRadixString(16).toUpperCase()});';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Color Specification Export', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _CodeSnippetCard(title: 'CSS Custom Properties', code: cssCode),
          const SizedBox(height: 16),
          _CodeSnippetCard(title: 'Flutter Dart Constants', code: flutterCode),
        ],
      ),
    );
  }
}

class _CodeSnippetCard extends StatelessWidget {
  final String title;
  final String code;

  const _CodeSnippetCard({required this.title, required this.code});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: WondrixPalette.cardSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied $title to clipboard!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: WondrixPalette.slateBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF38BDF8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
