import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'color_vision_controller.dart';
import 'wondrix_palette.dart';

class PaletteValidatorView extends StatelessWidget {
  const PaletteValidatorView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ColorVisionController>();
    final simFg = ctrl.simulate(ctrl.foreground, ctrl.activeCVD);
    final simBg = ctrl.simulate(ctrl.background, ctrl.activeCVD);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: simBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: WondrixPalette.borderGray),
            ),
            child: Center(
              child: Text(
                'Sample Headline Text',
                style: TextStyle(
                  color: simFg,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('CVD Simulation Filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: CVDType.values.map((cvd) {
              return ChoiceChip(
                label: Text(cvd.name.toUpperCase()),
                selected: ctrl.activeCVD == cvd,
                onSelected: (_) => ctrl.setCVD(cvd),
                selectedColor: WondrixPalette.accentIndigo,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Foreground Color Swatches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          _ColorRow(
            selected: ctrl.foreground,
            colors: const [
              Color(0xFF00FFCC),
              Color(0xFFFF5252),
              Color(0xFFFFD700),
              Color(0xFFFFFFFF),
              Color(0xFF448AFF),
            ],
            onSelect: (c) => ctrl.setForeground(c),
          ),
          const SizedBox(height: 16),
          const Text('Background Color Swatches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          _ColorRow(
            selected: ctrl.background,
            colors: const [
              Color(0xFF1E293B),
              Color(0xFF0F172A),
              Color(0xFF000000),
              Color(0xFF374151),
              Color(0xFF1E1B4B),
            ],
            onSelect: (c) => ctrl.setBackground(c),
          ),
        ],
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  final Color selected;
  final List<Color> colors;
  final ValueChanged<Color> onSelect;

  const _ColorRow({required this.selected, required this.colors, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: colors.map((c) {
        final isSel = c.toARGB32() == selected.toARGB32();
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => onSelect(c),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSel ? Colors.white : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
