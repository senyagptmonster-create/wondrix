import 'package:flutter/material.dart';
import 'wondrix_palette.dart';

class AccessiblePalettesView extends StatelessWidget {
  const AccessiblePalettesView({super.key});

  @override
  Widget build(BuildContext context) {
    final sets = [
      {
        'name': 'Okabe-Ito Scientific Palette',
        'desc': 'Universally distinguishable under Protanopia, Deuteranopia & Tritanopia.',
        'colors': [
          Color(0xFFE69F00), // Orange
          Color(0xFF56B4E9), // Sky Blue
          Color(0xFF009E73), // Bluish Green
          Color(0xFFF0E442), // Yellow
          Color(0xFF0072B2), // Blue
          Color(0xFFD55E00), // Vermillion
        ],
      },
      {
        'name': 'Paul Tol Bright Palette',
        'desc': 'High-contrast vibrant qualitative swatches verified across CVD spectra.',
        'colors': [
          Color(0xFF4477AA), // Blue
          Color(0xFF66CCEE), // Cyan
          Color(0xFF228833), // Green
          Color(0xFFCCBB44), // Yellow
          Color(0xFFEE6677), // Red
          Color(0xFFAA3377), // Purple
        ],
      },
      {
        'name': 'ColorBrewer Safe Qualitative',
        'desc': 'Geographic and data chart certified color-blind friendly spectrum.',
        'colors': [
          Color(0xFF7FC97F),
          Color(0xFFBEAED4),
          Color(0xFFFDC086),
          Color(0xFFFFFF99),
          Color(0xFF386CB0),
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sets.length,
      itemBuilder: (context, idx) {
        final s = sets[idx];
        final list = s['colors'] as List<Color>;

        return Card(
          color: WondrixPalette.cardSurface,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text(s['desc'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 14),
                Row(
                  children: list.map((c) {
                    return Expanded(
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: c,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
